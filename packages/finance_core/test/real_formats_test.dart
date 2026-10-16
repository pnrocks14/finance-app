import 'package:finance_core/finance_core.dart';
import 'package:test/test.dart';

// Layouts copied from real exports (Kotak net banking CSV, PhonePe CSV,
// Google Pay PDF text), with every name, number and reference made up.

const kotakExport = '''
"","","Account Statement"
"ASHA RAVI KUMAR"
"FLAT 4 SUNRISE APARTMENTS","","","","Cust. Reln. No.","100200300"
"MG ROAD","","","","Account No.","1234567890"
"PUNE","","","","Period","From 01/07/2026 To 30/09/2026"
"MAHARASHTRA","","","","Currency","INR"
"INDIA","","","","Branch","MG ROAD"
"411001","","","","Nomination Regd","N"
"","","","","IFSC","KKBK0000001"

"Sl. No.","Transaction Date","Value Date","Description","Chq /Ref No.","Amount","Dr / Cr","Balance","Dr / Cr"
"1","01-07-2026 09:46:50","01-07-2026","UPI/TEA STALL/FDRL/611122223333/Pay to Bhara","UPI-600000000001","20.00","DR","980.00","CR"
"2","01-07-2026 12:14:51","01-07-2026","UPI/RAVI KUMAR SHA/KKBK/622233334444/Payment from","UPI-600000000002","1,000.00","CR","1,980.00","CR"
"3","08-07-2026 09:46:24","08-07-2026","UPI/ASHA RAVI KUMA/IPOS/633344445555/UPI","UPI-600000000003","300.00","DR","1,680.00","CR"
"4","15-07-2026 08:43:33","15-07-2026","CHRG:SMS ALERT FEE FOR THE MONTH OF JUN26","","1.06","DR","1,678.94","CR"
"5","31-08-2026 17:21:16","31-08-2026","UPI/UNITY SMALL FI/NSPB/644455556666/topup","UPI-600000000004","500.00","DR","1,178.94","CR"
"6","11-09-2026 10:53:14","11-09-2026","UPI/9800000000@pty/MAHG/655566667777/UPI","UPI-600000000005","10.00","DR","1,168.94","CR"
"7","01-10-2026 05:17:24","30-09-2026","Int.Pd:1234567890:01-07-2026 to 30-09-2026","","2.00","CR","1,170.94","CR"
"Closing Balance","as on 30/09/2026 INR 1,170.94"

"Important Note:"
"The transaction date refers to the date & time when the transactions have been posted in the system."
''';

const phonePeExport = '''
Transaction Statement for 9800000000
Duration,"19 Jul, 2026 - 17 Oct, 2026"

Date,Time,Transaction Details,Transaction ID,UTR,Transaction Type,Credit/debit instrument,Amount
"Oct 14, 2026","05:39 pm","Paid to Tea Corner","T2610141739290000000001","700011112222","DEBIT","Paid by XXXXXXXX4321","15"
"Jul 26, 2026","12:05 am","Received from Meera Joshi","T2607261648580000000002","700022223333","CREDIT","Credited to XXXXXXXX4321","1500.50"

This is an automatically generated statement. Customer(s) are requested to immediately notify PhonePe in case
of any errors in the statement at https://support.phonepe.com/statement
''';

/// Google Pay PDF text the way PDFium extracts it: one field per line, the
/// summary totals before the table.
const gpayPdfium = '''
Transaction statement\r
9800000000,\r
someone@example.com\r
Note: This statement reflects payments made by you on the Google Pay app. Self transfer payments are not included in the total money paid and\r
Page 1 of 2\r
Transaction statement period\r
01 July 2026 - 30 September 2026\r
Sent\r
₹1,020.50\r
Received\r
₹500\r
Date & time Transaction details Amount\r
01 Jul, 2026\r
09:46 AM\r
Paid to TEA STALL OWNER\r
UPI Transaction ID: 611122223333\r
Paid by Kotak Mahindra Bank 7890\r
₹20\r
01 Jul, 2026\r
12:14 PM\r
Received from RAVI KUMAR SHARMA\r
UPI Transaction ID: 622233334444\r
Paid to Kotak Mahindra Bank 7890\r
₹500\r
08 Jul, 2026\r
09:46 AM\r
Self transfer to India Post Payment Bank 4321\r
UPI Transaction ID: 633344445555\r
Paid by Kotak Mahindra Bank 7890\r
₹300\r
Transaction statement\r
9800000000,\r
someone@example.com\r
Page 2 of 2\r
Date & time Transaction details Amount\r
08 Jul, 2026\r
01:08 PM\r
Paid to Udupi Flavours\r
UPI Transaction ID: 677788889999\r
Paid by Unity Small Finance Bank Ltd XX65 | RuPay credit card\r
₹1,000.50\r
''';

