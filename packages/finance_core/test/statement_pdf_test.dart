import 'package:finance_core/finance_core.dart';
import 'package:test/test.dart';

// Made-up statement text in the shapes PDF extractors produce for common
// bank layouts. Names and numbers are fictional.

/// HDFC-style: separate withdrawal and deposit columns, a wrapped
/// narration, page furniture between pages.
const hdfcLike = '''
HDFC BANK Ltd. Page No .: 1 Statement of account
MR ASHA KUMAR Account No : 50100012345678
Date Narration Chq./Ref.No. Value Dt Withdrawal Amt. Deposit Amt. Closing Balance
Opening Balance 25,000.00
01/10/26 UPI-SWIGGY-SWIGGY@YBL-YESB0000001- 0000412233445566 01/10/26 450.00 24,550.00
412233445566-PAYMENT FROM PH
02/10/26 NEFT CR-ICIC0000104-ACME TECHNOLOGIES ICICN520261002 02/10/26 85,000.00 1,09,550.00
PVT LTD-SALARY OCT
Page 1 of 2
HDFC BANK LIMITED
Date Narration Chq./Ref.No. Value Dt Withdrawal Amt. Deposit Amt. Closing Balance
03/10/26 ATW-416021XXXXXX1234-S1ANBG12 000000000000 03/10/26 2,000.00 1,07,550.00
STATEMENT SUMMARY
''';

/// SBI-style: day-month-name dates, a value date, debit and credit columns
/// where the empty one prints as 0.00, newest row last.
const sbiLike = '''
State Bank of India
Account Statement
Txn Date Value Date Description Ref No./Cheque No. Debit Credit Balance
1 Oct 2026 1 Oct 2026 TO TRANSFER-UPI/DR/412233445566/RAHUL SHA/SBIN/9876543210@ybl/dinner 600.00 0.00 59,400.00
3 Oct 2026 3 Oct 2026 BY TRANSFER-IMPS/627612345678/HDFC/Savings 0.00 10,000.00 69,400.00
''';

/// Kotak-style app PDF: serial number first, date with time, newest first,
/// balances with Cr markers, no opening balance.
const kotakLike = '''
Kotak Mahindra Bank
# Date Description Ref Amount Balance
3 08-07-2026 09:46 UPI/ASHA RAVI KUMA/IPOS/633344445555/UPI 300.00 1,680.00 Cr
2 01-07-2026 12:14 UPI/RAVI KUMAR SHA/KKBK/622233334444/Payment from 1,000.00 1,980.00 Cr
1 01-07-2026 09:46 UPI/TEA STALL/FDRL/611122223333/Pay to Bhara 20.00 980.00 Cr
''';

void main() {
  test('HDFC-like: wrapped narrations, furniture skipped, opening balance', () {
    expect(looksLikeBankPdfText(hdfcLike), isTrue);
    final r = parseBankPdfText(hdfcLike);
    expect(r.layout.preset?.institution, 'HDFC Bank');
    expect(r.errors, isEmpty);
    expect(r.rows, hasLength(3));
    expect(r.balanceWarnings, isEmpty);
    final swiggy = r.rows[0];
    expect(swiggy.direction, Direction.debit);
    expect(swiggy.amount, Paise(45000));
    expect(swiggy.description, contains('PAYMENT FROM PH'));
    expect(parseDescription(swiggy.description).vpa, 'swiggy@ybl');
    expect(r.rows[1].direction, Direction.credit);
    expect(r.rows[1].amount, Paise(8500000));
    expect(r.rows[1].description, contains('SALARY OCT'));
    expect(r.rows[2].date, LocalDate(2026, 10, 3));
    expect(r.rows[2].description, isNot(contains('HDFC BANK LIMITED')));
  });

  test('SBI-like: value dates and 0.00 in the empty column', () {
    final r = parseBankPdfText(sbiLike);
    expect(r.layout.preset?.institution, 'State Bank of India');
    // No opening balance: the first row's direction is unknown, so it is
    // reported rather than guessed.
    expect(r.rows, hasLength(1));
    expect(r.rows.single.direction, Direction.credit);
    expect(r.rows.single.amount, Paise(1000000));
    expect(r.rows.single.valueDate, LocalDate(2026, 10, 3));
    expect(r.errors.single.problem, RowProblem.unknownDirection);
    expect(r.errors.single.lineNumber, 1);
  });

  test('Kotak-like: serial numbers, times, newest first', () {
    final r = parseBankPdfText(kotakLike);
    expect(r.layout.preset?.institution, 'Kotak Mahindra Bank');
    expect(r.rows.map((x) => x.direction), [
      Direction.debit,
      Direction.credit,
    ]);
    expect(r.rows.first.date, LocalDate(2026, 7, 8));
    expect(r.rows.first.balance, Paise(168000));
    expect(parseDescription(r.rows.first.description).upiRef, '633344445555');
    // The oldest row has nothing before it to compare with.
    expect(r.errors.single.lineNumber, 3);
  });

  test('text without dated rows is not a bank statement', () {
    expect(looksLikeBankPdfText('Hello\nTotal 100.00'), isFalse);
    expect(parseBankPdfText('nothing here').rows, isEmpty);
  });

  test('bank names', () {
    expect(detectBankName('xx IPPB yy'), 'India Post Payments Bank');
    expect(detectBankName('nothing'), isNull);
  });
}
