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

/// Home: one month at a glance, diagrams first. What's left of the income,
/// where the money went, how spending built up against last month, what
/// still needs a category, and the latest transactions.
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

class _Overview extends ConsumerStatefulWidget {
  const _Overview(this.transactions);

  /// The newest transactions, for the latest list and the default month.
  final List<Transaction> transactions;

  @override
  ConsumerState<_Overview> createState() => _OverviewState();
}

class _OverviewState extends ConsumerState<_Overview> {
  /// Null until you switch: then the month of the newest transaction, so a
  /// past statement still shows.
  LocalDate? _picked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final c = context.colors;
    final accounts = ref.watch(accountsProvider).value ?? const [];
    final names = {for (final a in accounts) a.id: a.displayName};
    final categories = {
      for (final c in ref.watch(categoriesProvider).value ?? const <Category>[])
        c.id: c,
    };
    final months =
        ref.watch(monthsProvider).value ??
        [monthOf(widget.transactions.first.localDate)];
    final month = _picked ?? months.first;
    final index = months.indexOf(month);
    final older = index >= 0 && index < months.length - 1
        ? months[index + 1]
        : null;
    final newer = index > 0 ? months[index - 1] : null;

    List<MoneyMove> moves(List<Transaction> list) => [
      for (final t in list)
        MoneyMove(
          date: t.localDate,
          amount: Paise(t.amountPaise),
          flow: t.flow,
          categoryId: t.categoryId,
        ),
    ];
    final thisMonth =
        ref
            .watch(
              filteredTransactionsProvider(TransactionFilter(month: month)),
            )
            .value ??
        const <Transaction>[];
    final lastMonth = previousMonth(month);
    final before =
        ref
            .watch(
              filteredTransactionsProvider(TransactionFilter(month: lastMonth)),
            )
            .value ??
        const <Transaction>[];
    final summary = summarizeMonth(moves(thisMonth), month);
    final previous = summarizeMonth(moves(before), lastMonth);
    final today = LocalDate.today();
    final isCurrent = monthOf(today) == month;
    final curve = isCurrent
        ? summary.cumulative.sublist(0, today.day)
        : summary.cumulative;
    final needs =
        ref
            .watch(
              filteredTransactionsProvider(
                const TransactionFilter(needsCategory: true),
              ),
            )
            .value
            ?.length ??
        0;

    // Top five categories, then the rest as one slice.
    final top = summary.byCategory.take(5).toList();
    final rest = summary.byCategory
        .skip(5)
        .fold(Paise.zero, (sum, e) => sum + e.$2);
    final slices = [
      for (final (id, amount) in top)
        DonutSlice(
          label: categories[id]?.name ?? 'Needs a category',
          amount: amount,
          color: id == null
              ? c.textSecondary
              : c.chartToken(categories[id]?.colorToken ?? 'chart8'),
        ),
      if (rest > Paise.zero)
        DonutSlice(
          label: 'Everything else',
          amount: rest,
          color: c.surfaceSoft,
        ),
    ];
    final monthParam = month.toIso().substring(0, 7);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        Space.screen,
        Space.s,
        Space.screen,
        Space.xxxl,
      ),
      children: [
        Row(
          children: [
            IconButton(
              tooltip: 'Earlier month',
              icon: const Icon(Icons.chevron_left_rounded),
              onPressed: older == null
                  ? null
                  : () => setState(() => _picked = older),
            ),
            Expanded(
              child: Text(
                formatMonth(month),
                style: theme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              tooltip: 'Later month',
              icon: const Icon(Icons.chevron_right_rounded),
              onPressed: newer == null
                  ? null
                  : () => setState(() => _picked = newer),
            ),
          ],
        ),
        const SizedBox(height: Space.s),
        _LeftToSpend(summary: summary),
        if (needs > 0) ...[
          const SizedBox(height: Space.m),
          AppCard(
            soft: true,
            onTap: () => context.push('/sort'),
            child: Row(
              children: [
                Icon(Icons.label_outline_rounded, color: c.primary),
                const SizedBox(width: Space.m),
                Expanded(
                  child: Text(
                    needs == 1
                        ? '1 transaction needs a category'
                        : '$needs transactions need a category',
                    style: theme.bodyLarge,
                  ),
                ),
                Text(
                  'Sort them',
                  style: theme.labelLarge?.copyWith(color: c.primary),
                ),
              ],
            ),
          ),
        ],
        if (slices.isNotEmpty) ...[
          const SectionHeader('Where it went'),
          Center(
            child: CategoryDonut(
              slices: slices,
              centerLabel: 'spent in ${formatMonth(month).split(' ').first}',
            ),
          ),
          const SizedBox(height: Space.m),
          DonutLegend(
            slices: slices,
            onTap: (i) {
              if (i >= top.length) {
                context.push('/transactions?month=$monthParam');
                return;
              }
              final id = top[i].$1;
              context.push(
                id == null
                    ? '/transactions?month=$monthParam&needs=1'
                    : '/transactions?month=$monthParam&category=$id',
              );
            },
          ),
          const SectionHeader('Through the month'),
          SpendCurve(current: curve, previous: previous.cumulative),
          const SizedBox(height: Space.xs),
          Text(
            _curveLine(summary, previous, curve.length),
            style: theme.bodySmall,
          ),
        ],
        SectionHeader(
          'Latest',
          action: TextButton(
            onPressed: () => context.push('/transactions'),
            child: const Text('See all'),
          ),
        ),
        for (final t in widget.transactions.take(6))
          TransactionTile(
            transaction: t,
            accountName: names[t.accountId],
            category: categories[t.categoryId],
          ),
      ],
    );
  }
}

