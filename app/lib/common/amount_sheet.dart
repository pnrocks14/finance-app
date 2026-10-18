import 'package:finance_core/finance_core.dart';
import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';

/// What the amount sheet returns: an amount, or a request to remove.
typedef AmountResult = ({Paise? amount, bool remove});

/// A sheet with the calculator keypad for one amount, such as a budget
/// limit. With [canRemove], also offers a remove button.
Future<AmountResult?> showAmountSheet(
  BuildContext context, {
  required String title,
  String? message,
  Paise? initial,
  bool canRemove = false,
}) => showModalBottomSheet<AmountResult>(
  context: context,
  useRootNavigator: true,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => _AmountSheet(
    title: title,
    message: message,
    initial: initial,
    canRemove: canRemove,
  ),
);

class _AmountSheet extends StatefulWidget {
  const _AmountSheet({
    required this.title,
    this.message,
    this.initial,
    this.canRemove = false,
  });

  final String title;
  final String? message;
  final Paise? initial;
  final bool canRemove;

  @override
  State<_AmountSheet> createState() => _AmountSheetState();
}

class _AmountSheetState extends State<_AmountSheet> {
  late var _sum = widget.initial == null
      ? ''
      : formatInr(
          widget.initial!,
          symbol: false,
          paise: PaiseDisplay.whenNonZero,
        ).replaceAll(',', '');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final amount = evaluateAmount(_sum);
    final ok = amount != null && amount > Paise.zero;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Space.screen,
          0,
          Space.screen,
          Space.l,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.title, style: theme.headlineSmall),
            if (widget.message case final m?) ...[
              const SizedBox(height: Space.xs),
              Text(m, style: theme.bodyMedium),
            ],
            const SizedBox(height: Space.l),
            Text(
              '₹${_sum.isEmpty ? '0' : _sum}',
              style: theme.displaySmall,
              textAlign: TextAlign.end,
            ),
            if (RegExp('[+−×÷]').hasMatch(_sum) && amount != null)
              Text(
                '= ${formatInr(amount)}',
                style: theme.bodyMedium,
                textAlign: TextAlign.end,
              ),
            const SizedBox(height: Space.m),
            CalcKeypad(onKey: (k) => setState(() => _sum = applyKey(_sum, k))),
            const SizedBox(height: Space.m),
            PillButton(
              label: 'Save',
              expand: true,
              onPressed: ok
                  ? () =>
                        Navigator.of(context)
                            .pop((amount: amount, remove: false))
                  : null,
            ),
            if (widget.canRemove) ...[
              const SizedBox(height: Space.s),
              PillButton(
                label: 'Remove',
                kind: PillButtonKind.quiet,
                expand: true,
                onPressed: () =>
                    Navigator.of(context).pop((amount: null, remove: true)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
