import 'package:finance_core/finance_core.dart';
import 'package:finance_data/finance_data.dart';
import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/data_providers.dart';
import '../../common/amount_sheet.dart';
import '../../common/format.dart';
import '../categories/category_picker.dart';
import '../categories/category_visuals.dart';

/// Monthly limits per category: how much of each is used, what's left
/// across all of them, and spending this month that has no budget yet.
class BudgetsScreen extends ConsumerStatefulWidget {
  const BudgetsScreen({super.key});

  @override
  ConsumerState<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends ConsumerState<BudgetsScreen> {
  /// Null until you move: then this month, or the latest month with
  /// transactions if this one has none yet.
  LocalDate? _picked;

  Future<void> _edit(Category cat, Paise? limit) async {
    final r = await showAmountSheet(
      context,
      title: 'Monthly budget for ${cat.name}',
      message: 'The same limit applies every month until you change it.',
      initial: limit,
      canRemove: limit != null,
    );
    if (r == null) return;
    final repo = await ref.read(budgetsRepositoryProvider.future);
    if (r.remove) {
      await repo.remove(cat.id);
    } else if (r.amount case final a?) {
      await repo.setLimit(cat.id, a);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final c = context.colors;
    final months = ref.watch(monthsProvider).value ?? const <LocalDate>[];
    final current = monthOf(LocalDate.today());
    final latest = months.isEmpty || !months.first.isAfter(current)
        ? current
        : months.first;
    final month =
        _picked ??
        (months.isEmpty || months.contains(current) ? current : months.first);
    final oldest = months.isEmpty ? current : months.last;
    final period = Period.of(PeriodKind.month, month);
    final summary = ref.watch(periodSummaryProvider(period)).value;
    final limits = ref.watch(budgetLimitsProvider).value ?? const {};
    final categories = {
      for (final c in ref.watch(categoriesProvider).value ?? const <Category>[])
        c.id: c,
    };
    final b = budgetMonth(limits, summary?.spendByCategory ?? const []);
    final left = b.limit - b.spent;
    final today = LocalDate.today();
    final daysLeft = month == current ? period.end.day - today.day + 1 : 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Budgets')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add-budget',
        onPressed: () async {
          final choice = await showCategoryPicker(
            context,
            categories: [
              for (final c in categories.values)
                if ((c.spendClass == SpendClass.fixed ||
                        c.spendClass == SpendClass.flexible) &&
                    !limits.containsKey(c.id))
                  c,
            ],
            direction: Direction.debit,
          );
          if (choice == null || !context.mounted) return;
          final cat = categories[choice.categoryId];
          if (cat != null) await _edit(cat, null);
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('New budget'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Space.screen,
          Space.s,
          Space.screen,
          96,
        ),
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Earlier month',
                icon: const Icon(Icons.chevron_left_rounded),
                onPressed: month.isAfter(oldest)
                    ? () => setState(() => _picked = previousMonth(month))
                    : null,
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
                onPressed: month.isBefore(latest)
                    ? () => setState(() => _picked = nextMonth(month))
                    : null,
              ),
            ],
          ),
          const SizedBox(height: Space.s),
          if (limits.isEmpty)
            AppCard(
              soft: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('No budgets yet', style: theme.titleMedium),
                  const SizedBox(height: Space.xs),
                  Text(
                    'Give a category a monthly limit and see how much is '
                    'left as you spend. Start with one you spend the most on.',
                    style: theme.bodyMedium,
                  ),
                ],
              ),
            )
          else
            AppCard(
              child: Row(
                children: [
                  ProgressRing(
                    progress: b.limit.value == 0
                        ? 0
                        : b.spent.value / b.limit.value,
                    color: BudgetTone.of(b.spent, b.limit).color(c),
                    size: 104,
                    semanticLabel: left.isNegative
                        ? '${formatInr(-left, paise: PaiseDisplay.never)} over budget'
                        : '${formatInr(left, paise: PaiseDisplay.never)} left of '
                              '${formatInr(b.limit, paise: PaiseDisplay.never)}',
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MoneyText(
                          left.abs(),
                          style: theme.titleMedium,
                          paise: PaiseDisplay.never,
                        ),
                        Text(
                          left.isNegative ? 'over' : 'left',
                          style: theme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Space.l),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${formatInr(b.spent, paise: PaiseDisplay.never)} of '
                          '${formatInr(b.limit, paise: PaiseDisplay.never)} used',
                          style: theme.titleMedium,
                        ),
                        const SizedBox(height: Space.xs),
                        Text(
                          daysLeft > 0 && !left.isNegative
                              ? 'About ${formatInr(Paise(left.value ~/ daysLeft), paise: PaiseDisplay.never)} '
                                    'a day for the $daysLeft '
                                    '${daysLeft == 1 ? 'day' : 'days'} left.'
                              : left.isNegative
                              ? 'Over across your budgets this month.'
                              : 'Across ${b.lines.length} '
                                    '${b.lines.length == 1 ? 'budget' : 'budgets'}.',
                          style: theme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (b.lines.isNotEmpty) ...[
            const SectionHeader('Budgeted'),
            for (final l in b.lines)
              if (categories[l.categoryId] case final cat?)
                InkWell(
                  borderRadius: BorderRadius.circular(Radii.chip),
                  onTap: () => _edit(cat, l.limit),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Space.s),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CategoryBadge(cat, radius: 18),
                        const SizedBox(width: Space.m),
                        Expanded(
                          child: BudgetBar(
                            label: cat.name,
                            spent: l.spent,
                            limit: l.limit,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
          if (b.unbudgeted.isNotEmpty) ...[
            const SectionHeader('Not budgeted this month'),
            for (final (id, spent) in b.unbudgeted)
              if (categories[id] case final cat?)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CategoryBadge(cat),
                  title: Text(cat.name),
                  subtitle: Text(
                    '${formatInr(spent, paise: PaiseDisplay.never)} spent',
                  ),
                  trailing: TextButton(
                    onPressed: () => _edit(cat, null),
                    child: const Text('Set budget'),
                  ),
                ),
          ],
        ],
      ),
    );
  }
}
