import 'package:finance_core/finance_core.dart';
import 'package:finance_data/finance_data.dart';
import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/data_providers.dart';
import '../../app/providers.dart';
import '../../common/format.dart';
import '../accounts/account_visuals.dart';
import '../categories/category_visuals.dart';
import '../lock/lock_controller.dart';
import '../transactions/transactions_screen.dart';

/// Home: the analytics dashboard. Pick a week, month or year to see money
/// in and out, what's left, your accounts, where the money went by
/// category, how it moved day by day, your budgets and the latest
/// transactions.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txs = ref.watch(transactionsProvider);
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview'),
        actions: [
          IconButton(
            tooltip: 'Import a statement',
            icon: const Icon(Icons.upload_file_rounded),
            onPressed: () => context.push('/import'),
          ),
          IconButton(
            tooltip: 'Appearance',
            icon: const Icon(Icons.brightness_6_outlined),
            onPressed: () => showAppearanceSheet(context, ref),
          ),
          PopupMenuButton<String>(
            tooltip: 'More',
            onSelected: (v) => switch (v) {
              'rules' => context.push('/rules'),
              'style' => context.push('/style-sheet'),
              _ => ref.read(lockControllerProvider.notifier).lockNow(),
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'rules', child: Text('Your rules')),
              PopupMenuItem(value: 'style', child: Text('Style sheet')),
              PopupMenuItem(value: 'lock', child: Text('Lock now')),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add-home',
        onPressed: () => context.push('/add'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add'),
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
                        'goes, or tap Add to note a spend by hand. It stays '
                        'on this phone.',
                    actionLabel: 'Import a statement',
                    onAction: () => context.push('/import'),
                  ),
                )
              : _Dashboard(list),
        ),
      ),
    );
  }
}

