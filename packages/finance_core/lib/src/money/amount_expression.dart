import 'paise.dart';

/// The keypad's operators, as shown on the keys.
const amountOperators = {'+', '−', '×', '÷'};

/// Works out a keypad sum like `120+45.5×2` in paise, with × and ÷ before
/// + and −, and without floating point. Each number may have up to two
/// decimals. A trailing operator is ignored, so `120+` is ₹120.
///
/// Returns null for an empty or broken sum, or division by zero. The result
/// is rounded to the nearest paisa and may be negative.
Paise? evaluateAmount(String expression) {
  var s = expression.replaceAll(' ', '').replaceAll(',', '');
  while (s.isNotEmpty && amountOperators.contains(s[s.length - 1])) {
    s = s.substring(0, s.length - 1);
  }
  if (s.isEmpty) return null;

  // Split into numbers and operators.
  final numbers = <_Fraction>[];
  final ops = <String>[];
  final buf = StringBuffer();
  for (final ch in s.split('')) {
    if (amountOperators.contains(ch)) {
      final n = _Fraction.tryParse(buf.toString());
      if (n == null) return null;
      numbers.add(n);
      ops.add(ch);
      buf.clear();
    } else {
      buf.write(ch);
    }
  }
  final last = _Fraction.tryParse(buf.toString());
  if (last == null) return null;
  numbers.add(last);

  // × and ÷ first.
  final terms = <_Fraction>[numbers.first];
  final signs = <String>[];
  for (var i = 0; i < ops.length; i++) {
    final op = ops[i];
    final n = numbers[i + 1];
    if (op == '×') {
      terms.last = terms.last * n;
    } else if (op == '÷') {
      if (n.num == BigInt.zero) return null;
      terms.last = terms.last / n;
    } else {
      signs.add(op);
      terms.add(n);
    }
  }
  var total = terms.first;
  for (var i = 0; i < signs.length; i++) {
    total = signs[i] == '+' ? total + terms[i + 1] : total - terms[i + 1];
  }
  return Paise(total.toPaise());
}

/// An exact fraction of rupees.
final class _Fraction {
  _Fraction(BigInt num, BigInt den) : this._norm(num, den);

  _Fraction._norm(BigInt n, BigInt d)
    : num = d.isNegative ? -n : n,
      den = d.abs();

  final BigInt num;
  final BigInt den;

  static final _number = RegExp(r'^(\d*)(?:\.(\d{0,2}))?$');

  static _Fraction? tryParse(String s) {
    final m = _number.firstMatch(s);
    if (m == null || (m[1]!.isEmpty && (m[2] ?? '').isEmpty)) return null;
    final whole = BigInt.parse(m[1]!.isEmpty ? '0' : m[1]!);
    final frac = (m[2] ?? '').padRight(2, '0');
    return _Fraction(whole * BigInt.from(100) + BigInt.parse(frac), _hundred);
  }

  static final _hundred = BigInt.from(100);

  _Fraction operator +(_Fraction o) =>
      _Fraction(num * o.den + o.num * den, den * o.den);
  _Fraction operator -(_Fraction o) =>
      _Fraction(num * o.den - o.num * den, den * o.den);
  _Fraction operator *(_Fraction o) => _Fraction(num * o.num, den * o.den);
  _Fraction operator /(_Fraction o) => _Fraction(num * o.den, den * o.num);

  /// Rupees as paise, rounded half away from zero.
  int toPaise() {
    final scaled = num * _hundred;
    final q = scaled ~/ den;
    final r = (scaled - q * den).abs() * BigInt.two;
    final round = r >= den
        ? (scaled.isNegative ? -BigInt.one : BigInt.one)
        : BigInt.zero;
    return (q + round).toInt();
  }
}
