import '../models/enums.dart';
import '../money/paise.dart';
import '../time/local_date.dart';
import 'csv_reader.dart';
import 'statement_date.dart';

/// The fields a statement column can hold.
enum StatementField {
  date,
  valueDate,
  description,
  reference,
  debit,
  credit,

  /// One amount column, with the direction in [drCr] or in its sign.
  amount,

  /// "Dr"/"Cr" (or "D"/"C", "Debit"/"Credit") for [amount].
  drCr,
  balance,
}

/// Which column holds which field. Built from a bank preset or from the
/// column mapper on screen.
final class ColumnMap {
  const ColumnMap(this.columns);

  /// Column index for each field present in the file.
  final Map<StatementField, int> columns;

  int? operator [](StatementField f) => columns[f];

  /// A map is usable with a date, a description and either debit/credit
  /// columns or an amount column.
  bool get isComplete =>
      columns.containsKey(StatementField.date) &&
      columns.containsKey(StatementField.description) &&
      (columns.containsKey(StatementField.amount) ||
          columns.containsKey(StatementField.debit) ||
          columns.containsKey(StatementField.credit));

  Map<String, int> toJson() => {
    for (final e in columns.entries) e.key.name: e.value,
  };
}

/// A bank's CSV layout: header names for each field and lines that mark the
/// end of the transactions.
final class StatementPreset {
  const StatementPreset({
    required this.id,
    required this.institution,
    required this.headers,
    this.footerMarkers = const [],
  });

  /// Stored as `import_batches.adapter`, e.g. `hdfc_csv`.
  final String id;
  final String institution;

  /// Accepted header spellings per field, compared after [normalizeHeader].
  final Map<StatementField, List<String>> headers;

  /// A row whose first non-empty cell starts with one of these ends the
  /// transaction table (summary blocks, disclaimers).
  final List<String> footerMarkers;
}

/// Lowercase letters and digits only: `Withdrawal Amt.` → `withdrawalamt`.
String normalizeHeader(String h) =>
    h.toLowerCase().replaceAll(RegExp('[^a-z0-9]'), '');

const _commonFooters = [
  'statement summary', 'opening balance', 'closing balance', //
  'this is a computer generated', 'this is computer generated',
  '***', 'end of statement', 'generated on', 'total', 'grand total',
  'legends', 'unless the constituent', 'page ',
];

/// Presets for the banks in the plan. Header names come from each bank's
/// net banking CSV export. Real samples may show more spellings; the column
/// mapper covers anything these miss.
const statementPresets = <StatementPreset>[
  StatementPreset(
    id: 'hdfc_csv',
    institution: 'HDFC Bank',
    headers: {
      StatementField.date: ['date', 'transactiondate', 'txndate'],
      StatementField.description: ['narration', 'description'],
      StatementField.reference: ['chqrefno', 'refno', 'chequerefno'],
      StatementField.valueDate: ['valuedt', 'valuedate'],
      StatementField.debit: [
        'withdrawalamt',
        'withdrawalamount',
        'debitamount',
      ],
      StatementField.credit: ['depositamt', 'depositamount', 'creditamount'],
      StatementField.balance: ['closingbalance', 'balance'],
    },
    footerMarkers: _commonFooters,
  ),
  StatementPreset(
    id: 'icici_csv',
    institution: 'ICICI Bank',
    headers: {
      StatementField.date: ['transactiondate', 'txndate', 'date'],
      StatementField.valueDate: ['valuedate'],
      StatementField.description: [
        'transactionremarks',
        'remarks',
        'particulars',
      ],
      StatementField.reference: ['chequenumber', 'chequeno', 'refno'],
      StatementField.debit: [
        'withdrawalamountinr',
        'withdrawalamount',
        'withdrawals',
      ],
      StatementField.credit: ['depositamountinr', 'depositamount', 'deposits'],
      StatementField.balance: ['balanceinr', 'balance'],
    },
    footerMarkers: _commonFooters,
  ),
  StatementPreset(
    id: 'sbi_csv',
    institution: 'State Bank of India',
    headers: {
      StatementField.date: ['txndate', 'transactiondate', 'date'],
      StatementField.valueDate: ['valuedate'],
      StatementField.description: ['description', 'narration', 'particulars'],
      StatementField.reference: ['refnochequeno', 'refno', 'chequeno'],
      StatementField.debit: ['debit', 'withdrawal'],
      StatementField.credit: ['credit', 'deposit'],
      StatementField.balance: ['balance'],
    },
    footerMarkers: _commonFooters,
  ),
  StatementPreset(
    id: 'axis_csv',
    institution: 'Axis Bank',
    headers: {
      StatementField.date: ['trandate', 'transactiondate', 'date'],
      StatementField.reference: ['chqno', 'chequeno'],
      StatementField.description: ['particulars', 'description', 'narration'],
      StatementField.debit: ['dr', 'debit', 'withdrawal'],
      StatementField.credit: ['cr', 'credit', 'deposit'],
      StatementField.balance: ['bal', 'balance'],
    },
    footerMarkers: _commonFooters,
  ),
  StatementPreset(
    id: 'kotak_csv',
    institution: 'Kotak Mahindra Bank',
    headers: {
      StatementField.date: ['transactiondate', 'date'],
      StatementField.valueDate: ['valuedate'],
      StatementField.description: ['description', 'narration'],
      StatementField.reference: ['chqrefno', 'refno'],
      StatementField.amount: ['amount'],
      StatementField.drCr: ['drcr'],
      StatementField.debit: ['withdrawalamt', 'debit'],
      StatementField.credit: ['depositamt', 'credit'],
      StatementField.balance: ['balance'],
    },
    footerMarkers: _commonFooters,
  ),
];

