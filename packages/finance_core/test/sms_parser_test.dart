import 'package:finance_core/finance_core.dart';
import 'package:test/test.dart';

// Templates follow each bank's wording. Amounts, names, numbers and
// references are made up.

void main() {
  ParsedSms parse(String sender, String body) {
    final p = parseTransactionSms(sender, body);
    expect(p, isNotNull, reason: body);
    return p!;
  }

  test('Roarbank credit card spend', () {
    final p = parse(
      'VA-UNTYCC-S',
      'Rs. 220 spent at SOME PETROL DEPOT. Card: 1234 Time: 07/08/2026, '
          '02:04pm. Avl Limit: Rs. 640. Not you? Call 18000000000. '
          '-Roarbank by Unity SFB',
    );
    expect(p.institution, 'Unity Small Finance Bank');
    expect(p.direction, Direction.debit);
    expect(p.amount, Paise(22000));
    expect(p.counterparty, 'SOME PETROL DEPOT');
    expect(p.cardLast4, '1234');
    expect(p.isCreditCard, isTrue);
    expect(p.availableLimit, Paise(64000));
    expect(p.balance, isNull);
    expect(p.date, LocalDate(2026, 8, 7));
    expect(p.channel, Channel.card);
  });

  test('Kotak UPI sent and received', () {
    final sent = parse(
      'JD-KOTAKB-S',
      'Sent Rs.20.00 from Kotak Bank AC X1234 to teastall@ybl on 01-07-26.'
          'UPI Ref 611122223333. Not you, https://kotak.com/KBANKT/Fraud',
    );
    expect(sent.institution, 'Kotak Mahindra Bank');
    expect(sent.direction, Direction.debit);
    expect(sent.amount, Paise(2000));
    expect(sent.accountLast4, '1234');
    expect(sent.vpa, 'teastall@ybl');
    expect(sent.upiRef, '611122223333');
    expect(sent.channel, Channel.upi);
    expect(sent.date, LocalDate(2026, 7, 1));

    final received = parse(
      'AX-KOTAKB',
      'Received Rs.1000.00 in your Kotak Bank AC X1234 from ravi@okaxis on '
          '01-07-26.UPI Ref:622233334444.',
    );
    expect(received.direction, Direction.credit);
    expect(received.counterparty, 'ravi@okaxis');
    expect(received.upiRef, '622233334444');
  });

  test('HDFC UPI debit and credit', () {
    final sent = parse(
      'VM-HDFCBK',
      'Sent Rs.450.00\nFrom HDFC Bank A/C *1234\nTo SWIGGY\nOn 05/10/26\n'
          'Ref 412233445566\nNot You?\nCall 18002586161/SMS BLOCK UPI to '
          '7308080808',
    );
    expect(sent.institution, 'HDFC Bank');
    expect(sent.direction, Direction.debit);
    expect(sent.accountLast4, '1234');
    expect(sent.counterparty, 'SWIGGY');
    expect(sent.upiRef, '412233445566');

    final got = parse(
      'VM-HDFCBK',
      'Rs.500.00 credited to HDFC Bank A/c XX1234 on 05-10-26 from VPA '
          'ravi@ybl (UPI 412299887766)',
    );
    expect(got.direction, Direction.credit);
    expect(got.vpa, 'ravi@ybl');
    expect(got.upiRef, '412299887766');
  });

  test('SBI UPI debit without a currency sign', () {
    final p = parse(
      'AD-SBIUPI',
      'Dear UPI user A/C X1234 debited by 20.0 on date 01Jul26 trf to '
          'RAVI KUMAR Refno 611122223333. If not u? call 1800111109. -SBI',
    );
    expect(p.institution, 'State Bank of India');
    expect(p.amount, Paise(2000));
    expect(p.direction, Direction.debit);
    expect(p.counterparty, 'RAVI KUMAR');
    expect(p.upiRef, '611122223333');
    expect(p.date, LocalDate(2026, 7, 1));
  });

  test('ICICI debit names the payee before "credited"', () {
    final p = parse(
      'VM-ICICIT',
      'ICICI Bank Acct XX123 debited for Rs 20.00 on 01-Jul-26; RAVI KUMAR '
          'credited. UPI:611122223333. Call 18002662 for dispute.',
    );
    expect(p.direction, Direction.debit);
    expect(p.accountLast4, '123');
    expect(p.counterparty, 'RAVI KUMAR');
    expect(p.upiRef, '611122223333');
  });

  test('ATM withdrawal and balance', () {
    final p = parse(
      'VM-AXISBK',
      'INR 2000.00 withdrawn at ATM from A/c no. XX1234 on 03-10-26. '
          'Avl Bal INR 10,500.50',
    );
    expect(p.channel, Channel.atm);
    expect(p.balance, Paise(1050050));
  });

  test('refund of a failed payment is a credit', () {
    final p = parse(
      'VM-HDFCBK',
      'Rs.120.00 refunded to your A/c XX1234 for failed UPI txn Ref '
          '611122223333',
    );
    expect(p.direction, Direction.credit);
  });

  test('not transactions', () {
    for (final body in [
      '123456 is your OTP for a txn of Rs.500 at AMAZON. Do not share.',
      'RAVI has requested Rs.200 from you on UPI. Pay or decline in app.',
      'Your card bill of Rs.4,500 is due on 15-10-26. Min amt due Rs.225.',
      'Txn of Rs.300 at SHOP declined due to insufficient balance.',
      'UPI txn of Rs.50 failed. Any amount debited will be reversed.',
      'Get a pre-approved loan of Rs.2,00,000. Apply now!',
      'Rs.500 will be debited from your account for SIP on 05-11-26.',
      'Hello, no money here.',
    ]) {
      expect(parseTransactionSms('VM-HDFCBK', body), isNull, reason: body);
    }
  });

  test('sender ids', () {
    expect(institutionForSender('VM-HDFCBK-S'), 'HDFC Bank');
    expect(institutionForSender('VA-UNTYCC-S'), 'Unity Small Finance Bank');
    expect(institutionForSender('VM-SWIGGY'), isNull);
  });
}
