/// Money is always an integer number of paise (1 rupee = 100 paise).
///
/// Never use `double` for money anywhere in the app. Fields that hold money
/// end in `Paise` (for example `amountPaise`), and their values are whole
/// numbers: `45000` means ₹450.00.
extension type const Paise(int value) implements Comparable<num> {
  static const Paise zero = Paise(0);

  /// Builds an amount from whole rupees, e.g. `Paise.rupees(450)` is ₹450.00.
  factory Paise.rupees(int rupees) => Paise(rupees * 100);

  /// Parses a rupee amount as written in statements and SMS, without ever
  /// going through floating point.
  ///
  /// Accepts optional `₹`, `Rs`, `Rs.` or `INR` prefixes, Indian or Western
  /// thousands separators, up to two decimal places and a leading minus sign:
  /// `"1,23,456.70"`, `"Rs. 450"`, `"INR 1,200.5"`, `"-99.99"`.
  /// Returns `null` when the text is not a valid amount.
  static Paise? tryParse(String text) {
    var s = text.trim();
    var negative = false;
    if (s.startsWith('-')) {
      negative = true;
      s = s.substring(1).trim();
    }
    s = s.replaceFirst(_currencyPrefix, '').trim();
    if (s.startsWith('-')) {
      negative = !negative;
      s = s.substring(1).trim();
    }
    final match = _amountPattern.firstMatch(s);
    if (match == null) return null;

    final whole = int.parse(match.group(1)!.replaceAll(',', ''));
    final fraction = match.group(2) ?? '';
    final paisePart = fraction.isEmpty
        ? 0
        : int.parse(fraction.padRight(2, '0'));
    final total = whole * 100 + paisePart;
    return Paise(negative ? -total : total);
  }

  /// Like [tryParse] but throws a [FormatException] for invalid input.
  static Paise parse(String text) {
    final result = tryParse(text);
    if (result == null) {
      throw FormatException('Not a rupee amount', text);
    }
    return result;
  }

  Paise operator +(Paise other) => Paise(value + other.value);
  Paise operator -(Paise other) => Paise(value - other.value);
  Paise operator -() => Paise(-value);
  bool operator <(Paise other) => value < other.value;
  bool operator <=(Paise other) => value <= other.value;
  bool operator >(Paise other) => value > other.value;
  bool operator >=(Paise other) => value >= other.value;

  /// Scales by a percentage using integer maths, rounding half away from
  /// zero. `Paise(1001).percent(50)` is `Paise(501)`.
  Paise percent(int percent) {
    final scaled = value * percent;
    final rounded = scaled >= 0 ? (scaled + 50) ~/ 100 : (scaled - 50) ~/ 100;
    return Paise(rounded);
  }

  Paise abs() => Paise(value.abs());
  bool get isZero => value == 0;
  bool get isNegative => value < 0;

  /// The whole-rupee part, truncated toward zero.
  int get wholeRupees => value ~/ 100;

  /// The paise part, always between 0 and 99.
  int get paisePart => value.abs() % 100;
}

final RegExp _currencyPrefix = RegExp(
  r'^(₹|rs\.?|inr)\s*',
  caseSensitive: false,
);

// Whole part as plain digits, Western grouping (1,234,567) or Indian grouping
// (12,34,567), then up to two decimal digits.
final RegExp _amountPattern = RegExp(
  r'^(\d+|\d{1,3}(?:,\d{3})+|\d{1,2}(?:,\d{2})*,\d{3})(?:\.(\d{1,2}))?$',
);