/// Fallback header names for any bank, used when no preset matches.
const _genericHeaders = <StatementField, List<String>>{
  StatementField.date: [
    'date', 'txndate', 'transactiondate', 'trandate', 'postingdate', //
    'bookingdate', 'transdate',
  ],
  StatementField.valueDate: ['valuedate', 'valuedt'],
  StatementField.description: [
    'description', 'narration', 'particulars', 'remarks', //
    'transactionremarks', 'details', 'transactiondetails',
  ],
  StatementField.reference: ['refno', 'chqrefno', 'chequeno', 'reference'],
  StatementField.debit: [
    'debit',
    'withdrawal',
    'withdrawalamt',
    'dr',
    'debitamount',
    'withdrawals',
  ],
  StatementField.credit: [
    'credit',
    'deposit',
    'depositamt',
    'cr',
    'creditamount',
    'deposits',
  ],
  StatementField.amount: ['amount', 'transactionamount', 'amountinr'],
  StatementField.drCr: ['drcr', 'type', 'crdr', 'debitcredit'],
  StatementField.balance: [
    'balance',
    'closingbalance',
    'runningbalance',
    'availablebalance',
  ],
};

/// The header row of a statement and how its columns map to fields.
final class DetectedLayout {
  const DetectedLayout({
    required this.headerRow,
    required this.headers,
    required this.columns,
    this.preset,
  });

  /// Zero-based index of the header line in the parsed rows.
  final int headerRow;
  final List<String> headers;
  final ColumnMap columns;

  /// The matched bank preset, or null for the generic mapping.
  final StatementPreset? preset;
}

ColumnMap _mapHeaders(
  List<String> row,
  Map<StatementField, List<String>> names,
) {
  final normalized = row.map(normalizeHeader).toList();
  final map = <StatementField, int>{};
  final used = <int>{};
  // Exact matches first, in the order of each field's alias list.
  for (final entry in names.entries) {
    for (final alias in entry.value) {
      final i = normalized.indexOf(alias);
      if (i >= 0 && !used.contains(i)) {
        map[entry.key] = i;
        used.add(i);
        break;
      }
    }
  }
  return ColumnMap(map);
}

/// Finds the header row in the first lines of the file and maps its columns,
/// preferring a bank preset. Bank exports often start with account details
/// above the table, so up to [scanRows] lines are checked.
DetectedLayout? detectLayout(List<List<String>> rows, {int scanRows = 60}) {
  for (var r = 0; r < rows.length && r < scanRows; r++) {
    final row = rows[r];
    if (row.where((c) => c.trim().isNotEmpty).length < 3) continue;
    for (final preset in statementPresets) {
      final map = _mapHeaders(row, preset.headers);
      if (map.isComplete && map[StatementField.balance] != null) {
        return DetectedLayout(
          headerRow: r,
          headers: row,
          columns: map,
          preset: preset,
        );
      }
    }
    final generic = _mapHeaders(row, _genericHeaders);
    if (generic.isComplete) {
      return DetectedLayout(headerRow: r, headers: row, columns: generic);
    }
  }
  return null;
}

/// One transaction row from a statement.
final class StatementRow {
  const StatementRow({
    required this.lineNumber,
    required this.date,
    required this.description,
    required this.direction,
    required this.amount,
    required this.rawCells,
    this.valueDate,
    this.reference,
    this.balance,
  });

  /// One-based line number in the file, for the import report.
  final int lineNumber;
  final LocalDate date;
  final LocalDate? valueDate;
  final String description;
  final String? reference;
  final Direction direction;

  /// Always positive.
  final Paise amount;
  final Paise? balance;
  final List<String> rawCells;
}