/// The same statement as poppler's pdftotext lays it out: the summary
/// totals land inside the first entry and amounts come before the
/// instrument.
const gpayPoppler = '''
Transaction statement

9800000000,
someone@example.com

Transaction statement period
01 July 2026 - 30 September 2026

Date & time

Transaction details

01 Jul, 2026

Paid to TEA STALL OWNER

09:46 AM

UPI Transaction ID: 611122223333

Sent

Received

₹1,020.50

₹500

Amount
₹20

Paid by Kotak Mahindra Bank 7890
01 Jul, 2026

Received from RAVI KUMAR SHARMA

12:14 PM

UPI Transaction ID: 622233334444

₹500

Paid to Kotak Mahindra Bank 7890
08 Jul, 2026

Self transfer to India Post Payment Bank 4321

09:46 AM

UPI Transaction ID: 633344445555

₹300

Paid by Kotak Mahindra Bank 7890

Note: This statement reflects payments made by you on the Google Pay app.

Page 1 of 2
08 Jul, 2026

Paid to Udupi Flavours

01:08 PM

UPI Transaction ID: 677788889999

₹1,000.50

Paid by Unity Small Finance Bank Ltd XX65 | RuPay credit card
''';

DateTime ist(int y, int m, int d, int h, int min) =>
    DateTime.utc(y, m, d, h, min).subtract(istOffset);

