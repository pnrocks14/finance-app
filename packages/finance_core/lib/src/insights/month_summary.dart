import '../models/enums.dart';
import '../money/paise.dart';
import '../time/local_date.dart';

/// What a month summary needs from one transaction.
final class MoneyMove {
  const MoneyMove({
    required this.date,
    required this.amount,
    required this.flow,
    this.categoryId,
  });

  final LocalDate date;

  /// Always positive.
  final Paise amount;
  final TransactionFlow flow;
  final String? categoryId;
}

/// Money in and out for one IST calendar month, for the home screen.
final class MonthSummary {
  const MonthSummary({
    required this.month,
    required this.spent,
    required this.income,
    required this.byCategory,
    required this.cumulative,
  });

  /// The first day of the month.
  final LocalDate month;

  /// Spending less refunds. Transfers never count.
  final Paise spent;
  final Paise income;

  /// Spending less refunds per category, biggest first. Uncategorised
  /// spending is under the key null. A refund comes off the category it
  /// was filed under, and a category that nets to zero or less is left out.
  final List<(String?, Paise)> byCategory;

  /// Spending so far at the end of each day: one entry per day of the
  /// month, so `cumulative[0]` is the 1st.
  final List<Paise> cumulative;

  /// Income left after spending; negative when you spent more than came in.
  Paise get left => income - spent;
}

/// The first day of [d]'s month.
LocalDate monthOf(LocalDate d) => LocalDate(d.year, d.month, 1);

/// The first day of the month before [month].
LocalDate previousMonth(LocalDate month) => month.month == 1
    ? LocalDate(month.year - 1, 12, 1)
    : LocalDate(month.year, month.month - 1, 1);

/// The first day of the month after [month].
LocalDate nextMonth(LocalDate month) => month.month == 12
    ? LocalDate(month.year + 1, 1, 1)
    : LocalDate(month.year, month.month + 1, 1);

/// Sums the moves that fall in [month]; others are ignored.
MonthSummary summarizeMonth(Iterable<MoneyMove> moves, LocalDate month) {
  final first = monthOf(month);
  final days = first.daysInMonth;
  final daily = List<int>.filled(days, 0);
  final byCategory = <String?, int>{};
  var income = 0;
  for (final m in moves) {
    if (m.date.year != first.year || m.date.month != first.month) continue;
    final signed = switch (m.flow) {
      TransactionFlow.spend => m.amount.value,
      TransactionFlow.refund => -m.amount.value,
      TransactionFlow.income || TransactionFlow.transfer => 0,
    };
    if (m.flow == TransactionFlow.income) income += m.amount.value;
    if (signed == 0) continue;
    daily[m.date.day - 1] += signed;
    byCategory[m.categoryId] = (byCategory[m.categoryId] ?? 0) + signed;
  }
  var running = 0;
  final cumulative = [for (final d in daily) Paise(running += d)];
  final cats = [
    for (final MapEntry(:key, :value) in byCategory.entries)
      if (value > 0) (key, Paise(value)),
  ]..sort((a, b) => b.$2.value.compareTo(a.$2.value));
  return MonthSummary(
    month: first,
    spent: Paise(running),
    income: Paise(income),
    byCategory: cats,
    cumulative: cumulative,
  );
}
