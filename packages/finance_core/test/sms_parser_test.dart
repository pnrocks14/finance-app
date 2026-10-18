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

  group('templates from other banks', () {
    // (sender, body, direction, amount in paise, expected payee or null,
    // card or account last digits, UPI ref)
    final cases = <(String, String, Direction, int, String?, String?, String?)>[
      (
        'JD-KOTAKD-S',
        'Sent Rs.250.00 from XXXXXX1234 to ASHA STORES on 01/07/2026. UPI '
            'ref no. 611122223333. Not you? Tap https://kotk.in/KOTAKD/x to '
            'report -Kotak',
        Direction.debit,
        25000,
        'ASHA STORES',
        '1234',
        '611122223333',
      ),
      (
        'VM-KOTAKB-S',
        'Received Rs. 5000.00 on 20-08-26 in your Kotak Bank A/C x1234 by an '
            'A/C linked to mobile x000. IMPS Ref no 623212017596.',
        Direction.credit,
        500000,
        null,
        '1234',
        null,
      ),
      (
        'VM-KOTAKB-S',
        'INR 499.00 spent on Kotak Credit Card x4321 on 01-Jul-2026 at '
            'SOME STORE. Avl limit INR 20,000.00 Fraud? https://example.com',
        Direction.debit,
        49900,
        'SOME STORE',
        '4321',
        null,
      ),
      (
        'AX-ICICIT-S',
        'INR 1,250.00 spent using ICICI Bank Card XX4321 on 05-Jul-26 on '
            'SOME SHOP. Avl Limit: INR 48,750.00.',
        Direction.debit,
        125000,
        'SOME SHOP',
        '4321',
        null,
      ),
      (
        'JM-ICICIT-S',
        'ICICI Bank Account XX123 credited:Rs. 85,000.00 on 02-Oct-26. Info '
            'NEFT-ICICN52026-ACME LTD. Available Balance is Rs. 1,09,550.00.',
        Direction.credit,
        8500000,
        null,
        '123',
        null,
      ),
      (
        'VM-SBICRD-S',
        'Rs.799.00 spent on your SBI Credit Card ending with 4321 on 03Oct26 '
            'at SOME MART. Your available limit is Rs.9,201.00.',
        Direction.debit,
        79900,
        'SOME MART',
        '4321',
        null,
      ),
      (
        'VM-AXISBK-S',
        'Spent INR 300.00 / Axis Bank Card no. XX4321 / 05-10-26 10:15:00 IST '
            '/ SOME CAFE / Avl Limit: INR 9,700.00 / Not you? SMS BLOCK 4321',
        Direction.debit,
        30000,
        null,
        '4321',
        null,
      ),
      (
        'VM-IDFCFB-S',
        'Your A/c XX1234 debited by Rs. 75.00 on 05/10/26; RAVI KUMAR '
            'credited. RRN 611122223333. Available balance Rs. 925.00. Team '
            'IDFC FIRST Bank',
        Direction.debit,
        7500,
        'RAVI KUMAR',
        '1234',
        '611122223333',
      ),
      (
        'VM-INDUSB-S',
        'A/c *XX1234 debited by Rs 40.00 towards tea@ybl. RRN: 611122223333. '
            'Not You? call 18600000000- IndusInd Bank.',
        Direction.debit,
        4000,
        'tea@ybl',
        '1234',
        '611122223333',
      ),
      (
        'VM-PNBSMS-S',
        'Ac XX1234 Credited with Rs.500.00 05-10-2026 10:15:00 thru UPI . '
            'Aval Bal Rs.1500.00 CR. (UPI Ref ID:611122223333)-PNB',
        Direction.credit,
        50000,
        null,
        '1234',
        '611122223333',
      ),
      (
        'VM-BOBTXN-S',
        'Rs.120.00 Dr. from A/c XX123456 on 05-10-2026. AvlBal:Rs880.00. '
            'Ref:611122223333 -Bank of Baroda',
        Direction.debit,
        12000,
        null,
        '123456',
        '611122223333',
      ),
      (
        'VM-CANBNK-S',
        'Dear Customer, Acct XXX123 Dr. INR 60.00 on 05/10/26 to SOME STALL; '
            'UPI: 611122223333; Bal INR 940.00.Not you? SMS BLOCKUPI to '
            '0000000000-CanaraBank',
        Direction.debit,
        6000,
        'SOME STALL',
        '123',
        '611122223333',
      ),
      (
        'VM-FEDBNK-S',
        'Rs 99.00 debited via UPI on 05-10-2026 10:15:00 to VPA shop@okicici.'
            'Ref No 611122223333.Small txns?Use UPI Lite!-Federal Bank',
        Direction.debit,
        9900,
        'shop@okicici',
        null,
        '611122223333',
      ),
      (
        'VM-JTEDGE-S',
        'Rs.150.00 debited to your Edge CSB Bank RuPay Credit Card ending '
            '4321 on 7/8/26, 2:04 PM - (UPI Ref no.611122223333).',
        Direction.debit,
        15000,
        null,
        '4321',
        '611122223333',
      ),
      (
        'VM-DOPBNK-G',
        'Account No. XXXXXXXX1234 CREDIT with amount Rs. 500.00 on '
            '05-10-2026. Balance: Rs.1500.00. [S123456]',
        Direction.credit,
        50000,
        null,
        '1234',
        null,
      ),
      (
        'VM-HDFCBK-S',
        'Update! INR 85,000.00 deposited in HDFC Bank A/c XX1234 on 02-OCT-26 '
            'for NEFT Cr-ICIC0000104-ACME LTD-ASHA KUMAR-ICICN520261002.Avl '
            'bal INR 1,09,550.00. Cheque deposits in A/C are subject to '
            'clearing',
        Direction.credit,
        8500000,
        null,
        '1234',
        null,
      ),
      (
        'AD-ICICIT-S',
        'Payment of Rs 4,500.00 has been received on your ICICI Bank Credit '
            'Card XX4321 through Bharat Bill Payment System on 10-OCT-26.',
        Direction.credit,
        450000,
        null,
        '4321',
        null,
      ),
    ];
    for (final (sender, body, dir, paise, payee, last, ref) in cases) {
      test(sender, () {
        final p = parse(sender, body);
        expect(p.direction, dir);
        expect(p.amount, Paise(paise));
        if (payee != null) expect(p.counterparty, payee);
        if (last != null) expect(p.cardLast4 ?? p.accountLast4, last);
        if (ref != null) expect(p.upiRef, ref);
      });
    }

    test('styled letters from SBI Card', () {
      final p = parse(
        'VM-SBICRD-S',
        'Rs.200.00 \u{1D5CC}\u{1D5C9}\u{1D5BE}\u{1D5C7}\u{1D5CD} on your SBI '
            'Credit Card ending with 4321 at SOME SHOP.',
      );
      expect(p.direction, Direction.debit);
      expect(p.counterparty, 'SOME SHOP');
    });

    test('more messages that are not transactions', () {
      for (final body in [
        'Your Amex SafeKey One-Time Password for INR 500.00, at SHOP is 1234.',
        'Payment of INR 4,500 on Kotak Credit Card xx4321 is due on 15-10-26.',
        'New Bill Alert: Your electricity bill of Rs.800 is generated.',
        'Auto Pay HDFC Bank NACH Mandate : Rs.500 received today for '
            'processing.',
        'Your A/C XX1234 has Avl BAL of INR 500.00 as on 05-10-26.',
        'Payment request of INR 200 from RAVI. Ignore if already paid.',
      ]) {
        expect(parseTransactionSms('VM-HDFCBK-S', body), isNull, reason: body);
      }
      expect(
        parseTransactionSms('VM-HDFCBK-P', 'Rs.500 credited as cashback!'),
        isNull,
      );
    });
  });

  test('sender ids', () {
    expect(institutionForSender('VM-HDFCBK-S'), 'HDFC Bank');
    expect(institutionForSender('VA-UNTYCC-S'), 'Unity Small Finance Bank');
    expect(institutionForSender('VM-SWIGGY'), isNull);
  });
}