void main() {
  group('dates', () {
    test('month first, as payment apps write it', () {
      expect(parseStatementDate('Oct 14, 2026'), LocalDate(2026, 10, 14));
      expect(parseStatementDate('Sept 3, 2026'), LocalDate(2026, 9, 3));
      expect(parseStatementDate('01 Jul, 2026'), LocalDate(2026, 7, 1));
      expect(parseStatementDate('Foo 14, 2026'), isNull);
      expect(parseStatementDate('Feb 30, 2026'), isNull);
    });
  });

  group('Kotak export', () {
    final result = parseStatement(kotakExport);

    test('reads every row between the account details and the footer', () {
      expect(result.layout.preset?.id, 'kotak_csv');
      expect(result.rows, hasLength(7));
      expect(result.errors, isEmpty);
      expect(result.balanceWarnings, isEmpty);
      expect(result.rows.first.date, LocalDate(2026, 7, 1));
      expect(result.rows[1].amount, Paise(100000));
      expect(result.rows[1].direction, Direction.credit);
    });

    test('names bank charges, interest and small-bank UPI codes', () {
      final d = [for (final r in result.rows) parseDescription(r.description)];
      expect(d[0].counterpartyName, 'TEA STALL');
      expect(d[0].upiRef, '611122223333');
      expect(d[2].bankCode, 'IPOS');
      expect(d[3].counterpartyName, 'Bank charges');
      expect(d[3].merchantKey, 'bank_charges');
      expect(d[5].bankCode, 'MAHG');
      expect(d[5].vpa, '9800000000@pty');
      expect(d[5].counterpartyName, isNull);
      expect(d[6].counterpartyName, 'Interest');
      expect(d[6].merchantKey, 'bank_interest');
    });

    test('a card top-up at the bank is a transfer', () {
      final matches = detectTransfers([
        for (final (i, r) in result.rows.indexed)
          TransferCandidate(
            id: '$i',
            accountId: 'kotak',
            accountKind: AccountKind.bankAccount,
            direction: r.direction,
            amount: r.amount,
            date: r.date,
            description: r.description,
          ),
      ]);
      expect(matches.keys, ['4']);
      expect(matches['4']!.reason, FlowReason.cardBill);
    });
  });

  group('PhonePe export', () {
    final result = parsePhonePeCsv(phonePeExport);

    test('reads rows and stops before the disclaimer', () {
      expect(looksLikePhonePeCsv(parseCsv(phonePeExport)), isTrue);
      expect(result.app, UpiApp.phonePe);
      expect(result.errors, isEmpty);
      expect(result.rows, hasLength(2));
      final paid = result.rows.first;
      expect(paid.date, LocalDate(2026, 10, 14));
      expect(paid.occurredAt, ist(2026, 10, 14, 17, 39));
      expect(paid.direction, Direction.debit);
      expect(paid.amount, Paise(1500));
      expect(paid.counterpartyName, 'Tea Corner');
      expect(paid.upiRef, '700011112222');
      expect(paid.appRef, 'T2610141739290000000001');
      expect(paid.instrument?.digits, '4321');
      expect(paid.instrument?.kind, AccountKind.bankAccount);
      expect(paid.instrument?.label, 'Account ••4321');
      final received = result.rows.last;
      expect(received.direction, Direction.credit);
      expect(received.amount, Paise(150050));
      expect(received.occurredAt, ist(2026, 7, 26, 0, 5));
      expect(received.counterpartyName, 'Meera Joshi');
    });

    test('a bank CSV is not mistaken for PhonePe', () {
      expect(looksLikePhonePeCsv(parseCsv(kotakExport)), isFalse);
      expect(() => parsePhonePeCsv(kotakExport), throwsFormatException);
    });
  });

  group('Google Pay PDF text', () {
    for (final (name, text) in [
      ('PDFium order', gpayPdfium),
      ('poppler order', gpayPoppler),
    ]) {
      test('reads every entry in $name', () {
        expect(looksLikeGooglePayText(text), isTrue);
        final r = parseGooglePayText(text);
        expect(r.errors, isEmpty);
        expect(r.rows, hasLength(4));
        expect(r.sentTotal, Paise(102050));
        expect(r.receivedTotal, Paise(50000));
        // Self transfers are left out of Google Pay's own totals.
        expect(r.totalsMatch, isTrue);

        final first = r.rows[0];
        expect(first.date, LocalDate(2026, 7, 1));
        expect(first.occurredAt, ist(2026, 7, 1, 9, 46));
        expect(first.direction, Direction.debit);
        expect(first.amount, Paise(2000));
        expect(first.counterpartyName, 'TEA STALL OWNER');
        expect(first.upiRef, '611122223333');
        expect(first.instrument?.label, 'Kotak Mahindra Bank ••7890');
        expect(first.rawText, isNot(contains('example.com')));

        expect(r.rows[1].direction, Direction.credit);
        expect(r.rows[1].instrument?.digits, '7890');
        expect(r.rows[2].isSelfTransfer, isTrue);
        expect(r.rows[2].direction, Direction.debit);

        final card = r.rows[3];
        expect(card.amount, Paise(100050));
        expect(card.instrument?.kind, AccountKind.creditCard);
        expect(card.instrument?.digits, '65');
        expect(card.instrument?.institution, 'Unity Small Finance Bank Ltd');

        expect(r.instruments, hasLength(2));
        expect(r.periodFrom, LocalDate(2026, 7, 1));
        expect(r.periodTo, LocalDate(2026, 7, 8));
      });
    }

    test('an entry without an amount is reported, not dropped', () {
      const text = '''
01 Jul, 2026
09:46 AM
Paid to SOMEONE
UPI Transaction ID: 611122223333
Paid by Kotak Mahindra Bank 7890
02 Jul, 2026
Paid to SOMEONE ELSE
₹40
Paid by Kotak Mahindra Bank 7890
''';
      final r = parseGooglePayText(text);
      expect(r.rows, hasLength(1));
      expect(r.rows.single.occurredAt, isNull);
      expect(r.errors.single.lineNumber, 1);
      expect(r.errors.single.problem, RowProblem.noAmount);
      expect(r.totalsMatch, isNull);
    });

    test('row hashes ignore the account and repeat on re-import', () {
      final a = parseGooglePayText(gpayPdfium);
      final b = parseGooglePayText(gpayPoppler);
      expect(
        appRowHashes(UpiApp.googlePay, a.rows),
        appRowHashes(UpiApp.googlePay, b.rows),
      );
      expect(appRowHashes(UpiApp.googlePay, a.rows).toSet(), hasLength(4));
    });
  });

  group('transfers', () {
    TransferCandidate tx(
      String id,
      String account,
      Direction d, {
      String? upiRef,
      String? payee,
      AccountKind kind = AccountKind.bankAccount,
    }) => TransferCandidate(
      id: id,
      accountId: account,
      accountKind: kind,
      direction: d,
      amount: Paise(2000),
      date: LocalDate(2026, 8, 10),
      description: 'UPI',
      upiRef: upiRef,
      counterpartyName: payee,
    );

    test('different UPI references never pair', () {
      final m = detectTransfers([
        tx('a', 'x', Direction.debit, upiRef: '111111111111'),
        tx('b', 'y', Direction.credit, upiRef: '222222222222'),
      ]);
      expect(m, isEmpty);
    });

    test('the same UPI reference pairs', () {
      final m = detectTransfers([
        tx('a', 'x', Direction.debit, upiRef: '111111111111'),
        tx('b', 'y', Direction.credit, upiRef: '111111111111'),
      ]);
      expect(m['a']!.counterpartId, 'b');
    });

    test('paying the bank behind your credit card is a card bill', () {
      final m = detectTransfers(
        [
          tx(
            'a',
            'x',
            Direction.debit,
            payee: 'UNITY SMALL FINANCE BANK LIMITED',
          ),
          tx('b', 'x', Direction.debit, payee: 'UNITY SMALL FI'),
          tx('c', 'x', Direction.debit, payee: 'Udupi Flavours'),
          tx(
            'd',
            'card',
            Direction.debit,
            payee: 'Unity Small Finance Bank Ltd',
            kind: AccountKind.creditCard,
          ),
        ],
        cardIssuers: {'Unity Small Finance Bank Ltd'},
      );
      expect(m.keys.toSet(), {'a', 'b'});
      expect(m['a']!.reason, FlowReason.cardBill);
    });
  });
}
