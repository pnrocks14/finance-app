import 'package:finance_core/finance_core.dart';
import 'package:finance_data/finance_data.dart';
import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/data_providers.dart';
import '../../common/format.dart';
import '../lock/lock_controller.dart';
import '../transactions/transactions_screen.dart';

/// Home, phase 2 version: this month's money in and out plus the latest
/// transactions. The diagram-first home (donut, left-to-spend ring) arrives
/// in phase 4.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txs = ref.watch(transactionsProvider);
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hi there'),
        actions: [
          IconButton(
            tooltip: 'Import a statement',
            icon: const Icon(Icons.upload_file_rounded),
            onPressed: () => context.push('/import'),
          ),
          IconButton(
            tooltip: 'Style sheet',
            icon: const Icon(Icons.palette_outlined),
            onPressed: () => context.push('/style-sheet'),
          ),
          IconButton(
            tooltip: 'Lock now',
            icon: const Icon(Icons.lock_outline_rounded),
            onPressed: () =>
                ref.read(lockControllerProvider.notifier).lockNow(),
          ),
        ],
      ),
      body: SafeArea(
        child: txs.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(Space.screen),
              child: Text(
                "Couldn't open your data on this phone. Restart the app to try again.",
                style: theme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          data: (list) => list.isEmpty
              ? Center(
                  child: EmptyState(
                    title: 'Your money, all in one place',
                    message:
                        'Import a bank statement to see where every rupee '
                        'goes. It stays on this phone.',
                    actionLabel: 'Import a statement',
                    onAction: () => context.push('/import'),
                  ),
                )
              : _Overview(list),
        ),
      ),
    );
  }
}

class _Overview extends ConsumerWidget {
  const _Overview(this.transactions);

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).textTheme;
    final c = context.colors;
    final accounts = ref.watch(accountsProvider).value ?? const [];
    final names = {for (final a in accounts) a.id: a.displayName};
    final categories = {
      for (final c in ref.watch(categoriesProvider).value ?? const <Category>[])
        c.id: c,
    };

    // The month of the newest transaction, so a past statement still shows.
    final latest = transactions.first.localDate;
    final inMonth = transactions.where(
      (t) =>
          t.localDate.year == latest.year && t.localDate.month == latest.month,
    );
    var spent = 0;
    var income = 0;
    for (final t in inMonth) {
      switch (t.flow) {
        case TransactionFlow.spend:
          spent += t.amountPaise;
        case TransactionFlow.refund:
          spent -= t.amountPaise;
        case TransactionFlow.income:
          income += t.amountPaise;
        case TransactionFlow.transfer:
          break;
      }
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        Space.screen,
        Space.s,
        Space.screen,
        Space.xxxl,
      ),
      children: [
        Text(formatMonth(latest), style: theme.titleLarge),
        const SizedBox(height: Space.m),
        Row(
          children: [
            Expanded(
              child: _Total(
                label: 'Spent',
                amount: Paise(spent < 0 ? 0 : spent),
                color: c.textPrimary,
              ),
            ),
            const SizedBox(width: Space.m),
            Expanded(
              child: _Total(
                label: 'Came in',
                amount: Paise(income),
                color: c.good,
              ),
            ),
          ],
        ),
        const SizedBox(height: Space.s),
        Text(
          "Transfers between your own accounts aren't counted. Refunds come "
          'off spending.',
          style: theme.bodySmall,
        ),
        SectionHeader(
          'Latest',
          action: TextButton(
            onPressed: () => context.push('/transactions'),
            child: const Text('See all'),
          ),
        ),
        for (final t in transactions.take(6))
          TransactionTile(
            transaction: t,
            accountName: names[t.accountId],
            category: categories[t.categoryId],
          ),
      ],
    );
  }
}

class _Total extends StatelessWidget {
  const _Total({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final Paise amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.bodyMedium),
          const SizedBox(height: Space.xs),
          MoneyText(
            amount,
            style: theme.headlineMedium,
            paise: PaiseDisplay.never,
            color: color,
          ),
        ],
      ),
    );
  }
}
