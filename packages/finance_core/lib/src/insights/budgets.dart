import '../money/paise.dart';

/// One category's monthly limit against what was spent.
final class BudgetLine {
  const BudgetLine({
    required this.categoryId,
    required this.limit,
    required this.spent,
  });

  final String categoryId;
  final Paise limit;

  /// Spending less refunds this month; never below zero.
  final Paise spent;

  /// Negative when over.
  Paise get left => limit - spent;
  bool get isOver => spent > limit;
}

/// Budgets for a month, and the spending that has no budget.
final class BudgetMonth {
  const BudgetMonth({required this.lines, required this.unbudgeted});

  /// Every budget, the most used first.
  final List<BudgetLine> lines;

  /// Spending in categories without a budget, biggest first. Uncategorised
  /// spending is left out: give it a category first.
  final List<(String, Paise)> unbudgeted;

  Paise get limit => lines.fold(Paise.zero, (s, l) => s + l.limit);
  Paise get spent => lines.fold(Paise.zero, (s, l) => s + l.spent);
}

/// Puts [limits] (category id to monthly limit) against [spendByCategory]
/// from a month summary.
BudgetMonth budgetMonth(
  Map<String, Paise> limits,
  List<(String?, Paise)> spendByCategory,
) {
  final spent = {for (final (id, p) in spendByCategory) id: p};
  final lines = [
    for (final MapEntry(:key, :value) in limits.entries)
      BudgetLine(
        categoryId: key,
        limit: value,
        spent: spent[key] ?? Paise.zero,
      ),
  ]..sort((a, b) => _ratio(b).compareTo(_ratio(a)));
  return BudgetMonth(
    lines: lines,
    unbudgeted: [
      for (final (id, p) in spendByCategory)
        if (id != null && !limits.containsKey(id)) (id, p),
    ],
  );
}

double _ratio(BudgetLine l) =>
    l.limit.value <= 0 ? double.infinity : l.spent.value / l.limit.value;
