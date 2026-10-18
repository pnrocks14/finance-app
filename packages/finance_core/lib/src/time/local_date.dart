import 'package:meta/meta.dart';

/// India Standard Time is UTC+05:30 all year (no daylight saving).
const Duration istOffset = Duration(hours: 5, minutes: 30);

/// A calendar day in India, with no time and no time zone.
///
/// Instants are stored in UTC (`occurredAt`). Monthly totals, budgets and
/// goals bucket by the IST calendar day, stored next to the instant as
/// `localDate` in ISO form (`"2026-10-12"`), so a 23:30 IST payment counts in
/// the day you made it rather than the UTC day.
@immutable
final class LocalDate implements Comparable<LocalDate> {
  LocalDate(this.year, this.month, this.day) {
    final check = DateTime.utc(year, month, day);
    if (check.year != year || check.month != month || check.day != day) {
      throw ArgumentError('Invalid date: $year-$month-$day');
    }
  }

  /// The IST calendar day that [instant] falls on.
  factory LocalDate.ofInstant(DateTime instant) {
    final ist = instant.toUtc().add(istOffset);
    return LocalDate(ist.year, ist.month, ist.day);
  }

  /// Today's IST calendar day.
  factory LocalDate.today({DateTime? now}) =>
      LocalDate.ofInstant(now ?? DateTime.now());

  /// Parses `"YYYY-MM-DD"`.
  factory LocalDate.parse(String iso) {
    final match = _isoDate.firstMatch(iso);
    if (match == null) throw FormatException('Expected YYYY-MM-DD', iso);
    return LocalDate(
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
      int.parse(match.group(3)!),
    );
  }

  final int year;
  final int month;
  final int day;

  /// Midnight IST at the start of this day, as a UTC instant.
  DateTime get startInstant =>
      DateTime.utc(year, month, day).subtract(istOffset);

  /// The month this day belongs to, as `"YYYY-MM"` (used to bucket totals).
  String get monthKey => '${_pad4(year)}-${_pad2(month)}';

  int get daysInMonth => DateTime.utc(year, month + 1, 0).day;

  /// 1 for Monday to 7 for Sunday.
  int get weekday => DateTime.utc(year, month, day).weekday;

  LocalDate addDays(int days) {
    final d = DateTime.utc(year, month, day + days);
    return LocalDate(d.year, d.month, d.day);
  }

  /// Whole days from this date to [other] (positive when [other] is later).
  int daysUntil(LocalDate other) => DateTime.utc(
    other.year,
    other.month,
    other.day,
  ).difference(DateTime.utc(year, month, day)).inDays;

  String toIso() => '${_pad4(year)}-${_pad2(month)}-${_pad2(day)}';

  @override
  String toString() => toIso();

  @override
  int compareTo(LocalDate other) => toIso().compareTo(other.toIso());

  bool isBefore(LocalDate other) => compareTo(other) < 0;
  bool isAfter(LocalDate other) => compareTo(other) > 0;

  @override
  bool operator ==(Object other) =>
      other is LocalDate &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);
}

final RegExp _isoDate = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');

String _pad2(int n) => n.toString().padLeft(2, '0');
String _pad4(int n) => n.toString().padLeft(4, '0');
