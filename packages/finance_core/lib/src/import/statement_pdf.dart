import '../models/enums.dart';
import '../money/paise.dart';
import '../time/local_date.dart';
import 'statement_csv.dart';
import 'statement_date.dart';

/// Banks named in a statement's text, longest names first so "Kotak
/// Mahindra Bank" wins over "Bank".
const _bankNames = <String, String>{
  'kotak mahindra': 'Kotak Mahindra Bank',
  'hdfc bank': 'HDFC Bank',
  'icici bank': 'ICICI Bank',
  'state bank of india': 'State Bank of India',
  'axis bank': 'Axis Bank',
  'idfc first': 'IDFC First Bank',
  'yes bank': 'Yes Bank',
  'indusind': 'IndusInd Bank',
  'punjab national bank': 'Punjab National Bank',
  'bank of baroda': 'Bank of Baroda',
  'canara bank': 'Canara Bank',
  'union bank of india': 'Union Bank of India',
  'india post payments bank': 'India Post Payments Bank',
  'ippb': 'India Post Payments Bank',
  'au small finance': 'AU Small Finance Bank',
  'unity small finance': 'Unity Small Finance Bank',
  'federal bank': 'Federal Bank',
  'airtel payments bank': 'Airtel Payments Bank',
  'paytm payments bank': 'Paytm Payments Bank',
  'bank of india': 'Bank of India',
  'indian bank': 'Indian Bank',
  'central bank of india': 'Central Bank of India',
  'idbi bank': 'IDBI Bank',
};

/// The first bank named in [text], or null.
String? detectBankName(String text) {
  final lower = text.toLowerCase();
  String? best;
  var bestAt = -1;
  for (final e in _bankNames.entries) {
    final at = lower.indexOf(e.key);
    if (at >= 0 && (bestAt < 0 || at < bestAt)) {
      best = e.value;
      bestAt = at;
    }
  }
  return best;
}

/// A date at the start of a line, optionally after a serial number:
/// `01/07/2026`, `01-07-26`, `01-Jul-2026`, `01 Jul 2026`, `1 July, 2026`.
final _leadingDate = RegExp(
  r'^(?:\d{1,4}\s+)??'
  r'(\d{1,2}[\/\-.](?:\d{1,2}|[A-Za-z]{3,9})[\/\-.](?:\d{4}|\d{2})'
  r'|\d{1,2}\s+[A-Za-z]{3,9},?\s+\d{2,4})'
  r'(?:\s+\d{1,2}:\d{2}(?::\d{2})?(?:\s*[AaPp][Mm])?)?'
  r'(?=\s|$)',
);

/// An amount as statements print it: `1,23,456.78`, optionally with
/// `Cr`/`Dr` or a minus sign. Two decimals are required so reference
/// numbers and years are never read as money.
final _money = RegExp(
  r'(?<![\w.\/-])(-?)(?:₹|Rs\.?|INR)?\s?(\d{1,3}(?:,\d{2,3})*|\d+)\.(\d{2})'
  r'(?:\s?(Cr|CR|cr|Dr|DR|dr)\b\.?)?(?![\d,])',
);

/// Lines that are page furniture, not part of a transaction.
final _furniture = RegExp(
  r'(page\s*\d+\s*(of|/)\s*\d+|statement of account|account statement|'
  r'opening balance|closing balance|^total\b|grand total|computer generated|'
  r'generated on|customer care|toll free|registered office|'
  r'^(s\.?\s*no\.?\s*)?(txn\s*|tran\s*|transaction\s*)?date\b.*'
  r'\b(narration|description|particulars|details|remarks)|'
  r'brought forward|carried forward|end of statement|^important|'
  r'disclaimer|www\.|https?://)',
  caseSensitive: false,
);

typedef _Parsed = ({
  _PdfEntry e,
  Paise amount,
  Paise balance,
  Direction? hint,
  String narration,
});

/// A whole-token date inside a line (a value date column).
final _inlineDate = RegExp(
  r'(?<=^|\s)\d{1,2}[\/\-.](?:\d{1,2}|[A-Za-z]{3})[\/\-.](?:\d{4}|\d{2})(?=\s|$)',
);

