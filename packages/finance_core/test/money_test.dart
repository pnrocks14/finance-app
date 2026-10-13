import 'package:finance_core/finance_core.dart';
import 'package:test/test.dart';

void main() {
  group('Paise.tryParse', () {
    test('parses plain and decimal amounts exactly', () {
      expect(Paise.tryParse('450'), const Paise(45000));
      expect(Paise.tryParse('450.5'), const Paise(45050));
      expect(Paise.tryParse('450.05'), const Paise(45005));
      expect(Paise.tryParse('0.99'), const Paise(99));
    });

    test('accepts Indian and Western grouping', () {
      expect(Paise.tryParse('1,23,456.70'), const Paise(12345670));
      expect(Paise.tryParse('123,456.70'), const Paise(12345670));
    });

    test('accepts currency prefixes found in SMS and statements', () {
      expect(Paise.tryParse('₹450'), const Paise(45000));
      expect(Paise.tryParse('Rs. 1,200.50'), const Paise(120050));
      expect(Paise.tryParse('Rs 99'), const Paise(9900));
      expect(Paise.tryParse('INR 2,000'), const Paise(200000));
    });

    test('handles negative amounts', () {
      expect(Paise.tryParse('-99.99'), const Paise(-9999));
      expect(Paise.tryParse('Rs. -10'), const Paise(-1000));
    });

    test('rejects malformed text', () {
      expect(Paise.tryParse(''), isNull);
      expect(Paise.tryParse('abc'), isNull);
      expect(Paise.tryParse('1.234'), isNull);
      expect(Paise.tryParse('12,34'), isNull);
      expect(() => Paise.parse('x'), throwsFormatException);
    });
  });

  group('Paise arithmetic', () {
    test('adds, subtracts and compares', () {
      const a = Paise(1050);
      const b = Paise(50);
      expect(a + b, const Paise(1100));
      expect(a - b, const Paise(1000));
      expect(a > b, isTrue);
      expect(-a, const Paise(-1050));
    });

    test('percent rounds half away from zero', () {
      expect(const Paise(1001).percent(50), const Paise(501));
      expect(const Paise(-1001).percent(50), const Paise(-501));
      expect(const Paise(45000).percent(25), const Paise(11250));
    });

    test('exposes rupee and paise parts', () {
      expect(const Paise(45050).wholeRupees, 450);
      expect(const Paise(45050).paisePart, 50);
      expect(Paise.rupees(12), const Paise(1200));
    });
  });

  group('formatInr', () {
    test('uses lakh and crore grouping', () {
      expect(formatInr(const Paise(0)), '₹0');
      expect(formatInr(const Paise(99900)), '₹999');
      expect(formatInr(const Paise(100000)), '₹1,000');
      expect(formatInr(const Paise(12345600)), '₹1,23,456');
      expect(formatInr(const Paise(1234567800)), '₹1,23,45,678');
    });

    test('shows paise only when asked or non-zero', () {
      expect(formatInr(const Paise(45050)), '₹450.50');
      expect(formatInr(const Paise(45000)), '₹450');
      expect(
        formatInr(const Paise(45000), paise: PaiseDisplay.always),
        '₹450.00',
      );
      expect(formatInr(const Paise(45050), paise: PaiseDisplay.never), '₹451');
      expect(formatInr(const Paise(45049), paise: PaiseDisplay.never), '₹450');
    });

    test('formats negatives and can drop the symbol', () {
      expect(formatInr(const Paise(-45000)), '-₹450');
      expect(formatInr(const Paise(123456), symbol: false), '1,234.56');
    });
  });

  group('formatInrCompact', () {
    test('uses K, L and Cr', () {
      expect(formatInrCompact(const Paise(95000)), '₹950');
      expect(formatInrCompact(const Paise(1234500)), '₹12.3K');
      expect(formatInrCompact(const Paise(45000000)), '₹4.5L');
      expect(formatInrCompact(const Paise(1200000000)), '₹1.2Cr');
      expect(formatInrCompact(const Paise(100000)), '₹1K');
      expect(formatInrCompact(const Paise(-250000)), '-₹2.5K');
    });
  });
}
