import 'package:finance_core/finance_core.dart';
import 'package:finance_data/finance_data.dart';
import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/data_providers.dart';
import 'account_visuals.dart';

/// Banks offered first, matching the statement presets. "Other bank" works
/// with the column mapper.
const _banks = [
  'HDFC Bank',
  'ICICI Bank',
  'State Bank of India',
  'Axis Bank',
  'Kotak Mahindra Bank',
];
const _otherBank = 'Other bank';

/// Bottom sheet that adds a bank account, card, cash, wallet or investment
/// account. Returns the new account, or null if dismissed.
Future<Account?> showAddAccountSheet(BuildContext context) =>
    showModalBottomSheet<Account>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _AccountSheet(),
    );

/// Bottom sheet that renames an account or changes its opening balance.
Future<void> showEditAccountSheet(
  BuildContext context,
  Account account,
  Paise balance,
) => showModalBottomSheet<void>(
  context: context,
  useRootNavigator: true,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => _AccountSheet(editing: account, balance: balance),
);

class _AccountSheet extends ConsumerStatefulWidget {
  const _AccountSheet({this.editing, this.balance});

  final Account? editing;
  final Paise? balance;

  @override
  ConsumerState<_AccountSheet> createState() => _AccountSheetState();
}

class _AccountSheetState extends ConsumerState<_AccountSheet> {
  late AccountKind _kind = widget.editing?.kind ?? AccountKind.bankAccount;
  String? _bank;
  final _otherName = TextEditingController();
  late final _nickname = TextEditingController(
    text: widget.editing?.displayName,
  );
  final _last4 = TextEditingController();
  late final _opening = TextEditingController(
    text: switch (widget.editing?.openingBalancePaise) {
      null || 0 => '',
      final p => formatInr(
        Paise(p),
        symbol: false,
        paise: PaiseDisplay.whenNonZero,
      ),
    },
  );
  bool _saving = false;

  bool get _editing => widget.editing != null;

  bool get _isBank =>
      _kind == AccountKind.bankAccount || _kind == AccountKind.creditCard;

  @override
  void dispose() {
    _otherName.dispose();
    _nickname.dispose();
    _last4.dispose();
    _opening.dispose();
    super.dispose();
  }

  String? get _institution {
    if (_kind == AccountKind.cash) return 'Cash';
    if (!_isBank) {
      final n = _nickname.text.trim();
      return n.isEmpty ? null : n;
    }
    if (_bank == _otherBank) {
      final n = _otherName.text.trim();
      return n.isEmpty ? null : n;
    }
    return _bank;
  }

  bool get _last4Ok =>
      _last4.text.isEmpty || RegExp(r'^\d{4}$').hasMatch(_last4.text);

  /// Null when empty (zero), or when it isn't an amount.
  Paise? get _openingValue =>
      _opening.text.trim().isEmpty ? Paise.zero : Paise.tryParse(_opening.text);

  bool get _ready =>
      !_saving &&
      _openingValue != null &&
      (_editing
          ? _nickname.text.trim().isNotEmpty
          : _institution != null && _last4Ok);

  Future<void> _save() async {
    if (!_ready) return;
    setState(() => _saving = true);
    final repo = await ref.read(accountsRepositoryProvider.future);
    final opening = _openingValue!;
    if (_editing) {
      await repo.update(
        widget.editing!.id,
        displayName: _nickname.text,
        openingBalance: opening,
      );
      if (mounted) Navigator.of(context).pop();
      return;
    }
    final institution = _institution!;
    final short = institution.replaceAll(RegExp(r'\s+Bank$'), '');
    final fallback = switch (_kind) {
      AccountKind.creditCard => '$short Card',
      AccountKind.bankAccount => '$short Savings',
      _ => institution,
    };
    final account = await repo.create(
      kind: _kind,
      institution: institution,
      displayName: _nickname.text.trim().isNotEmpty
          ? _nickname.text.trim()
          : fallback,
      last4: _isBank && _last4.text.isNotEmpty ? _last4.text : null,
      openingBalance: opening,
    );
    if (mounted) Navigator.of(context).pop(account);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final c = context.colors;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Space.screen,
        0,
        Space.screen,
        Space.screen + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _editing ? 'Edit account' : 'Add an account',
              style: theme.headlineMedium,
            ),
            const SizedBox(height: Space.xs),
            Text(
              _editing
                  ? 'The balance is the opening balance plus money in less '
                        'money out.'
                  : 'Statements are imported into an account, so you can '
                        'tell them apart and spot transfers between them. '
                        'Add cash or a wallet to note spends by hand.',
              style: theme.bodyMedium,
            ),
            if (!_editing) ...[
              const SizedBox(height: Space.l),
              Wrap(
                spacing: Space.s,
                runSpacing: Space.s,
                children: [
                  for (final k in AccountKind.values)
                    ChoiceChip(
                      avatar: Icon(accountIcon(k), size: 18),
                      label: Text(accountKindLabel(k)),
                      selected: _kind == k,
                      showCheckmark: false,
                      onSelected: (_) => setState(() => _kind = k),
                    ),
                ],
              ),
            ],
            if (!_editing && _isBank) ...[
              const SizedBox(height: Space.l),
              Text('Bank', style: theme.titleMedium),
              const SizedBox(height: Space.s),
              Wrap(
                spacing: Space.s,
                runSpacing: Space.s,
                children: [
                  for (final b in [..._banks, _otherBank])
                    CategoryChip(
                      label: b,
                      color: c.primary,
                      selected: _bank == b,
                      onTap: () => setState(() => _bank = b),
                    ),
                ],
              ),
              if (_bank == _otherBank) ...[
                const SizedBox(height: Space.m),
                TextField(
                  controller: _otherName,
                  decoration: const InputDecoration(labelText: 'Bank name'),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ],
            const SizedBox(height: Space.m),
            TextField(
              controller: _nickname,
              decoration: InputDecoration(
                labelText: !_editing && (_isBank || _kind == AccountKind.cash)
                    ? 'Nickname (optional)'
                    : 'Name',
                hintText: switch (_kind) {
                  AccountKind.wallet => 'Paytm wallet',
                  AccountKind.investment => 'Mutual funds',
                  AccountKind.cash => 'Cash in hand',
                  _ => 'Salary account',
                },
              ),
              textCapitalization: TextCapitalization.sentences,
              onChanged: (_) => setState(() {}),
            ),
            if (!_editing && _isBank) ...[
              const SizedBox(height: Space.m),
              TextField(
                controller: _last4,
                decoration: InputDecoration(
                  labelText: 'Last 4 digits (optional)',
                  helperText:
                      'Helps match SMS alerts later. Only the last four.',
                  errorText: _last4Ok ? null : 'Enter exactly four digits',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                onChanged: (_) => setState(() {}),
              ),
            ],
            const SizedBox(height: Space.m),
            TextField(
              controller: _opening,
              decoration: InputDecoration(
                labelText: 'Opening balance (optional)',
                prefixText: '₹ ',
                helperText: _kind == AccountKind.creditCard
                    ? 'What you owed before, as a minus amount.'
                    : 'What it held before the first transaction here.',
                errorText: _openingValue == null ? 'Enter an amount' : null,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: Space.xl),
            PillButton(
              label: _editing ? 'Save' : 'Add account',
              expand: true,
              onPressed: _ready ? _save : null,
            ),
          ],
        ),
      ),
    );
  }
}