/// Why a row was not imported.
enum RowProblem {
  badDate('The date could not be read'),
  noAmount('There is no debit or credit amount'),
  badAmount('The amount could not be read'),
  bothAmounts('The row has both a debit and a credit'),
  zeroAmount('The amount is zero'),
  missingDescription('The description is empty'),
  tooFewColumns('The row has fewer columns than the header'),
  unknownType('The row is not a payment, a receipt or a transfer');

  const RowProblem(this.message);
  final String message;
}

final class RowError {
  const RowError({
    required this.lineNumber,
    required this.problem,
    required this.excerpt,
  });

  final int lineNumber;
  final RowProblem problem;

  /// The row with long digit runs masked, safe to show and store.
  final String excerpt;

  Map<String, Object?> toJson() => {
    'line': lineNumber,
    'reason': problem.name,
    'message': problem.message,
    'excerpt': excerpt,
  };
}

/// A row whose balance doesn't follow from the previous balance and this
/// row's amount. It is still imported, but flagged in the report.
final class BalanceWarning {
  const BalanceWarning({
    required this.lineNumber,
    required this.expected,
    required this.actual,
  });

  final int lineNumber;
  final Paise expected;
  final Paise actual;

  Map<String, Object?> toJson() => {
    'line': lineNumber,
    'reason': 'balance_mismatch',
    'expectedPaise': expected.value,
    'actualPaise': actual.value,
  };
}

final class StatementParseResult {
  const StatementParseResult({
    required this.layout,
    required this.rows,
    required this.errors,
    required this.balanceWarnings,
    required this.skippedBlankLines,
  });

  final DetectedLayout layout;
  final List<StatementRow> rows;
  final List<RowError> errors;
  final List<BalanceWarning> balanceWarnings;

  /// Empty lines inside the table. Counted so the report adds up.
  final int skippedBlankLines;

  LocalDate? get periodFrom => rows.isEmpty
      ? null
      : rows.map((r) => r.date).reduce((a, b) => a.compareTo(b) <= 0 ? a : b);
  LocalDate? get periodTo => rows.isEmpty
      ? null
      : rows.map((r) => r.date).reduce((a, b) => a.compareTo(b) >= 0 ? a : b);
}

/// Masks every run of 4 or more digits except its last 4, and trims the
/// excerpt, so account and card numbers never reach the report.
String redactExcerpt(String text, {int maxLength = 80}) {
  final masked = text.replaceAllMapped(RegExp(r'\d{5,}'), (m) {
    final s = m.group(0)!;
    return '•' * (s.length - 4) + s.substring(s.length - 4);
  });
  return masked.length <= maxLength
      ? masked
      : '${masked.substring(0, maxLength - 1)}…';
}

Paise? _amount(String cell) {
  var s = cell.trim();
  if (s.isEmpty || s == '-' || s == '--') return null;
  s = s.replaceAll(RegExp(r'\s*(Dr|Cr|DR|CR)\.?$'), '');
  return Paise.tryParse(s);
}

bool _isZeroOrEmpty(String cell) {
  final p = _amount(cell);
  return cell.trim().isEmpty || p == const Paise(0);
}

Direction? _drCr(String cell) {
  final s = cell.trim().toLowerCase();
  if (s.startsWith('d') || s == 'withdrawal') return Direction.debit;
  if (s.startsWith('c') || s == 'deposit') return Direction.credit;
  return null;
}