final _openingBalance = RegExp(
  r'opening\s*balance[^\d-]{0,40}(-?[\d,]+\.\d{2})\s*(Cr|Dr)?',
  caseSensitive: false,
);

class _PdfEntry {
  _PdfEntry(this.number, this.date, String firstLine) {
    lines.add(firstLine);
  }

  final int number;
  final LocalDate date;
  LocalDate? valueDate;
  final List<String> lines = [];
}

/// Reads a bank statement PDF's text, whatever the bank.
///
/// Each transaction starts at a line that begins with a date. Lines after
/// it, until the next date, belong to it (wrapped narrations), except page
/// headers and footers. In each transaction the last amount is the running
/// balance and the one before it the transaction amount. Whether it was
/// money in or out comes from how the balance moved, so it doesn't matter
/// whether the bank prints separate debit and credit columns. Rows the
/// balance can't explain are reported, not guessed.
StatementParseResult parseBankPdfText(String text) {
  final bank = detectBankName(text);
  final lines = text
      .replaceAll('\r', '\n')
      .replaceAll(' ', ' ')
      .split('\n')
      .map((l) => l.trim().replaceAll(RegExp(r'\s+'), ' '))
      .where((l) => l.isNotEmpty)
      .toList();

  final entries = <_PdfEntry>[];
  _PdfEntry? current;
  for (final line in lines) {
    final m = _leadingDate.firstMatch(line);
    final date = m == null ? null : parseStatementDate(m[1]!);
    if (date != null) {
      var rest = line.substring(m!.end).trim();
      // A second date right after is the value date.
      final value = _leadingDate.firstMatch(rest);
      LocalDate? valueDate;
      if (value != null && value.start == 0) {
        valueDate = parseStatementDate(value[1]!);
        if (valueDate != null) rest = rest.substring(value.end).trim();
      }
      current = _PdfEntry(entries.length + 1, date, rest)
        ..valueDate = valueDate;
      entries.add(current);
      continue;
    }
    if (current == null) continue;
    if (_furniture.hasMatch(line)) {
      // A footer ends the entry; its wrapped lines are above it.
      current = null;
      continue;
    }
    if (current.lines.length < 6) current.lines.add(line);
  }

  final errors = <RowError>[];
  final parsed = <_Parsed>[];
  for (final e in entries) {
    final joined = e.lines.join(' ');
    final amounts = _money.allMatches(joined).toList();
    final excerpt = redactExcerpt(joined);
    if (amounts.length < 2) {
      errors.add(
        RowError(
          lineNumber: e.number,
          problem: amounts.isEmpty ? RowProblem.noAmount : RowProblem.badAmount,
          excerpt: excerpt,
        ),
      );
      continue;
    }
    Paise money(RegExpMatch m) {
      final v = int.parse(m[2]!.replaceAll(',', '')) * 100 + int.parse(m[3]!);
      final negative = m[1] == '-' || (m[4]?.toLowerCase() == 'dr');
      return Paise(negative ? -v : v);
    }

    final balanceMatch = amounts.last;
    // With separate debit and credit columns the empty one may print as
    // 0.00, so the amount is the last non-zero one before the balance.
    final amountMatch = amounts
        .sublist(0, amounts.length - 1)
        .lastWhere(
          (m) =>
              m[2]!.replaceAll(RegExp('[,0]'), '').isNotEmpty || m[3] != '00',
          orElse: () => amounts[amounts.length - 2],
        );
    final marker = amountMatch[4]?.toLowerCase();
    final balance = money(balanceMatch);
    final amount = Paise(money(amountMatch).value.abs());
    // The narration is the text around the amounts: before them on the
    // first line, and the wrapped lines after. Value dates in the middle
    // are dropped.
    final narration =
        [
              joined.substring(0, amounts.first.start),
              joined.substring(amounts.last.end),
            ]
            .join(' ')
            .replaceAll(_inlineDate, ' ')
            .replaceAll(
              RegExp(r'\s*\b(Cr|Dr)\b\.?\s*$', caseSensitive: false),
              '',
            )
            .replaceAll(RegExp(r'\s+'), ' ')
            .trim();
    if (amount.value == 0) {
      errors.add(
        RowError(
          lineNumber: e.number,
          problem: RowProblem.zeroAmount,
          excerpt: excerpt,
        ),
      );
      continue;
    }
    parsed.add((
      e: e,
      amount: amount,
      balance: balance,
      hint: marker == 'cr'
          ? Direction.credit
          : marker == 'dr'
          ? Direction.debit
          : null,
      narration: narration.isEmpty ? 'Statement entry' : narration,
    ));
  }

  // Directions from the balance chain, in the file's order and reversed;
  // the order that explains more rows wins.
  final opening = _openingBalance.firstMatch(text);
  Paise? openingBalance;
  if (opening != null) {
    final v = Paise.tryParse(opening[1]!);
    if (v != null) {
      openingBalance = opening[2]?.toLowerCase() == 'dr'
          ? Paise(-v.value.abs())
          : v;
    }
  }
  List<Direction?> chain(List<int> order, Paise? start) {
    final out = List<Direction?>.filled(parsed.length, null);
    var prev = start;
    for (final i in order) {
      final p = parsed[i];
      if (prev != null) {
        final diff = p.balance.value - prev.value;
        if (diff == p.amount.value) out[i] = Direction.credit;
        if (diff == -p.amount.value) out[i] = Direction.debit;
      }
      prev = p.balance;
    }
    return out;
  }

  final forwardOrder = [for (var i = 0; i < parsed.length; i++) i];
  final forward = chain(forwardOrder, openingBalance);
  final backward = chain(forwardOrder.reversed.toList(), null);
  int count(List<Direction?> d) => d.where((x) => x != null).length;
  final directions = count(backward) > count(forward) ? backward : forward;

  final rows = <StatementRow>[];
  for (var i = 0; i < parsed.length; i++) {
    final p = parsed[i];
    final direction = directions[i] ?? p.hint ?? _firstRowGuess(i, parsed);
    if (direction == null) {
      errors.add(
        RowError(
          lineNumber: p.e.number,
          problem: RowProblem.unknownDirection,
          excerpt: redactExcerpt(p.e.lines.join(' ')),
        ),
      );
      continue;
    }
    rows.add(
      StatementRow(
        lineNumber: p.e.number,
        date: p.e.date,
        valueDate: p.e.valueDate,
        description: p.narration,
        direction: direction,
        amount: p.amount,
        balance: p.balance,
        rawCells: p.e.lines,
      ),
    );
  }
  errors.sort((a, b) => a.lineNumber.compareTo(b.lineNumber));

  return StatementParseResult(
    layout: DetectedLayout(
      headerRow: 0,
      headers: const [],
      columns: const ColumnMap({}),
      preset: StatementPreset(
        id: 'pdf_text',
        institution: bank ?? 'Bank statement',
        headers: const {},
      ),
    ),
    rows: rows,
    errors: errors,
    balanceWarnings: checkBalances(rows),
    skippedBlankLines: 0,
  );
}

/// With no opening balance, the first row's direction can still follow
/// from the next row: if the next row's balance moved by its own amount,
/// the first row's balance is trustworthy but its direction is not. Only
/// a row whose amount equals its balance (an account starting from zero)
/// is clearly a credit.
Direction? _firstRowGuess(int i, List<_Parsed> parsed) {
  if (i != 0) return null;
  final p = parsed[0];
  return p.amount == p.balance ? Direction.credit : null;
}

/// Whether text pulled from a PDF looks like a bank account statement with
/// running balances.
bool looksLikeBankPdfText(String text) {
  final lower = text.toLowerCase();
  final hasBalance = lower.contains('balance');
  var dated = 0;
  for (final line in text.split(RegExp(r'[\r\n]+'))) {
    if (_leadingDate.hasMatch(line.trim()) &&
        _money.allMatches(line).length >= 2) {
      dated++;
      if (dated >= 2) break;
    }
  }
  return hasBalance && dated >= 1;
}
