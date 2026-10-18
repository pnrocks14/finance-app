import 'package:finance_core/finance_core.dart';
import 'package:test/test.dart';

// Made-up statements in layouts found while researching other banks'
// downloads. Names and numbers are fictional.

void main() {
  group('password candidates', () {
    final d = PasswordDetails(
      name: 'Asha Kumar',
      dateOfBirth: LocalDate(1990, 1, 5),
      mobile: '+91 98765 43210',
      customerId: '12345678',
      accountNumber: '5010 0012 3456',
      cardLast4: '4321',
    );

    test('covers the published rules, most common first', () {
      final c = statementPasswordCandidates(d);
      expect(c.first, 'ASHA0501');
      expect(
        c,
        containsAll([
          'asha0501', // ICICI card, Bank of Baroda
          '05011990', // Kotak, IDFC
          '050190',
          '12345678', // HDFC customer ID
          '1234567805011990', // Yes Bank
          '43210050190', // SBI: last 5 of mobile + DDMMYY
          'ASHA4321', // HDFC card
          'ASHA050190', // IPPB
          'asha05011990',
          '501000123456', // account number
          '9876543210',
          '050119904321', // SBI Card
        ]),
      );
      expect(c.toSet(), hasLength(c.length));
    });

    test('needs enough to build anything', () {
      expect(statementPasswordCandidates(const PasswordDetails()), isEmpty);
      expect(
        statementPasswordCandidates(const PasswordDetails(name: 'Al')),
        isEmpty,
      );
    });
  });

  group('csv variants', () {
    test('Canara: ="…" cells and a Branch Code column', () {
      const csv = '''
Txn Date,Value Date,Cheque No.,Description,Branch Code,Debit,Credit,Balance
05-10-2026,05-10-2026,="000123",UPI/DR/611122223333/SOME STALL/YESB/stall@ybl,="1234",60.00,,940.00
06-10-2026,06-10-2026,,NEFT CR ACME LTD,="1234",,"1,000.00","1,940.00"
''';
      final r = parseStatement(csv);
      expect(r.layout.preset?.id, 'canara_csv');
      expect(r.errors, isEmpty);
      expect(r.rows, hasLength(2));
      expect(r.rows[0].reference, '000123');
      expect(r.rows[0].direction, Direction.debit);
      expect(r.rows[1].amount, Paise(100000));
    });

    test('card statement: empty sign means a spend', () {
      const csv = '''
Transaction Date,Details,Amount (INR),Billing Amount Sign
05/10/2026,SOME SHOP BENGALURU,"1,250.00",
10/10/2026,BBPS PAYMENT RECEIVED,"4,500.00",CR
''';
      final r = parseStatement(csv);
      expect(r.errors, isEmpty);
      expect(r.rows, hasLength(2));
      expect(r.rows[0].direction, Direction.debit);
      expect(r.rows[0].amount, Paise(125000));
      expect(r.rows[1].direction, Direction.credit);
    });

    test('HDFC: page breaks inside the table are skipped', () {
      const csv = '''
Date,Narration,Chq./Ref.No.,Value Dt,Withdrawal Amt.,Deposit Amt.,Closing Balance
01/10/26,UPI-SWIGGY-swiggy@ybl-YESB0000001-412233445566-Payment,0000412233445566,01/10/26,450.00,,"24,550.00"
**Continue**,,,,,,
02/10/26,NEFT CR-ICIC0000104-ACME LTD,ICICN52026100212345,02/10/26,,"85,000.00","1,09,550.00"
''';
      final r = parseStatement(csv);
      expect(r.errors, isEmpty);
      expect(r.rows, hasLength(2));
    });
  });

  test('PDF: a B/F row is the opening balance, not a transaction', () {
    const text = '''
Bank of Baroda
Date Particulars Withdrawals Deposits Balance
01-10-2026 B/F 1,000.00
02-10-2026 UPI/611122223333/SOME STALL 60.00 940.00
03-10-2026 NEFT ACME LTD 1,000.00 1,940.00
''';
    final r = parseBankPdfText(text);
    expect(r.errors, isEmpty);
    expect(r.rows, hasLength(2));
    expect(r.rows[0].direction, Direction.debit);
    expect(r.rows[1].direction, Direction.credit);
    expect(r.balanceWarnings, isEmpty);
  });
}