/// Reads statement text with a detected or user-built [layout]. Every line
/// after the header ends up in exactly one bucket: a row, an error, a blank
/// line, or the footer, so nothing is dropped silently.
StatementParseResult parseStatement(
  String text, {
  DetectedLayout? layout,
  String? delimiter,
}) {
  final d = delimiter ?? detectDelimiter(text);
  final table = parseCsv(text, delimiter: d);
  final found = layout ?? detectLayout(table);
  if (found == null) {
    throw const FormatException(
      'No header row with a date, description and amount',
    );
  }
  final cols = found.columns;
  final footers = found.preset?.footerMarkers ?? _commonFooters;
  final rows = <StatementRow>[];
  final errors = <RowError>[];
  var blanks = 0;
  final maxIndex = cols.columns.values.reduce((a, b) => a > b ? a : b);

  for (var r = found.headerRow + 1; r < table.length; r++) {
    final cells = table[r];
    final line = r + 1;
    final nonEmpty = cells.where((c) => c.trim().isNotEmpty).toList();
    if (nonEmpty.isEmpty) {
      blanks++;
      continue;
    }
    final first = nonEmpty.first.trim().toLowerCase();
    if (footers.any(first.startsWith)) break;
    // A repeated header (multi-page exports) is skipped, not an error.
    if (normalizeHeader(cells.join()) ==
        normalizeHeader(found.headers.join())) {
      blanks++;
      continue;
    }
    final excerpt = redactExcerpt(nonEmpty.join(' | '));
    RowError fail(RowProblem p) =>
        RowError(lineNumber: line, problem: p, excerpt: excerpt);

    if (cells.length <= maxIndex) {
      // Short rows are fine if only optional trailing columns are missing.
      final needed = [
        cols[StatementField.date]!,
        cols[StatementField.description]!,
      ];
      if (needed.any((i) => i >= cells.length)) {
        errors.add(fail(RowProblem.tooFewColumns));
        continue;
      }
    }
    String cell(StatementField f) {
      final i = cols[f];
      return i == null || i >= cells.length ? '' : cells[i].trim();
    }

    final date = parseStatementDate(cell(StatementField.date));
    if (date == null) {
      errors.add(fail(RowProblem.badDate));
      continue;
    }
    final description = cell(StatementField.description);
    if (description.isEmpty) {
      errors.add(fail(RowProblem.missingDescription));
      continue;
    }

    Direction? direction;
    Paise? amount;
    final debitCell = cell(StatementField.debit);
    final creditCell = cell(StatementField.credit);
    final amountCell = cell(StatementField.amount);
    if (cols[StatementField.amount] != null && amountCell.isNotEmpty) {
      final a = _amount(amountCell);
      if (a == null) {
        errors.add(fail(RowProblem.badAmount));
        continue;
      }
      final indicator = cols[StatementField.drCr] != null
          ? _drCr(cell(StatementField.drCr))
          : RegExp(r'cr\.?$', caseSensitive: false).hasMatch(amountCell)
          ? Direction.credit
          : RegExp(r'dr\.?$', caseSensitive: false).hasMatch(amountCell)
          ? Direction.debit
          : null;
      direction =
          indicator ?? (a.value < 0 ? Direction.debit : Direction.credit);
      amount = a.abs();
    } else {
      final hasDebit = !_isZeroOrEmpty(debitCell);
      final hasCredit = !_isZeroOrEmpty(creditCell);
      if (hasDebit && hasCredit) {
        errors.add(fail(RowProblem.bothAmounts));
        continue;
      }
      if (!hasDebit && !hasCredit) {
        final anyZero =
            _amount(debitCell) == const Paise(0) ||
            _amount(creditCell) == const Paise(0);
        errors.add(fail(anyZero ? RowProblem.zeroAmount : RowProblem.noAmount));
        continue;
      }
      final a = _amount(hasDebit ? debitCell : creditCell);
      if (a == null) {
        errors.add(fail(RowProblem.badAmount));
        continue;
      }
      direction = hasDebit ? Direction.debit : Direction.credit;
      amount = a.abs();
    }
    if (amount.value == 0) {
      errors.add(fail(RowProblem.zeroAmount));
      continue;
    }

    final balanceCell = cell(StatementField.balance);
    Paise? balance;
    if (balanceCell.isNotEmpty) {
      balance = _amount(balanceCell);
      if (balance != null &&
          RegExp(r'dr\.?$', caseSensitive: false).hasMatch(balanceCell)) {
        balance = Paise(-balance.value.abs());
      }
    }

    rows.add(
      StatementRow(
        lineNumber: line,
        date: date,
        valueDate: parseStatementDate(cell(StatementField.valueDate)),
        description: description,
        reference: cell(StatementField.reference).isEmpty
            ? null
            : cell(StatementField.reference),
        direction: direction,
        amount: amount,
        balance: balance,
        rawCells: cells,
      ),
    );
  }

  return StatementParseResult(
    layout: found,
    rows: rows,
    errors: errors,
    balanceWarnings: checkBalances(rows),
    skippedBlankLines: blanks,
  );
}

/// Uses the running balance as a checksum. Statements list rows oldest
/// first or newest first; the order that explains more rows is used.
List<BalanceWarning> checkBalances(List<StatementRow> rows) {
  List<BalanceWarning> check(List<StatementRow> ordered) {
    final out = <BalanceWarning>[];
    Paise? prev;
    for (final row in ordered) {
      final bal = row.balance;
      if (bal == null) {
        prev = null;
        continue;
      }
      if (prev != null) {
        final signed = row.direction == Direction.debit
            ? -row.amount.value
            : row.amount.value;
        final expected = Paise(prev.value + signed);
        if (expected != bal) {
          out.add(
            BalanceWarning(
              lineNumber: row.lineNumber,
              expected: expected,
              actual: bal,
            ),
          );
        }
      }
      prev = bal;
    }
    return out;
  }

  final forward = check(rows);
  if (forward.isEmpty) return forward;
  final backward = check(rows.reversed.toList());
  return backward.length < forward.length ? backward : forward;
}
