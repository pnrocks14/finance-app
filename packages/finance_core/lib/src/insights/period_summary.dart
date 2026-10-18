import '../models/enums.dart';
import '../money/paise.dart';
import '../time/local_date.dart';
import 'month_summary.dart';

/// How long a period on the dashboard is.
enum PeriodKind { week, month, year }

/// A calendar week (Monday to Sunday), month or year in IST.
final class Period {
  /// The period of [kind] that contains [day].
  factory Period.of(PeriodKind kind, LocalDate day) => switch (kind) {
    PeriodKind.week => Period._(kind, day.addDays(-(day.weekday - 1))),
    PeriodKind.month => Period._(kind, monthOf(day)),
    PeriodKind.year => Period._(kind, LocalDate(day.year, 1, 1)),
  };

  const Period._(this.kind, this.start);

  final PeriodKind kind;

  /// The first day: a Monday, the 1st of a month, or 1 January.
  final LocalDate start;

  /// The last day, inclusive.
  LocalDate get end => switch (kind) {
    PeriodKind.week => start.addDays(6),
    PeriodKind.month => LocalDate(start.year, start.month, start.daysInMonth),
    PeriodKind.year => LocalDate(start.year, 12, 31),
  };

  Period get previous => switch (kind) {
    PeriodKind.week => Period._(kind, start.addDays(-7)),
    PeriodKind.month => Period._(kind, previousMonth(start)),
    PeriodKind.year => Period._(kind, LocalDate(start.year - 1, 1, 1)),
  };

  Period get next => switch (kind) {
    PeriodKind.week => Period._(kind, start.addDays(7)),
    PeriodKind.month => Period._(kind, nextMonth(start)),
    PeriodKind.year => Period._(kind, LocalDate(start.year + 1, 1, 1)),
  };

  bool contains(LocalDate d) => !d.isBefore(start) && !d.isAfter(end);

  /// Days in a week or month, months in a year.
  int get bucketCount => switch (kind) {
    PeriodKind.week => 7,
    PeriodKind.month => start.daysInMonth,
    PeriodKind.year => 12,
  };

  /// Which bucket [d] falls in; only for days in the period.
  int bucketOf(LocalDate d) => switch (kind) {
    PeriodKind.year => d.month - 1,
    _ => start.daysUntil(d),
  };

  @override
  bool operator ==(Object other) =>
      other is Period && other.kind == kind && other.start == start;

  @override
  int get hashCode => Object.hash(kind, start);
}

/// Money in and out over a period, for the dashboard.
final class PeriodSummary {
  const PeriodSummary({
    required this.period,
    required this.spent,
    required this.income,
    required this.spendByCategory,
    required this.incomeByCategory,
    required this.spendBuckets,
    required this.incomeBuckets,
  });

  final Period period;

  /// Spending less refunds. Transfers never count.
  final Paise spent;
  final Paise income;

  /// Spending less refunds per category, biggest first; uncategorised under
  /// null. Categories that net to zero or less are left out.
  final List<(String?, Paise)> spendByCategory;

  /// Income per category, biggest first.
  final List<(String?, Paise)> incomeByCategory;

  /// Spending less refunds in each day (week, month) or month (year). Can
  /// be negative on a day with only refunds.
  final List<Paise> spendBuckets;
  final List<Paise> incomeBuckets;

  /// Income less spending.
  Paise get net => income - spent;

  /// Spending so far at the end of each bucket.
  List<Paise> get cumulativeSpend {
    var running = 0;
    return [for (final p in spendBuckets) Paise(running += p.value)];
  }
}

/// Sums the moves that fall in [period]; others are ignored.
PeriodSummary summarizePeriod(Iterable<MoneyMove> moves, Period period) {
  final n = period.bucketCount;
  final spend = List<int>.filled(n, 0);
  final earn = List<int>.filled(n, 0);
  final spendBy = <String?, int>{};
  final incomeBy = <String?, int>{};
  for (final m in moves) {
    if (!period.contains(m.date)) continue;
    final i = period.bucketOf(m.date);
    switch (m.flow) {
      case TransactionFlow.spend:
        spend[i] += m.amount.value;
        spendBy[m.categoryId] = (spendBy[m.categoryId] ?? 0) + m.amount.value;
      case TransactionFlow.refund:
        spend[i] -= m.amount.value;
        spendBy[m.categoryId] = (spendBy[m.categoryId] ?? 0) - m.amount.value;
      case TransactionFlow.income:
        earn[i] += m.amount.value;
        incomeBy[m.categoryId] = (incomeBy[m.categoryId] ?? 0) + m.amount.value;
      case TransactionFlow.transfer:
        break;
    }
  }
  List<(String?, Paise)> ranked(Map<String?, int> by) => [
    for (final MapEntry(:key, :value) in by.entries)
      if (value > 0) (key, Paise(value)),
  ]..sort((a, b) => b.$2.value.compareTo(a.$2.value));
  return PeriodSummary(
    period: period,
    spent: Paise(spend.fold(0, (a, b) => a + b)),
    income: Paise(earn.fold(0, (a, b) => a + b)),
    spendByCategory: ranked(spendBy),
    incomeByCategory: ranked(incomeBy),
    spendBuckets: [for (final v in spend) Paise(v)],
    incomeBuckets: [for (final v in earn) Paise(v)],
  );
}
