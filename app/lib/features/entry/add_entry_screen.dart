import 'package:finance_core/finance_core.dart';
import 'package:finance_data/finance_data.dart';
import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/data_providers.dart';
import '../../common/format.dart';
import '../accounts/account_visuals.dart';
import '../accounts/add_account_sheet.dart';
import '../categories/category_picker.dart';
import '../categories/category_visuals.dart';

/// Add a spend, income or a move between your accounts by hand, with a
/// calculator keypad for the amount.
class AddEntryScreen extends ConsumerStatefulWidget {
  const AddEntryScreen({super.key, this.kind = EntryKind.expense});

  final EntryKind kind;

  @override
  ConsumerState<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends ConsumerState<AddEntryScreen> {
  late var _kind = widget.kind;
  var _sum = '';
  String? _accountId;
  String? _toAccountId;
  String? _categoryId;
  var _date = LocalDate.today();
  var _time = TimeOfDay.now();
  final _note = TextEditingController();
  var _saving = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Paise? get _amount => evaluateAmount(_sum);

  Future<String?> _pickAccount(List<Account> accounts, String title) async {
    final balances = ref.read(accountBalancesProvider).value ?? const {};
    final picked = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Space.screen),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              for (final a in accounts)
                ListTile(
                  leading: Icon(accountIcon(a.kind)),
                  title: Text(a.displayName),
                  trailing: MoneyText(
                    balances[a.id] ?? Paise.zero,
                    paise: PaiseDisplay.never,
                  ),
                  onTap: () => Navigator.of(context).pop(a.id),
                ),
              ListTile(
                leading: const Icon(Icons.add_rounded),
                title: const Text('Add an account'),
                onTap: () => Navigator.of(context).pop(''),
              ),
            ],
          ),
        ),
      ),
    );
    if (picked != '' || !mounted) return picked;
    final made = await showAddAccountSheet(context);
    return made?.id;
  }

  Future<void> _pickCategory(List<Category> categories) async {
    final choice = await showCategoryPicker(
      context,
      categories: [
        for (final c in categories)
          if (c.spendClass != SpendClass.transfer) c,
      ],
      direction: _kind == EntryKind.income ? Direction.credit : Direction.debit,
      currentId: _categoryId,
    );
    if (choice != null) setState(() => _categoryId = choice.categoryId);
  }

  Future<void> _save(List<Account> accounts) async {
    final amount = _amount;
    final from = _accountId ?? accounts.firstOrNull?.id;
    if (amount == null || amount <= Paise.zero || from == null) return;
    if (_kind == EntryKind.transfer &&
        (_toAccountId == null || _toAccountId == from)) {
      return;
    }
    setState(() => _saving = true);
    final entries = await ref.read(manualEntriesProvider.future);
    await entries.add(
      kind: _kind,
      amount: amount,
      accountId: from,
      toAccountId: _toAccountId,
      categoryId: _kind == EntryKind.transfer ? null : _categoryId,
      date: _date,
      time: Duration(hours: _time.hour, minutes: _time.minute),
      note: _note.text,
    );
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          '${formatInr(amount)} ${switch (_kind) {
            EntryKind.expense => 'spend',
            EntryKind.income => 'income',
            EntryKind.transfer => 'transfer',
          }} added.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final c = context.colors;
    final accounts = ref.watch(accountsProvider).value ?? const <Account>[];
    final categories =
        ref.watch(categoriesProvider).value ?? const <Category>[];
    final byId = {for (final a in accounts) a.id: a};
    final from = byId[_accountId] ?? accounts.firstOrNull;
    final to = byId[_toAccountId];
    final category = categories.where((c) => c.id == _categoryId).firstOrNull;
    final amount = _amount;
    final transfer = _kind == EntryKind.transfer;
    final ready =
        amount != null &&
        amount > Paise.zero &&
        from != null &&
        (!transfer || (to != null && to.id != from.id)) &&
        !_saving;
    final hasSum = RegExp('[+−×÷]').hasMatch(_sum);
    final tone = switch (_kind) {
      EntryKind.expense => c.over,
      EntryKind.income => c.good,
      EntryKind.transfer => c.primary,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add'),
        leading: IconButton(
          tooltip: 'Close',
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: ready ? () => _save(accounts) : null,
            child: const Text('Save'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: Space.screen),
                children: [
                  SegmentedButton<EntryKind>(
                    segments: const [
                      ButtonSegment(
                        value: EntryKind.expense,
                        label: Text('Expense'),
                      ),
                      ButtonSegment(
                        value: EntryKind.income,
                        label: Text('Income'),
                      ),
                      ButtonSegment(
                        value: EntryKind.transfer,
                        label: Text('Transfer'),
                      ),
                    ],
                    showSelectedIcon: false,
                    selected: {_kind},
                    onSelectionChanged: (s) => setState(() {
                      _kind = s.first;
                      _categoryId = null;
                    }),
                  ),
                  const SizedBox(height: Space.l),
                  Row(
                    children: [
                      Expanded(
                        child: _Picker(
                          label: transfer ? 'From' : 'Account',
                          value: from?.displayName ?? 'Pick an account',
                          icon: from == null
                              ? Icons.account_balance_wallet_outlined
                              : accountIcon(from.kind),
                          onTap: () async {
                            final id = await _pickAccount(
                              accounts,
                              transfer ? 'From' : 'Account',
                            );
                            if (id != null) setState(() => _accountId = id);
                          },
                        ),
                      ),
                      const SizedBox(width: Space.s),
                      Expanded(
                        child: transfer
                            ? _Picker(
                                label: 'To',
                                value: to?.displayName ?? 'Pick an account',
                                icon: to == null
                                    ? Icons.account_balance_wallet_outlined
                                    : accountIcon(to.kind),
                                onTap: () async {
                                  final id = await _pickAccount(accounts, 'To');
                                  if (id != null) {
                                    setState(() => _toAccountId = id);
                                  }
                                },
                              )
                            : _Picker(
                                label: 'Category',
                                value: category?.name ?? 'Pick a category',
                                icon: category == null
                                    ? Icons.label_outline_rounded
                                    : categoryIcon(category),
                                color: category == null
                                    ? null
                                    : c.chartToken(category.colorToken),
                                onTap: () => _pickCategory(categories),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Space.l),
                  AppCard(
                    soft: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Semantics(
                          label: 'Amount',
                          value: amount == null ? 'none' : formatInr(amount),
                          child: Text(
                            '₹${_sum.isEmpty ? '0' : _sum}',
                            style: theme.displaySmall?.copyWith(color: tone),
                            textAlign: TextAlign.end,
                            maxLines: 2,
                          ),
                        ),
                        if (hasSum)
                          Text(
                            amount == null
                                ? "That sum doesn't work"
                                : '= ${formatInr(amount)}',
                            style: theme.bodyMedium,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Space.m),
                  TextField(
                    controller: _note,
                    decoration: const InputDecoration(
                      hintText: 'Add a note',
                      prefixIcon: Icon(Icons.notes_rounded),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: Space.s),
                  Row(
                    children: [
                      Flexible(
                        child: TextButton.icon(
                          icon: const Icon(Icons.event_rounded),
                          label: Text(formatShortDate(_date)),
                          onPressed: () async {
                            final d = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now().add(
                                const Duration(days: 366),
                              ),
                              initialDate: DateTime(
                                _date.year,
                                _date.month,
                                _date.day,
                              ),
                            );
                            if (d != null) {
                              setState(
                                () => _date = LocalDate(d.year, d.month, d.day),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: Space.s),
                      Flexible(
                        child: TextButton.icon(
                          icon: const Icon(Icons.schedule_rounded),
                          label: Text(_time.format(context)),
                          onPressed: () async {
                            final t = await showTimePicker(
                              context: context,
                              initialTime: _time,
                            );
                            if (t != null) setState(() => _time = t);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Space.m,
                Space.s,
                Space.m,
                Space.s,
              ),
              child: CalcKeypad(
                onKey: (k) => setState(() => _sum = applyKey(_sum, k)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Space.screen,
                0,
                Space.screen,
                Space.s,
              ),
              child: PillButton(
                label: switch (_kind) {
                  EntryKind.expense => 'Save expense',
                  EntryKind.income => 'Save income',
                  EntryKind.transfer => 'Save transfer',
                },
                expand: true,
                onPressed: ready ? () => _save(accounts) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A tappable box showing a label and what's picked.
class _Picker extends StatelessWidget {
  const _Picker({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
    this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final c = context.colors;
    return AppCard(
      padding: const EdgeInsets.all(Space.m),
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color ?? c.primary),
          const SizedBox(width: Space.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.bodySmall),
                Text(
                  value,
                  style: theme.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
