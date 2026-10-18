import 'dart:convert';

import 'package:finance_core/finance_core.dart';
import 'package:test/test.dart';

// All samples below are made up. Account numbers, names and references are
// fictional and only follow each bank's export layout.

const hdfc = '''
HDFC BANK Ltd.,,,,,,
Statement of account,,,,,,
Account No :,50100012345678,,,,,
,,,,,,
Date,Narration,Chq./Ref.No.,Value Dt,Withdrawal Amt.,Deposit Amt.,Closing Balance
01/10/26,UPI-SWIGGY-swiggy@ybl-YESB0000001-412233445566-Payment from Ph,0000412233445566,01/10/26,450.00,,"24,550.00"
02/10/26,NEFT CR-ICIC0000104-ACME TECHNOLOGIES PVT LTD-SALARY OCT-ICICN52026100212345,ICICN52026100212345,02/10/26,,"85,000.00","1,09,550.00"
03/10/26,POS 416021XXXXXX1234 AMAZON PAY INDIA,000000000000,03/10/26,"1,299.00",,"1,08,251.00"
,,,,,,
04/10/26,ATW-416021XXXXXX1234-S1ANBG12-BANGALORE,000000000000,04/10/26,"2,000.00",,"1,06,251.00"
05/10/26,UPI-RAHUL SHARMA-9876543210@ybl-SBIN0001234-412299887766-dinner,0000412299887766,05/10/26,600.00,,"1,05,651.00"
06/10/26,UPI-ZOMATO REFUND-zomato@hdfcbank-HDFC0000001-412255554444-Refund,0000412255554444,06/10/26,,180.00,"1,05,831.00"
xx/10/26,BROKEN ROW,,,10.00,,
STATEMENT SUMMARY :-,,,,,,
Opening Balance,Dr Count,Cr Count,Debits,Credits,Closing Bal,
"25,000.00",4,2,"4,349.00","85,180.00","1,05,831.00",
''';

const icici = '''
S No.,Value Date,Transaction Date,Cheque Number,Transaction Remarks,Withdrawal Amount (INR ),Deposit Amount (INR ),Balance (INR )
1,01/10/2026,01/10/2026,-,UPI/412233445566/Payment from Ph/swiggy@ybl/YES BANK LIMITED/YBL0123,450.00,0.00,"24,550.00"
2,02/10/2026,02/10/2026,-,BIL/ONL/001234567/AIRTEL/PAYMENT,999.00,0.00,"23,551.00"
3,03/10/2026,03/10/2026,-,MMT/IMPS/627612345678/Rent Oct/PRIYA NAIR/SBIN0005678,"18,000.00",0.00,"5,551.00"
''';

const sbi =
    'Txn Date\tValue Date\tDescription\tRef No./Cheque No.\tDebit\tCredit\tBalance\n'
    '1 Oct 2026\t1 Oct 2026\tTO TRANSFER-UPI/DR/412233445566/SWIGGY/YESB/swiggy@ybl/Payment--\tTRANSFER TO 4897691162091\t450.00\t\t24,550.00\n'
    '2 Oct 2026\t2 Oct 2026\tBY TRANSFER-NEFT*HDFC0000001*N275261234567*ACME TECH*\tTRANSFER FROM 4897690162090\t\t85,000.00\t1,09,550.00\n';

const axis = '''
Tran Date,CHQNO,PARTICULARS,DR,CR,BAL,SOL
01-10-2026,,UPI/P2M/412233445566/SWIGGY/YESB/swiggy@ybl,450.00,,24550.00,1234
02-10-2026,,ACH/HDFCLIFE/123456789,"2,500.00",,22050.00,1234
''';

const kotak = '''
Sl. No.,Transaction Date,Value Date,Description,Chq / Ref No.,Amount,Dr / Cr,Balance,Dr / Cr
1,01-10-2026,01-10-2026,UPI/SWIGGY/412233445566/Payment,UPI-412233445566,450.00,DR,"24,550.00",CR
2,02-10-2026,02-10-2026,IMPS-627612345678-ACME TECH-SALARY,627612345678,"85,000.00",CR,"1,09,550.00",CR
''';

