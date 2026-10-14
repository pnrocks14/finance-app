import '../time/local_date.dart';

const _months = {
  'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6, //
  'jul': 7, 'aug': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12,
};

final _dmy = RegExp(
  r'^(\d{1,2})[\/\-. ]+([A-Za-z]{3,9}|\d{1,2})[\/\-., ]+(\d{2}|\d{4})$',
);
final _ymd = RegExp(r'^(\d{4})[\/\-.](\d{1,2})[\/\-.](\d{1,2})$');

/// Parses a statement date the way Indian banks write them: day first
/// (`05/01/24`, `05-01-2024`, `05-Jan-2024`, `5 Jan 2024`), or ISO
/// (`2024-01-05`). A trailing time is ignored. Returns null when the text
/// isn't a valid date, including impossible ones like 31/02.
LocalDate? parseStatementDate(String input) {
  var s = input.trim();
  // Drop a trailing time such as "10:32" or "10:32:05 AM".
  s = s.replaceFirst(
    RegExp(r'[ T]+\d{1,2}:\d{2}(:\d{2})?(\.\d+)?\s*([AaPp][Mm])?$'),
    '',
  );
  int? y;
  int? m;
  int? d;
  final iso = _ymd.firstMatch(s);
  if (iso != null) {
    y = int.parse(iso[1]!);
    m = int.parse(iso[2]!);
    d = int.parse(iso[3]!);
  } else {
    final dmy = _dmy.firstMatch(s);
    if (dmy == null) return null;
    d = int.parse(dmy[1]!);
    final mon = dmy[2]!;
    m = int.tryParse(mon) ?? _months[mon.toLowerCase().substring(0, 3)];
    if (mon.length > 3 && int.tryParse(mon) == null) {
      // Full month names must really be month names ("January"), not junk.
      const full = [
        'january', 'february', 'march', 'april', 'may', 'june', //
        'july', 'august', 'september', 'october', 'november', 'december',
      ];
      if (!full.contains(mon.toLowerCase()) && mon.toLowerCase() != 'sept') {
        return null;
      }
    }
    final yy = dmy[3]!;
    y = int.parse(yy);
    if (yy.length == 2) y += 2000;
  }
  if (m == null || m < 1 || m > 12 || d < 1) return null;
  final date = LocalDate(y, m, 1);
  if (d > date.daysInMonth) return null;
  return LocalDate(y, m, d);
}
