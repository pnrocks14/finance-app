import 'package:finance_core/finance_core.dart';
import 'package:finance_data/finance_data.dart';
import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/data_providers.dart';
import 'account_visuals.dart';
import 'add_account_sheet.dart';

/// Every account with its balance, grouped by kind, and the total across
/// them. Tap one to see its transactions, rename it or archive it.
class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).textTheme;
    final c = context.colors;
    final accounts = ref.watch(accountsProvider).value ?? const <Account>[];
    final balances = ref.watch(accountBalancesProvider).value ?? const {};
    Paise balanceOf(Account a) => balances[a.id] ?? Paise.zero;
    final total = accounts.fold(Paise.zero, (s, a) => s + balanceOf(a));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        actions: [
          IconButton(
            tooltip: 'Add an account',
            icon: const Icon(Icons.add_rounded),
            onPressed: () => showAddAccountSheet(context),
          ),
        ],
      ),
      body: accounts.isEmpty
          ? Center(
              child: EmptyState(
                title: 'No accounts yet',
                message:
                    'Add your bank accounts, cards, cash and wallets to see '
                    'what each one holds.',
                actionLabel: 'Add an account',
                onAction: () => showAddAccountSheet(context),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                Space.screen,
                Space.s,
                Space.screen,
                Space.xxxl,
              ),
              children: [
                AppCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('All accounts', style: theme.bodyMedium),
                            const SizedBox(height: Space.xs),
                            MoneyText(
                              total,
                              style: theme.headlineMedium,
                              paise: PaiseDisplay.never,
                              color: total.isNegative ? c.over : null,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        accounts.length == 1
                            ? '1 account'
                            : '${accounts.length} accounts',
                        style: theme.bodySmall,
                      ),
                    ],
                  ),
                ),
                for (final kind in AccountKind.values)
                  if (accounts.where((a) => a.kind == kind).toList()
                      case final group when group.isNotEmpty) ...[
                    SectionHeader(
                      accountKindLabel(kind),
                      action: MoneyText(
                        group.fold(Paise.zero, (s, a) => s + balanceOf(a)),
                        style: theme.titleSmall,
                        paise: PaiseDisplay.never,
                      ),
                    ),
                    for (final a in group)
                      _AccountRow(account: a, balance: balanceOf(a)),
                  ],
                const SizedBox(height: Space.xl),
                PillButton(
                  label: 'Add new account',
                  icon: Icons.add_rounded,
                  kind: PillButtonKind.secondary,
                  expand: true,
                  onPressed: () => showAddAccountSheet(context),
                ),
              ],
            ),
    );
  }
}

class _AccountRow extends ConsumerWidget {
  const _AccountRow({required this.account, required this.balance});

  final Account account;
  final Paise balance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).textTheme;
    final c = context.colors;
    final a = account;
    final detail = [
      if (a.institution != a.displayName) a.institution,
      if (a.last4 != null) '••${a.last4}',
    ].join(' · ');
    return InkWell(
      borderRadius: BorderRadius.circular(Radii.chip),
      onTap: () => _actions(context, ref),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Space.s),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: c.primary.withValues(alpha: 0.12),
              child: Icon(accountIcon(a.kind), color: c.primary, size: 20),
            ),
            const SizedBox(width: Space.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(a.displayName, style: theme.bodyLarge),
                  if (detail.isNotEmpty) Text(detail, style: theme.bodySmall),
                ],
              ),
            ),
            MoneyText(
              balance,
              style: theme.titleMedium,
              paise: PaiseDisplay.never,
              color: balance.isNegative ? c.over : null,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _actions(BuildContext context, WidgetRef ref) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                account.displayName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long_rounded),
              title: const Text('See transactions'),
              onTap: () => Navigator.of(context).pop('list'),
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit'),
              onTap: () => Navigator.of(context).pop('edit'),
            ),
            ListTile(
              leading: const Icon(Icons.archive_outlined),
              title: const Text('Archive'),
              subtitle: const Text(
                'Hides it here. Its transactions stay and still count.',
              ),
              onTap: () => Navigator.of(context).pop('archive'),
            ),
          ],
        ),
      ),
    );
    if (!context.mounted) return;
    switch (picked) {
      case 'list':
        await context.push('/transactions?account=${account.id}');
      case 'edit':
        await showEditAccountSheet(context, account, balance);
      case 'archive':
        final repo = await ref.read(accountsRepositoryProvider.future);
        await repo.archive(account.id);
    }
  }
}