void main() {
  group('csv reader', () {
    test('handles quotes, doubled quotes, commas and line breaks in cells', () {
      final rows = parseCsv('a,"b,c","say ""hi""","two\nlines"\r\nx,y\n');
      expect(rows[0], ['a', 'b,c', 'say "hi"', 'two\nlines']);
      expect(rows[1], ['x', 'y']);
    });

    test('detects tab and comma delimiters', () {
      expect(detectDelimiter(sbi), '\t');
      expect(detectDelimiter(hdfc), ',');
    });

    test('decodes UTF-8 BOM, UTF-16LE and Latin-1', () {
      expect(decodeStatementBytes([0xEF, 0xBB, 0xBF, 0x41]), 'A');
      expect(decodeStatementBytes([0xFF, 0xFE, 0x41, 0x00, 0x42, 0x00]), 'AB');
      expect(decodeStatementBytes([0x41, 0xE9]), 'Aé');
      expect(decodeStatementBytes(utf8.encode('₹10')), '₹10');
    });
  });

  group('statement dates', () {
    test('day-first formats used by Indian banks', () {
      for (final s in [
        '05/01/24',
        '05/01/2024',
        '05-01-2024',
        '05-Jan-2024',
        '5 Jan 2024',
        '05 January 2024',
        '2024-01-05',
        '05/01/2024 10:32:05',
      ]) {
        expect(parseStatementDate(s), LocalDate(2024, 1, 5), reason: s);
      }
    });

    test('rejects impossible and junk dates', () {
      for (final s in [
        '31/02/2024',
        '00/01/2024',
        '01/13/2024',
        'xx/10/26',
        '',
        '05 Foo 2024',
      ]) {
        expect(parseStatementDate(s), isNull, reason: s);
      }
    });
  });

  group('description parser', () {
    test('HDFC UPI narration', () {
      final p = parseDescription(
        'UPI-SWIGGY-swiggy@ybl-YESB0000001-412233445566-Payment from Ph',
      );
      expect(p.channel, Channel.upi);
      expect(p.counterpartyName, 'SWIGGY');
      expect(p.vpa, 'swiggy@ybl');
      expect(p.upiRef, '412233445566');
      expect(p.bankCode, 'YESB');
      expect(p.merchantKey, 'swiggy');
    });

    test('ICICI UPI narration with the note before the VPA', () {
      final p = parseDescription(
        'UPI/412233445566/Payment from Ph/swiggy@ybl/YES BANK LIMITED/YBL0123',
      );
      expect(p.channel, Channel.upi);
      expect(p.vpa, 'swiggy@ybl');
      expect(p.upiRef, '412233445566');
      expect(p.merchantKey, 'swiggy');
    });

    test('SBI UPI narration', () {
      final p = parseDescription(
        'TO TRANSFER-UPI/DR/412233445566/SWIGGY/YESB/swiggy@ybl/Payment--',
      );
      expect(p.channel, Channel.upi);
      expect(p.counterpartyName, 'SWIGGY');
      expect(p.upiRef, '412233445566');
      expect(p.bankCode, 'YESB');
    });

    test('phone-number VPA is a person, QR handles are merchants', () {
      expect(
        parseDescription(
          'UPI-RAHUL SHARMA-9876543210@ybl-SBIN0001234-412299887766-dinner',
        ).counterpartyKind,
        CounterpartyKind.person,
      );
      expect(
        parseDescription(
          'UPI-CHAI POINT-paytmqr1abcde@paytm-PYTM0123456-412211112222-UPI',
        ).counterpartyKind,
        CounterpartyKind.merchant,
      );
      expect(
        parseDescription('UPI/P2M/412233445566/KIRANA/YESB/Q123456789@ybl')
            .counterpartyKind,
        CounterpartyKind.merchant,
      );
    });

    test('NEFT with IFSC, company name and UTR', () {
      final p = parseDescription(
        'NEFT CR-ICIC0000104-ACME TECHNOLOGIES PVT LTD-SALARY OCT-ICICN52026100212345',
      );
      expect(p.channel, Channel.neft);
      expect(p.counterpartyName, 'ACME TECHNOLOGIES PVT LTD');
      expect(p.bankCode, 'ICIC');
      expect(p.bankRef, 'ICICN52026100212345');
      expect(p.merchantKey, 'acme');
      expect(p.counterpartyKind, CounterpartyKind.merchant);
    });

    test('IMPS, card, ATM and ACH', () {
      final imps = parseDescription(
        'MMT/IMPS/627612345678/Rent Oct/PRIYA NAIR/SBIN0005678',
      );
      expect(imps.channel, Channel.imps);
      expect(imps.bankRef, '627612345678');

      final pos = parseDescription('POS 416021XXXXXX1234 AMAZON PAY INDIA');
      expect(pos.channel, Channel.card);
      expect(pos.cardLast4, '1234');
      expect(pos.counterpartyName, 'AMAZON PAY INDIA');
      expect(pos.merchantKey, 'amazon_pay');

      final atm = parseDescription('ATW-416021XXXXXX1234-S1ANBG12-BANGALORE');
      expect(atm.channel, Channel.atm);
      expect(atm.cardLast4, '1234');
      expect(atm.counterpartyKind, CounterpartyKind.self);

      final ach = parseDescription('ACH/HDFCLIFE/123456789');
      expect(ach.channel, Channel.netBanking);
      expect(ach.counterpartyName, 'HDFCLIFE');
    });

    test('never throws on odd input', () {
      for (final s in ['', '-', '////', '@@@', '123456789012', 'UPI']) {
        expect(() => parseDescription(s), returnsNormally, reason: s);
      }
    });
  });

  group('statement parsing', () {
    test('HDFC: finds the header under the preamble, stops at the summary, '
        'reports the broken row', () {
      final r = parseStatement(hdfc);
      expect(r.layout.preset?.id, 'hdfc_csv');
      expect(r.rows, hasLength(6));
      expect(r.errors, hasLength(1));
      expect(r.errors.single.problem, RowProblem.badDate);
      expect(r.errors.single.lineNumber, 13);
      expect(r.skippedBlankLines, 1);
      expect(r.balanceWarnings, isEmpty);

      final salary = r.rows[1];
      expect(salary.direction, Direction.credit);
      expect(salary.amount, Paise.rupees(85000));
      expect(salary.balance, Paise.rupees(109550));
      expect(salary.date, LocalDate(2026, 10, 2));
      expect(r.periodFrom, LocalDate(2026, 10, 1));
      expect(r.periodTo, LocalDate(2026, 10, 6));
    });

    test('ICICI, SBI, Axis and Kotak presets', () {
      final i = parseStatement(icici);
      expect(i.layout.preset?.id, 'icici_csv');
      expect(i.rows.map((r) => r.amount.value), [45000, 99900, 1800000]);
      expect(i.errors, isEmpty);
      expect(i.balanceWarnings, isEmpty);

      final s = parseStatement(sbi);
      expect(s.layout.preset?.id, 'sbi_csv');
      expect(s.rows.map((r) => r.direction), [
        Direction.debit,
        Direction.credit,
      ]);
      expect(s.rows.first.date, LocalDate(2026, 10, 1));

      final a = parseStatement(axis);
      expect(a.layout.preset?.id, 'axis_csv');
      expect(a.rows, hasLength(2));
      expect(a.balanceWarnings, isEmpty);

      final k = parseStatement(kotak);
      expect(k.layout.preset?.id, 'kotak_csv');
      expect(k.rows.map((r) => r.direction), [
        Direction.debit,
        Direction.credit,
      ]);
      expect(k.rows.last.amount, Paise.rupees(85000));
      expect(k.balanceWarnings, isEmpty);
    });

    test('a bank without a preset maps through generic headers', () {
      const csv =
          'Posting Date,Details,Debit,Credit,Running Balance\n'
          '2026-10-01,UPI-SWIGGY-swiggy@ybl-YESB0000001-412233445566-x,450,,1000\n';
      final r = parseStatement(csv);
      expect(r.layout.preset, isNull);
      expect(r.rows.single.amount, Paise.rupees(450));
    });

    test('balance check flags a row that does not add up, in either order', () {
      const oldestFirst =
          'Date,Narration,Withdrawal Amt.,Deposit Amt.,Closing Balance\n'
          '01/10/26,A,100,,900\n'
          '02/10/26,B,100,,800\n'
          '03/10/26,C,100,,750\n';
      final w = parseStatement(oldestFirst).balanceWarnings;
      expect(w.single.lineNumber, 4);
      expect(w.single.expected, Paise.rupees(700));

      const newestFirst =
          'Date,Narration,Withdrawal Amt.,Deposit Amt.,Closing Balance\n'
          '03/10/26,C,100,,700\n'
          '02/10/26,B,100,,800\n'
          '01/10/26,A,100,,900\n';
      expect(parseStatement(newestFirst).balanceWarnings, isEmpty);
    });

    test('rows with both or neither amount, or zero, are errors', () {
      const csv =
          'Date,Narration,Withdrawal Amt.,Deposit Amt.,Closing Balance\n'
          '01/10/26,BOTH,100,50,900\n'
          '02/10/26,NEITHER,,,900\n'
          '03/10/26,ZERO,0.00,0.00,900\n'
          '04/10/26,,10,,890\n'
          '05/10/26,BAD,12abc,,890\n';
      final r = parseStatement(csv);
      expect(r.rows, isEmpty);
      expect(r.errors.map((e) => e.problem), [
        RowProblem.bothAmounts,
        RowProblem.noAmount,
        RowProblem.zeroAmount,
        RowProblem.missingDescription,
        RowProblem.badAmount,
      ]);
    });

    test('a file with no recognisable header is a FormatException', () {
      expect(() => parseStatement('hello,world\n1,2\n'), throwsFormatException);
    });

    test('report excerpts mask long numbers', () {
      expect(
        redactExcerpt('ACC 50100012345678 card 416021XXXXXX1234'),
        'ACC ••••••••••5678 card ••6021XXXXXX1234',
      );
    });
  });

  group('dedupe hashes', () {
    test('same file gives the same hashes; identical rows stay distinct', () {
      const csv =
          'Date,Narration,Withdrawal Amt.,Deposit Amt.\n'
          '01/10/26,UPI-CHAI POINT-x@ybl,20,\n'
          '01/10/26,UPI-CHAI POINT-x@ybl,20,\n';
      final rows = parseStatement(csv).rows;
      final a = statementRowHashes('acc1', rows);
      final b = statementRowHashes('acc1', parseStatement(csv).rows);
      expect(a, b);
      expect(a.toSet(), hasLength(2));
      expect(statementRowHashes('acc2', rows), isNot(a));
    });

    test('whitespace and case changes in the description still dedupe', () {
      const one =
          'Date,Narration,Withdrawal Amt.,Deposit Amt.\n01/10/26,UPI-SWIGGY  x,20,\n';
      const two =
          'Date,Narration,Withdrawal Amt.,Deposit Amt.\n01/10/26,upi-swiggy x,20,\n';
      expect(
        statementRowHashes('a', parseStatement(one).rows),
        statementRowHashes('a', parseStatement(two).rows),
      );
    });
  });

  group('flows and transfers', () {
    test('default flow: spend, income, refund', () {
      expect(
        defaultFlow(Direction.debit, 'UPI-SWIGGY').$1,
        TransactionFlow.spend,
      );
      expect(
        defaultFlow(Direction.credit, 'NEFT SALARY').$1,
        TransactionFlow.income,
      );
      expect(defaultFlow(Direction.credit, 'UPI-ZOMATO REFUND'), (
        TransactionFlow.refund,
        FlowReason.refundKeyword,
      ));
    });

    TransferCandidate c(
      String id,
      String account,
      Direction dir,
      int rupees,
      int day, {
      String desc = 'x',
      AccountKind kind = AccountKind.bankAccount,
      String? vpa,
    }) => TransferCandidate(
      id: id,
      accountId: account,
      accountKind: kind,
      direction: dir,
      amount: Paise.rupees(rupees),
      date: LocalDate(2026, 10, day),
      description: desc,
      vpa: vpa,
    );

    test('pairs a debit with a same-amount credit in another account', () {
      final m = detectTransfers([
        c('d1', 'hdfc', Direction.debit, 5000, 1),
        c('c1', 'sbi', Direction.credit, 5000, 2),
        c('c2', 'sbi', Direction.credit, 5000, 9), // too far
        c('d2', 'hdfc', Direction.debit, 700, 1),
        c('c3', 'hdfc', Direction.credit, 700, 1), // same account
      ]);
      expect(m['d1']?.counterpartId, 'c1');
      expect(m['c1']?.counterpartId, 'd1');
      expect(m.keys, unorderedEquals(['d1', 'c1']));
    });

    test('each side pairs once, closest date first', () {
      final m = detectTransfers([
        c('d1', 'hdfc', Direction.debit, 5000, 1),
        c('d2', 'hdfc', Direction.debit, 5000, 3),
        c('c1', 'sbi', Direction.credit, 5000, 3),
      ]);
      expect(m['c1']?.counterpartId, 'd2');
      expect(m.containsKey('d1'), isFalse);
    });

    test('card bills and own VPAs are transfers', () {
      final m = detectTransfers(
        [
          c(
            'bill',
            'hdfc',
            Direction.debit,
            12000,
            5,
            desc: 'UPI-CRED CLUB-cred.club@axisb-UTIB0000114-412211110000-x',
          ),
          c(
            'card',
            'card',
            Direction.credit,
            12000,
            20,
            kind: AccountKind.creditCard,
            desc: 'PAYMENT RECEIVED THANK YOU',
          ),
          c('self', 'hdfc', Direction.debit, 300, 6, vpa: 'me@okhdfc'),
          c('food', 'hdfc', Direction.debit, 300, 6, desc: 'UPI-SWIGGY'),
        ],
        ownVpas: {'ME@okhdfc'},
      );
      expect(m['bill']?.reason, FlowReason.cardBill);
      expect(m['card']?.reason, FlowReason.cardBill);
      expect(m['self']?.reason, FlowReason.ownVpa);
      expect(m.containsKey('food'), isFalse);
    });
  });
}
