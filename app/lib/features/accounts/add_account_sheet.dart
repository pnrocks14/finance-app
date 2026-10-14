import 'package:finance_core/finance_core.dart';
import 'package:finance_data/finance_data.dart';
import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/data_providers.dart';

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

/// Bottom sheet that adds a bank account or credit card. Returns the new
/// account, or null if dismissed.
Future<Account?> showAddAccountSheet(BuildContext context) =>
    showModalBottomSheet<Account>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _AddAccountSheet(),
    );

class _AddAccountSheet extends ConsumerStatefulWidget {
  const _AddAccountSheet();

  @override
  ConsumerState<_AddAccountSheet> createState() => _AddAccountSheetState();
}

class _AddAccountSheetState extends ConsumerState<_AddAccountSheet> {
  AccountKind _kind = AccountKind.bankAccount;
  String? _bank;
  final _otherName = TextEditingController();
  final _nickname = TextEditingController();
  final _last4 = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _otherName.dispose();
    _nickname.dispose();
    _last4.dispose();
    super.dispose();
  }

  String? get _institution {
    if (_bank == _otherBank) {
      final n = _otherName.text.trim();
      return n.isEmpty ? null : n;
    }
    return _bank;
  }

  bool get _last4Ok =>
      _last4.text.isEmpty || RegExp(r'^\d{4}$').hasMatch(_last4.text);

  Future<void> _save() async {
    final institution = _institution;
    if (institution == null || !_last4Ok) return;
    setState(() => _saving = true);
    final repo = await ref.read(accountsRepositoryProvider.future);
    final kindLabel = _kind == AccountKind.creditCard ? 'Card' : 'Savings';
    final short = institution.replaceAll(RegExp(r'\s+Bank$'), '');
    final account = await repo.create(
      kind: _kind,
      institution: institution,
      displayName: _nickname.text.trim().isNotEmpty
          ? _nickname.text.trim()
          : '$short $kindLabel',
      last4: _last4.text.isEmpty ? null : _last4.text,
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
            Text('Add an account', style: theme.headlineMedium),
            const SizedBox(height: Space.xs),
            Text(
              'Statements are imported into an account, so you can tell them '
              'apart and spot transfers between them.',
              style: theme.bodyMedium,
            ),
            const SizedBox(height: Space.l),
            SegmentedButton<AccountKind>(
              segments: const [
                ButtonSegment(
                  value: AccountKind.bankAccount,
                  label: Text('Bank account'),
                ),
                ButtonSegment(
                  value: AccountKind.creditCard,
                  label: Text('Credit card'),
                ),
              ],
              showSelectedIcon: false,
              selected: {_kind},
              onSelectionChanged: (s) => setState(() => _kind = s.first),
            ),
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
            const SizedBox(height: Space.m),
            TextField(
              controller: _nickname,
              decoration: const InputDecoration(
                labelText: 'Nickname (optional)',
                hintText: 'Salary account',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: Space.m),
            TextField(
              controller: _last4,
              decoration: InputDecoration(
                labelText: 'Last 4 digits (optional)',
                helperText: 'Helps match SMS alerts later. Only the last four.',
                errorText: _last4Ok ? null : 'Enter exactly four digits',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: Space.xl),
            PillButton(
              label: 'Add account',
              expand: true,
              onPressed: _institution != null && _last4Ok && !_saving
                  ? _save
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
