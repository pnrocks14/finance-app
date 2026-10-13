import 'package:finance_core/finance_core.dart';
import 'package:test/test.dart';

void main() {
  test('buckets an instant by its IST calendar day', () {
    // 19:00 UTC on 11 Oct is 00:30 IST on 12 Oct.
    final late = DateTime.utc(2026, 10, 11, 19);
    expect(LocalDate.ofInstant(late).toIso(), '2026-10-12');

    // 18:29 UTC on 11 Oct is 23:59 IST on 11 Oct.
    final beforeMidnight = DateTime.utc(2026, 10, 11, 18, 29);
    expect(LocalDate.ofInstant(beforeMidnight).toIso(), '2026-10-11');
  });

  test('startInstant is midnight IST in UTC', () {
    expect(
      LocalDate(2026, 10, 12).startInstant,
      DateTime.utc(2026, 10, 11, 18, 30),
    );
  });

  test('parses, compares and formats ISO dates', () {
    final a = LocalDate.parse('2026-02-28');
    expect(a.addDays(1).toIso(), '2026-03-01');
    expect(a.monthKey, '2026-02');
    expect(a.daysInMonth, 28);
    expect(LocalDate(2028, 2, 1).daysInMonth, 29);
    expect(a.isBefore(LocalDate(2026, 3, 1)), isTrue);
    expect(a.daysUntil(LocalDate(2026, 3, 10)), 10);
    expect(LocalDate.parse('2026-10-12'), LocalDate(2026, 10, 12));
  });

  test('rejects impossible dates and bad text', () {
    expect(() => LocalDate(2026, 2, 30), throwsArgumentError);
    expect(() => LocalDate.parse('12-10-2026'), throwsFormatException);
  });
}