/// Light, dark or follow the phone.
Future<void> showAppearanceSheet(BuildContext context, WidgetRef ref) =>
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final mode = ref.watch(themeModeProvider);
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final (m, label, icon) in const [
                  (
                    ThemeMode.system,
                    'Same as phone',
                    Icons.brightness_auto_outlined,
                  ),
                  (ThemeMode.light, 'Light', Icons.light_mode_outlined),
                  (ThemeMode.dark, 'Dark', Icons.dark_mode_outlined),
                ])
                  ListTile(
                    leading: Icon(icon),
                    title: Text(label),
                    trailing: m == mode
                        ? const Icon(Icons.check_rounded)
                        : null,
                    onTap: () {
                      ref.read(themeModeProvider.notifier).set(m);
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );

class _Dashboard extends ConsumerStatefulWidget {
  const _Dashboard(this.transactions);

  /// The newest transactions, for the latest list and the default period.
  final List<Transaction> transactions;

  @override
  ConsumerState<_Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<_Dashboard> {
  var _kind = PeriodKind.month;

  /// A day in the period you're looking at. Null until you move: then the
  /// newest transaction's, so a past statement still shows.
  LocalDate? _anchor;

  /// Show where money came from instead of where it went.
  var _income = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final c = context.colors;
    final accounts = ref.watch(accountsProvider).value ?? const <Account>[];
    final names = {for (final a in accounts) a.id: a.displayName};
    final categories = {
      for (final c in ref.watch(categoriesProvider).value ?? const <Category>[])
        c.id: c,
    };
    final months =
        ref.watch(monthsProvider).value ??
        [monthOf(widget.transactions.first.localDate)];
    final newest = widget.transactions.first.localDate;
    final period = Period.of(_kind, _anchor ?? newest);
    final oldest = months.isEmpty ? newest : months.last;
    final latest = LocalDate.today().isAfter(newest)
        ? LocalDate.today()
        : newest;
    final canOlder = period.start.isAfter(oldest);
    final canNewer = period.end.isBefore(latest);

    final summary = ref.watch(periodSummaryProvider(period)).value;
    final previous = ref.watch(periodSummaryProvider(period.previous)).value;
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

    final unit = switch (_kind) {
      PeriodKind.week => 'week',
      PeriodKind.month => 'month',
      PeriodKind.year => 'year',
    };
    final label = switch (_kind) {
      PeriodKind.week => formatPeriod(period.start, period.end),
      PeriodKind.month => formatMonth(period.start),
      PeriodKind.year => '${period.start.year}',
    };
    // Links to the list keep the month chip for a month, else a range.
    final range = _kind == PeriodKind.month
        ? 'month=${period.start.monthKey}'
        : 'from=${period.start.toIso()}&to=${period.end.toIso()}';

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        Space.screen,
        Space.s,
        Space.screen,
        96,
      ),
      children: [
        SegmentedButton<PeriodKind>(
          segments: const [
            ButtonSegment(value: PeriodKind.week, label: Text('Week')),
            ButtonSegment(value: PeriodKind.month, label: Text('Month')),
            ButtonSegment(value: PeriodKind.year, label: Text('Year')),
          ],
          showSelectedIcon: false,
          selected: {_kind},
          onSelectionChanged: (s) => setState(() {
            _anchor ??= newest;
            _kind = s.first;
          }),
        ),
        const SizedBox(height: Space.s),
        Row(
          children: [
            IconButton(
              tooltip: 'Earlier $unit',
              icon: const Icon(Icons.chevron_left_rounded),
              onPressed: canOlder
                  ? () => setState(() => _anchor = period.previous.start)
                  : null,
            ),
            Expanded(
              child: Text(
                label,
                style: theme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              tooltip: 'Later $unit',
              icon: const Icon(Icons.chevron_right_rounded),
              onPressed: canNewer
                  ? () => setState(() => _anchor = period.next.start)
                  : null,
            ),
          ],
        ),
        const SizedBox(height: Space.s),
        if (summary == null)
          const Padding(
            padding: EdgeInsets.all(Space.xl),
            child: Center(child: CircularProgressIndicator()),
          )
        else ...[
          _Totals(
            summary: summary,
            income: _income,
            onPick: (v) => setState(() => _income = v),
          ),
          if (previous != null) ...[
            const SizedBox(height: Space.s),
            Text(
              _compareLine(summary.spent, previous.spent, unit),
              style: theme.bodySmall,
            ),
          ],
          if (_kind == PeriodKind.month) ...[
            const SizedBox(height: Space.m),
            _LeftToSpend(summary: summary),
          ],
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
          if (accounts.isNotEmpty) _AccountsStrip(accounts: accounts),
          ..._breakdown(context, summary, categories, range),
          ..._flow(context, summary, previous, range),
          if (_kind == PeriodKind.month && !_income)
            _BudgetsPeek(summary: summary, categories: categories),
        ],
        SectionHeader(
          'Latest',
          action: TextButton(
            onPressed: () => context.push('/transactions'),
            child: const Text('See all'),
          ),
        ),
        for (final t in widget.transactions.take(5))
          TransactionTile(
            transaction: t,
            accountName: names[t.accountId],
            category: categories[t.categoryId],
          ),
      ],
    );
  }

  /// The donut and a row per category, for spending or income.
  List<Widget> _breakdown(
    BuildContext context,
    PeriodSummary s,
    Map<String, Category> categories,
    String range,
  ) {
    final c = context.colors;
    final rows = _income ? s.incomeByCategory : s.spendByCategory;
    if (rows.isEmpty) {
      return [
        SectionHeader(_income ? 'Where it came from' : 'Where it went'),
        Text(
          _income ? 'No money came in.' : 'No spending.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ];
    }
    final total = rows.fold(Paise.zero, (sum, e) => sum + e.$2);
    Color colorOf(String? id) => id == null
        ? c.textSecondary
        : c.chartToken(categories[id]?.colorToken ?? 'chart8');
    final top = rows.take(5).toList();
    final rest = rows.skip(5).fold(Paise.zero, (sum, e) => sum + e.$2);
    final slices = [
      for (final (id, amount) in top)
        DonutSlice(
          label: categories[id]?.name ?? 'Needs a category',
          amount: amount,
          color: colorOf(id),
        ),
      if (rest > Paise.zero)
        DonutSlice(
          label: 'Everything else',
          amount: rest,
          color: c.surfaceSoft,
        ),
    ];
    return [
      SectionHeader(_income ? 'Where it came from' : 'Where it went'),
      Center(
        child: CategoryDonut(
          slices: slices,
          centerLabel: _income ? 'came in' : 'spent',
        ),
      ),
      const SizedBox(height: Space.m),
      for (final (id, amount) in rows)
        BreakdownRow(
          leading: switch (categories[id]) {
            final cat? => CategoryBadge(cat, radius: 18),
            null => CircleAvatar(
              radius: 18,
              backgroundColor: c.surfaceSoft,
              child: Icon(
                Icons.label_outline_rounded,
                size: 18,
                color: c.textSecondary,
              ),
            ),
          },
          label: categories[id]?.name ?? 'Needs a category',
          amount: amount,
          share: total.value == 0 ? 0 : amount.value / total.value,
          color: colorOf(id),
          onTap: () => context.push(
            id == null
                ? '/transactions?$range&needs=1'
                : '/transactions?$range&category=$id',
          ),
        ),
    ];
  }

  /// The trend line, the month curve against last month, and the calendar.
  List<Widget> _flow(
    BuildContext context,
    PeriodSummary s,
    PeriodSummary? previous,
    String range,
  ) {
    final theme = Theme.of(context).textTheme;
    final c = context.colors;
    final values = _income ? s.incomeBuckets : s.spendBuckets;
    final p = s.period;
    final labels = switch (p.kind) {
      PeriodKind.week => const [
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun',
      ],
      PeriodKind.month => ['1', '8', '15', '22', '${p.bucketCount}'],
      PeriodKind.year => const ['Jan', 'Apr', 'Jul', 'Oct', 'Dec'],
    };
    final color = _income ? c.good : c.primary;
    final today = LocalDate.today();
    final curve = p.contains(today)
        ? s.cumulativeSpend.sublist(0, p.bucketOf(today) + 1)
        : s.cumulativeSpend;
    return [
      SectionHeader(_income ? 'Money in, over time' : 'Spending, over time'),
      TrendChart(values: values, labels: labels, color: color),
      if (p.kind == PeriodKind.month && !_income && previous != null) ...[
        const SectionHeader('Through the month'),
        SpendCurve(current: curve, previous: previous.cumulativeSpend),
        const SizedBox(height: Space.xs),
        Text(
          _curveLine(curve, previous.cumulativeSpend),
          style: theme.bodySmall,
        ),
      ],
      if (p.kind == PeriodKind.month) ...[
        const SectionHeader('Day by day'),
        DayGrid(
          month: p.start,
          values: values,
          color: color,
          onTap: (d) =>
              context.push('/transactions?from=${d.toIso()}&to=${d.toIso()}'),
        ),
      ],
    ];
  }
}

/// "₹2,400 less than last month." or more, or the same.
String _compareLine(Paise now, Paise before, String unit) {
  if (before == Paise.zero) return 'No spending last $unit to compare with.';
  final diff = now - before;
  final amount = formatInr(diff.abs(), paise: PaiseDisplay.never);
  if (diff == Paise.zero) return 'The same spending as last $unit.';
  return diff.isNegative
      ? 'Spent $amount less than last $unit.'
      : 'Spent $amount more than last $unit.';
}

/// "₹2,400 less than last month by this day", or more, or the same.
String _curveLine(List<Paise> now, List<Paise> before) {
  if (before.every((p) => p == Paise.zero) || now.isEmpty) {
    return 'No spending last month to compare with.';
  }
  final day = now.length.clamp(1, before.length);
  final diff = now.last - before[day - 1];
  final amount = formatInr(diff.abs(), paise: PaiseDisplay.never);
  if (diff == Paise.zero) return 'The same as last month by this day.';
  return diff.isNegative
      ? '$amount less than last month by this day.'
      : '$amount more than last month by this day.';
}

/// Spent, came in and the difference. Tap spent or came in to switch the
/// breakdown below.
class _Totals extends StatelessWidget {
  const _Totals({
    required this.summary,
    required this.income,
    required this.onPick,
  });

  final PeriodSummary summary;
  final bool income;
  final ValueChanged<bool> onPick;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = summary;
    final spent = s.spent.isNegative ? Paise.zero : s.spent;
    return Row(
      children: [
        Expanded(
          child: _TotalTile(
            label: 'Spent',
            amount: spent,
            color: c.over,
            selected: !income,
            onTap: () => onPick(false),
          ),
        ),
        const SizedBox(width: Space.s),
        Expanded(
          child: _TotalTile(
            label: 'Came in',
            amount: s.income,
            color: c.good,
            selected: income,
            onTap: () => onPick(true),
          ),
        ),
        const SizedBox(width: Space.s),
        Expanded(
          child: _TotalTile(
            label: 'Difference',
            amount: s.net,
            color: s.net.isNegative ? c.over : c.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _TotalTile extends StatelessWidget {
  const _TotalTile({
    required this.label,
    required this.amount,
    required this.color,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final Paise amount;
  final Color color;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final c = context.colors;
    return Semantics(
      selected: onTap == null ? null : selected,
      button: onTap != null,
      child: Material(
        color: selected ? color.withValues(alpha: 0.12) : c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.card),
          side: BorderSide(color: selected ? color : c.outline),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(Radii.card),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(Space.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.bodySmall),
                const SizedBox(height: Space.xs),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: MoneyText(
                    amount,
                    style: theme.titleMedium,
                    paise: PaiseDisplay.never,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// What's left of this month's income after spending, as a ring.
class _LeftToSpend extends StatelessWidget {
  const _LeftToSpend({required this.summary});

  final PeriodSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final c = context.colors;
    final s = summary;
    final spent = s.spent.isNegative ? Paise.zero : s.spent;
    final hasIncome = s.income > Paise.zero;
    final left = s.income - spent;
    final tone = hasIncome ? BudgetTone.of(spent, s.income) : BudgetTone.over;
    return AppCard(
      child: Row(
        children: [
          ProgressRing(
            progress: hasIncome ? spent.value / s.income.value : 1,
            color: hasIncome ? tone.color(c) : c.textSecondary,
            size: 104,
            semanticLabel: hasIncome
                ? '${formatInr(left, paise: PaiseDisplay.never)} left of '
                      '${formatInr(s.income, paise: PaiseDisplay.never)}'
                : 'No income this month',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MoneyText(
                  hasIncome ? left : spent,
                  style: theme.titleMedium,
                  paise: PaiseDisplay.never,
                ),
                Text(hasIncome ? 'left' : 'spent', style: theme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: Space.l),
          Expanded(
            child: Text(
              hasIncome
                  ? (left.isNegative
                        ? 'You spent more than came in.'
                        : "Left of this month's income. Transfers don't "
                              'count, and refunds come off spending.')
                  : 'No income this month yet.',
              style: theme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

/// Your accounts in a row of cards, with the total.
class _AccountsStrip extends ConsumerWidget {
  const _AccountsStrip({required this.accounts});

  final List<Account> accounts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).textTheme;
    final c = context.colors;
    final balances = ref.watch(accountBalancesProvider).value ?? const {};
    final total = accounts.fold(
      Paise.zero,
      (s, a) => s + (balances[a.id] ?? Paise.zero),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          'Accounts',
          action: TextButton(
            onPressed: () => context.go('/accounts'),
            child: const Text('Manage'),
          ),
        ),
        Row(
          children: [
            Text('All accounts', style: theme.bodyMedium),
            const Spacer(),
            MoneyText(
              total,
              style: theme.titleMedium,
              paise: PaiseDisplay.never,
            ),
          ],
        ),
        const SizedBox(height: Space.s),
        SizedBox(
          height: 92,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: accounts.length,
            separatorBuilder: (_, _) => const SizedBox(width: Space.s),
            itemBuilder: (context, i) {
              final a = accounts[i];
              final b = balances[a.id] ?? Paise.zero;
              return SizedBox(
                width: 156,
                child: AppCard(
                  soft: true,
                  padding: const EdgeInsets.all(Space.m),
                  onTap: () => context.push('/transactions?account=${a.id}'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(accountIcon(a.kind), size: 18, color: c.primary),
                          const SizedBox(width: Space.xs),
                          Expanded(
                            child: Text(
                              a.displayName,
                              style: theme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: MoneyText(
                          b,
                          style: theme.titleMedium,
                          paise: PaiseDisplay.never,
                          color: b.isNegative ? c.over : null,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// The three fullest budgets this month, if you've set any.
class _BudgetsPeek extends ConsumerWidget {
  const _BudgetsPeek({required this.summary, required this.categories});

  final PeriodSummary summary;
  final Map<String, Category> categories;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final limits = ref.watch(budgetLimitsProvider).value ?? const {};
    if (limits.isEmpty) return const SizedBox.shrink();
    final month = budgetMonth(limits, summary.spendByCategory);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          'Budgets',
          action: TextButton(
            onPressed: () => context.go('/budgets'),
            child: const Text('All budgets'),
          ),
        ),
        for (final l in month.lines.take(3))
          Padding(
            padding: const EdgeInsets.only(bottom: Space.l),
            child: BudgetBar(
              label: categories[l.categoryId]?.name ?? 'Category',
              spent: l.spent,
              limit: l.limit,
            ),
          ),
      ],
    );
  }
}