/// "₹2,400 less than last month by this day", or more, or the same.
String _curveLine(MonthSummary now, MonthSummary before, int days) {
  if (before.cumulative.every((p) => p == Paise.zero)) {
    return 'No spending last month to compare with.';
  }
  final day = days.clamp(1, before.cumulative.length);
  final diff = now.cumulative[days - 1] - before.cumulative[day - 1];
  final amount = formatInr(diff.abs(), paise: PaiseDisplay.never);
  if (diff == Paise.zero) return 'The same as last month by this day.';
  return diff.isNegative
      ? '$amount less than last month by this day.'
      : '$amount more than last month by this day.';
}

/// What's left of this month's income after spending, as a ring.
class _LeftToSpend extends StatelessWidget {
  const _LeftToSpend({required this.summary});

  final MonthSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final c = context.colors;
    final s = summary;
    final spent = s.spent.isNegative ? Paise.zero : s.spent;
    final hasIncome = s.income > Paise.zero;
    final tone = hasIncome ? BudgetTone.of(spent, s.income) : BudgetTone.over;
    return AppCard(
      child: Row(
        children: [
          ProgressRing(
            progress: hasIncome ? spent.value / s.income.value : 1,
            color: hasIncome ? tone.color(c) : c.textSecondary,
            size: 112,
            semanticLabel: hasIncome
                ? '${formatInr(s.left, paise: PaiseDisplay.never)} left of '
                      '${formatInr(s.income, paise: PaiseDisplay.never)}'
                : 'No income this month',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MoneyText(
                  hasIncome ? s.left : spent,
                  style: theme.titleMedium,
                  paise: PaiseDisplay.never,
                ),
                Text(hasIncome ? 'left' : 'spent', style: theme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: Space.l),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Line('Came in', s.income, c.good),
                const SizedBox(height: Space.s),
                _Line('Spent', spent, c.textPrimary),
                const SizedBox(height: Space.s),
                Text(
                  hasIncome
                      ? (s.left.isNegative
                            ? 'You spent more than came in.'
                            : "Transfers don't count. Refunds come off "
                                  'spending.')
                      : 'No income this month yet.',
                  style: theme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line(this.label, this.amount, this.color);

  final String label;
  final Paise amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(child: Text(label, style: theme.bodyMedium)),
        MoneyText(
          amount,
          style: theme.titleMedium,
          paise: PaiseDisplay.never,
          color: color,
        ),
      ],
    );
  }
}
