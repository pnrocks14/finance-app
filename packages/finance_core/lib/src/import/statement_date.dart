import '../time/local_date.dart';

const _months = {
  'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6, //
  'jul': 7, 'aug': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12,
};

final _dmy = RegExp(
  r'^(\d{1,2})[\/\-. ]+([A-Za-z]{3,9}|\d{1,2})[\/\-., ]+(\d{2}|\d{4})$',
);
final _ymd = RegExp(r'^(\d{4})[\/\-.](\d{1,2})[\/\-.](\d{1,2})$');

/// Month first, as payment apps write it: `Oct 14, 2026`.
final _mdy = RegExp(r'^([A-Za-z]{3,9})\.? (\d{1,2}),? (\d{4})$');

/// Parses a statement date the way Indian banks write them: day first
/// (`05/01/24`, `05-01-2024`, `05-Jan-2024`, `5 Jan 2024`), or ISO
/// (`2024-01-05`). Month first with a spelled month (`Oct 14, 2026`), as
/// payment apps write it, works too. A trailing time is ignored. Returns
/// null when the text isn't a valid date, including impossible ones like
/// 31/02.
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
  final mdy = _mdy.firstMatch(s);
  if (iso != null) {
    y = int.parse(iso[1]!);
    m = int.parse(iso[2]!);
    d = int.parse(iso[3]!);
  } else if (mdy != null) {
    m = _monthNumber(mdy[1]!);
    d = int.parse(mdy[2]!);
    y = int.parse(mdy[3]!);
  } else {
    final dmy = _dmy.firstMatch(s);
    if (dmy == null) return null;
    d = int.parse(dmy[1]!);
    final mon = dmy[2]!;
    m = int.tryParse(mon) ?? _monthNumber(mon);
    final yy = dmy[3]!;
    y = int.parse(yy);
    if (yy.length == 2) y += 2000;
  }
  if (m == null || m < 1 || m > 12 || d < 1) return null;
  final date = LocalDate(y, m, 1);
  if (d > date.daysInMonth) return null;
  return LocalDate(y, m, d);
}

const _fullMonths = [
  'january', 'february', 'march', 'april', 'may', 'june', //
  'july', 'august', 'september', 'october', 'november', 'december',
];

/// `Jan`, `jan`, `January` and `Sept` → 1..12. Longer words must really be
/// month names, not junk that happens to start like one.
int? _monthNumber(String name) {
  final lower = name.toLowerCase();
  if (lower.length > 3 && !_fullMonths.contains(lower) && lower != 'sept') {
    return null;
  }
  return _months[lower.substring(0, 3)];
}
