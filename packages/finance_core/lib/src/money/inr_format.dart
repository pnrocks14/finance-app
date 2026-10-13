import 'paise.dart';

/// How to show the paise part of an amount.
enum PaiseDisplay {
  /// Show `.50` only when the paise part is not zero: ₹450, ₹450.50.
  whenNonZero,

  /// Always show two decimals: ₹450.00.
  always,

  /// Round to whole rupees: ₹451.
  never,
}

/// Formats [amount] in Indian style: `₹1,23,456.70`.
///
/// The first group from the right has three digits and every group after it
/// has two (lakh and crore grouping). Negative amounts get a leading minus:
/// `-₹450`.
String formatInr(
  Paise amount, {
  PaiseDisplay paise = PaiseDisplay.whenNonZero,
  bool symbol = true,
}) {
  var value = amount.value;
  if (paise == PaiseDisplay.never) {
    // percent(1) is the amount in whole rupees, rounded half away from zero.
    value = amount.percent(1).value * 100;
  }
  final negative = value < 0;
  final abs = value.abs();
  final whole = _groupIndian(abs ~/ 100);
  final fraction = abs % 100;

  final buffer = StringBuffer();
  if (negative) buffer.write('-');
  if (symbol) buffer.write('₹');
  buffer.write(whole);
  final showFraction = switch (paise) {
    PaiseDisplay.always => true,
    PaiseDisplay.whenNonZero => fraction != 0,
    PaiseDisplay.never => false,
  };
  if (showFraction) {
    buffer
      ..write('.')
      ..write(fraction.toString().padLeft(2, '0'));
  }
  return buffer.toString();
}

/// Short form for chart labels and tight spaces: ₹950, ₹12.3K, ₹4.5L, ₹1.2Cr.
///
/// Uses one decimal and drops a trailing `.0`. Amounts under ₹1,000 are shown
/// in whole rupees.
String formatInrCompact(Paise amount) {
  final negative = amount.isNegative;
  final rupees = amount.abs().value / 100;
  final String body;
  if (rupees >= 1e7) {
    body = '${_oneDecimal(rupees / 1e7)}Cr';
  } else if (rupees >= 1e5) {
    body = '${_oneDecimal(rupees / 1e5)}L';
  } else if (rupees >= 1e3) {
    body = '${_oneDecimal(rupees / 1e3)}K';
  } else {
    body = rupees.round().toString();
  }
  return '${negative ? '-' : ''}₹$body';
}

String _oneDecimal(double value) {
  final fixed = ((value * 10).floor() / 10).toStringAsFixed(1);
  return fixed.endsWith('.0') ? fixed.substring(0, fixed.length - 2) : fixed;
}

String _groupIndian(int number) {
  final digits = number.toString();
  if (digits.length <= 3) return digits;
  final lastThree = digits.substring(digits.length - 3);
  var rest = digits.substring(0, digits.length - 3);
  final groups = <String>[];
  while (rest.length > 2) {
    groups.insert(0, rest.substring(rest.length - 2));
    rest = rest.substring(0, rest.length - 2);
  }
  if (rest.isNotEmpty) groups.insert(0, rest);
  return '${groups.join(',')},$lastThree';
}
