import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../models/enums.dart';
import '../money/paise.dart';
import '../time/local_date.dart';
import 'csv_reader.dart';
import 'statement_csv.dart';
import 'statement_date.dart';

/// Payment apps whose statements can be imported.
enum UpiApp {
  phonePe('phonepe_csv', 'PhonePe'),
  googlePay('gpay_pdf', 'Google Pay');

  const UpiApp(this.adapter, this.label);

  /// Stored as `import_batches.adapter`.
  final String adapter;
  final String label;
}

/// The bank account or card a UPI payment moved money through, as the app
/// names it: `Kotak Mahindra Bank 7890`, `XXXXXXXX4321`,
/// `Unity Small Finance Bank Ltd XX65 | RuPay credit card`.
final class PaymentInstrument {
  const PaymentInstrument({
    required this.kind,
    required this.digits,
    this.institution,
  });

  final AccountKind kind;

  /// The last 2 to 4 digits the app shows.
  final String digits;

  /// The bank's name, when the app gives it.
  final String? institution;

  /// Identifies the same instrument across rows of one statement.
  String get key => '${kind.wire}|${institution?.toLowerCase() ?? ''}|$digits';

  /// `Kotak Mahindra Bank ••7890`, or `Account ••4321` without a bank name.
  String get label {
    final name =
        institution ??
        (kind == AccountKind.creditCard ? 'Credit card' : 'Account');
    return '$name ••$digits';
  }

  @override
  bool operator ==(Object other) =>
      other is PaymentInstrument && other.key == key;

  @override
  int get hashCode => key.hashCode;
}

final _instrument = RegExp(
  r'^(.*?)\s*(?:[Xx*•]{2,12})?\s*(\d{2,4})\s*(?:\|\s*(.*))?$',
);

/// Reads the instrument text after "Paid by" or "Credited to".
PaymentInstrument? parseInstrument(String text) {
  final t = text.trim();
  final m = _instrument.firstMatch(t);
  if (m == null) return null;
  var institution = m[1]!.trim();
  final rest = (m[3] ?? '').toLowerCase();
  final isCard =
      rest.contains('credit card') ||
      RegExp(r'credit\s*card', caseSensitive: false).hasMatch(institution);
  institution = institution
      .replaceAll(RegExp(r'\s+'), ' ')
      .replaceAll(RegExp(r'[\s|]+$'), '');
  return PaymentInstrument(
    kind: isCard ? AccountKind.creditCard : AccountKind.bankAccount,
    digits: m[2]!,
    institution: institution.isEmpty ? null : institution,
  );
}

/// One payment from a UPI app's statement.
final class AppStatementRow {
  const AppStatementRow({
    required this.position,
    required this.date,
    required this.direction,
    required this.amount,
    required this.title,
    required this.counterpartyName,
    required this.rawText,
    this.occurredAt,
    this.upiRef,
    this.appRef,
    this.instrument,
    this.isSelfTransfer = false,
  });

  /// Line number for a CSV, entry number for a PDF. Used in the report.
  final int position;
  final LocalDate date;

  /// The exact time, when the app gives one.
  final DateTime? occurredAt;
  final Direction direction;
  final Paise amount;

  /// The app's own words: `Paid to SHARMA DAIRY`.
  final String title;

  /// Who was paid or who paid: `SHARMA DAIRY`.
  final String counterpartyName;

  /// The 12-digit UPI reference. The bank statement carries the same number,
  /// which is how the two are matched.
  final String? upiRef;

  /// The app's own transaction id, when it has one (PhonePe's `T…`).
  final String? appRef;
  final PaymentInstrument? instrument;

  /// The app marked it as money moved between your own accounts.
  final bool isSelfTransfer;

  /// The row as read, kept on the device as evidence.
  final String rawText;
}

final class AppStatementResult {
  const AppStatementResult({
    required this.app,
    required this.rows,
    required this.errors,
    this.sentTotal,
    this.receivedTotal,
  });

  final UpiApp app;
  final List<AppStatementRow> rows;
  final List<RowError> errors;

  /// Totals printed on the statement, used as a checksum when present.
  final Paise? sentTotal;
  final Paise? receivedTotal;

  LocalDate? get periodFrom => rows.isEmpty
      ? null
      : rows.map((r) => r.date).reduce((a, b) => a.compareTo(b) <= 0 ? a : b);
  LocalDate? get periodTo => rows.isEmpty
      ? null
      : rows.map((r) => r.date).reduce((a, b) => a.compareTo(b) >= 0 ? a : b);

  /// Every instrument in the statement with how many rows use it.
  Map<PaymentInstrument?, int> get instruments {
    final out = <PaymentInstrument?, int>{};
    for (final r in rows) {
      out[r.instrument] = (out[r.instrument] ?? 0) + 1;
    }
    return out;
  }

  /// Whether the rows add up to the totals printed on the statement.
  /// Google Pay leaves self transfers out of its totals, so they are left
  /// out here too. Null when the statement prints no totals.
  bool? get totalsMatch {
    if (sentTotal == null && receivedTotal == null) return null;
    var sent = 0;
    var received = 0;
    for (final r in rows) {
      if (r.isSelfTransfer) continue;
      if (r.direction == Direction.debit) {
        sent += r.amount.value;
      } else {
        received += r.amount.value;
      }
    }
    return (sentTotal == null || sentTotal!.value == sent) &&
        (receivedTotal == null || receivedTotal!.value == received);
  }
}

/// IST wall-clock time on [date] as a UTC instant. [time] is `05:39 pm` or
/// `09:46 AM`.
DateTime? _instantAt(LocalDate date, String time) {
  final m = RegExp(r'^(\d{1,2}):(\d{2})\s*([AaPp])\.?\s*[Mm]\.?$')
      .firstMatch(time.trim());
  if (m == null) return null;
  var hour = int.parse(m[1]!);
  final minute = int.parse(m[2]!);
  if (hour < 1 || hour > 12 || minute > 59) return null;
  final pm = m[3]!.toLowerCase() == 'p';
  if (hour == 12) hour = 0;
  if (pm) hour += 12;
  return date.startInstant.add(Duration(hours: hour, minutes: minute));
}

final _titleRe = RegExp(
  r'^(Paid\s*to|Sent\s*to|Received\s*from|Self\s*transfer\s*to|'
  r'Refund\s*from|Received\s*refund\s*from|Bill\s*paid\s*to|'
  r'Mobile\s*recharged|Recharged)\s*(.*)$',
  caseSensitive: false,
);

/// Splits `Paid to SHARMA DAIRY` into its direction and payee.
(Direction, String, bool)? _readTitle(String title) {
  final m = _titleRe.firstMatch(title.trim());
  if (m == null) return null;
  final verb = m[1]!.toLowerCase().replaceAll(RegExp(r'\s+'), '');
  final name = m[2]!.trim();
  final credit = verb.startsWith('received') || verb.startsWith('refund');
  return (
    credit ? Direction.credit : Direction.debit,
    name.isEmpty ? title.trim() : name,
    verb == 'selftransferto',
  );
}

/// Whether [table] is a PhonePe statement export.
bool looksLikePhonePeCsv(List<List<String>> table) =>
    _phonePeHeader(table) != null;

int? _phonePeHeader(List<List<String>> table) {
  for (var r = 0; r < table.length && r < 20; r++) {
    final h = table[r].map(normalizeHeader).toList();
    if (h.contains('transactiondetails') &&
        h.contains('utr') &&
        h.contains('transactiontype')) {
      return r;
    }
  }
  return null;
}

/// Reads PhonePe's statement CSV:
/// `Date,Time,Transaction Details,Transaction ID,UTR,Transaction Type,
/// Credit/debit instrument,Amount`. Lines after the table (the disclaimer)
/// are footer. Throws [FormatException] for any other file.
AppStatementResult parsePhonePeCsv(String text) {
  final table = parseCsv(text, delimiter: detectDelimiter(text));
  final headerRow = _phonePeHeader(table);
  if (headerRow == null) {
    throw const FormatException('Not a PhonePe statement');
  }
  final header = table[headerRow].map(normalizeHeader).toList();
  int col(List<String> names) =>
      names.map(header.indexOf).firstWhere((i) => i >= 0, orElse: () => -1);
  final cDate = col(['date']);
  final cTime = col(['time']);
  final cDetails = col(['transactiondetails']);
  final cId = col(['transactionid']);
  final cUtr = col(['utr']);
  final cType = col(['transactiontype']);
  final cInstrument = col(['creditdebitinstrument', 'instrument']);
  final cAmount = col(['amount']);

  final rows = <AppStatementRow>[];
  final errors = <RowError>[];
  for (var r = headerRow + 1; r < table.length; r++) {
    final cells = table[r];
    final nonEmpty = cells.where((c) => c.trim().isNotEmpty).toList();
    if (nonEmpty.isEmpty) {
      // The table ends at its first blank line once rows have started.
      if (rows.isNotEmpty || errors.isNotEmpty) break;
      continue;
    }
    String cell(int i) => i < 0 || i >= cells.length ? '' : cells[i].trim();
    final line = r + 1;
    RowError fail(RowProblem p) => RowError(
      lineNumber: line,
      problem: p,
      excerpt: redactExcerpt(nonEmpty.join(' | ')),
    );

    final date = parseStatementDate(cell(cDate));
    if (date == null) {
      errors.add(fail(RowProblem.badDate));
      continue;
    }
    final details = cell(cDetails);
    final title = _readTitle(details);
    final type = cell(cType).toUpperCase();
    final direction = type.startsWith('CR')
        ? Direction.credit
        : type.startsWith('DE')
        ? Direction.debit
        : title?.$1;
    if (direction == null) {
      errors.add(fail(RowProblem.unknownType));
      continue;
    }
    final amount = Paise.tryParse(cell(cAmount).replaceAll('₹', ''));
    if (amount == null) {
      errors.add(fail(RowProblem.badAmount));
      continue;
    }
    if (amount.value == 0) {
      errors.add(fail(RowProblem.zeroAmount));
      continue;
    }
    final instrumentText = cell(cInstrument).replaceFirst(
      RegExp(
        r'^(Paid\s*by|Credited\s*to|Debited\s*from)\s*',
        caseSensitive: false,
      ),
      '',
    );
    final utr = cell(cUtr);
    rows.add(
      AppStatementRow(
        position: line,
        date: date,
        occurredAt: _instantAt(date, cell(cTime)),
        direction: direction,
        amount: amount.abs(),
        title: details,
        counterpartyName: title?.$2 ?? details,
        upiRef: RegExp(r'^\d{12}$').hasMatch(utr) ? utr : null,
        appRef: cell(cId).isEmpty ? null : cell(cId),
        instrument: parseInstrument(instrumentText),
        isSelfTransfer: title?.$3 ?? false,
        rawText: cells.join(' | '),
      ),
    );
  }
  return AppStatementResult(app: UpiApp.phonePe, rows: rows, errors: errors);
}

/// Whether text pulled out of a PDF is a Google Pay statement.
bool looksLikeGooglePayText(String text) =>
    RegExp(r'Google\s*Pay', caseSensitive: false).hasMatch(text) ||
    RegExp(r'UPI\s*Transaction\s*ID', caseSensitive: false).hasMatch(text) &&
        RegExp(r'Transaction\s*statement', caseSensitive: false).hasMatch(text);

final _gpayDate = RegExp(r'^(\d{1,2})\s*([A-Za-z]{3}),\s*(\d{4})\b\s*');
final _gpayTime = RegExp(r'\b(\d{1,2}:\d{2}\s*[AaPp][Mm])\b');
final _gpayAmount = RegExp(r'₹\s*([\d,]+(?:\.\d{1,2})?)');
final _gpayRef = RegExp(r'UPI\s*Transaction\s*ID\s*:?\s*([A-Za-z0-9]+)');
final _gpayInstrument = RegExp(
  r'^(Paid\s*by|Paid\s*to|Credited\s*to|Debited\s*from)\s*(.+)$',
  caseSensitive: false,
);

/// Reads the text of a Google Pay statement PDF.
///
/// PDF text comes out in different orders depending on the extractor: the
/// amount can sit before or after the payee, and the summary totals at the
/// top can land inside the first entry. So each entry is everything from one
/// date line to the next, and inside it each piece is found by its shape:
/// the time, the `₹` amount, the `UPI Transaction ID`, the first "Paid to /
/// Received from" (the payee) and the "Paid by / Paid to `bank` 1234" after
/// it (the instrument).
AppStatementResult parseGooglePayText(String text) {
  var body = text.replaceAll('\r', '\n').replaceAll('\u00a0', ' ');

  // The summary ("Sent ₹1,04,584.66 Received ₹68,426") sits between "Sent"
  // and the "Amount" column header. Take its totals out so they are not
  // read as an entry's amount.
  Paise? sent;
  Paise? received;
  final summary = RegExp(
    r'\bSent\b([\s\S]*?)\bAmount\b',
    caseSensitive: false,
  ).firstMatch(body);
  if (summary != null) {
    final block = summary[1]!;
    final amounts = _gpayAmount.allMatches(block).toList();
    if (amounts.length == 2) {
      sent = Paise.tryParse(amounts[0][1]!);
      received = Paise.tryParse(amounts[1][1]!);
    }
    body = body.replaceRange(
      summary.start,
      summary.end,
      block.replaceAll(_gpayAmount, ' '),
    );
  }

  final lines = body
      .split('\n')
      .map((l) => l.trim().replaceAll(RegExp(r'\s+'), ' '))
      .where((l) => l.isNotEmpty)
      .toList();

  final rows = <AppStatementRow>[];
  final errors = <RowError>[];
  _GpayEntry? current;
  var entryNumber = 0;

  void finish() {
    final e = current;
    current = null;
    if (e == null) return;
    final excerpt = redactExcerpt(e.raw.join(' | '));
    RowError fail(RowProblem p) =>
        RowError(lineNumber: e.number, problem: p, excerpt: excerpt);
    final title = e.title == null ? null : _readTitle(e.title!);
    if (title == null) {
      errors.add(fail(RowProblem.unknownType));
      return;
    }
    if (e.amounts.length != 1) {
      errors.add(
        fail(e.amounts.isEmpty ? RowProblem.noAmount : RowProblem.badAmount),
      );
      return;
    }
    final amount = Paise.tryParse(e.amounts.single);
    if (amount == null || amount.value == 0) {
      errors.add(
        fail(amount == null ? RowProblem.badAmount : RowProblem.zeroAmount),
      );
      return;
    }
    rows.add(
      AppStatementRow(
        position: e.number,
        date: e.date,
        occurredAt: e.time == null ? null : _instantAt(e.date, e.time!),
        direction: title.$1,
        amount: amount,
        title: e.title!,
        counterpartyName: title.$2,
        upiRef: e.ref != null && RegExp(r'^\d{12}$').hasMatch(e.ref!)
            ? e.ref
            : null,
        appRef: e.ref,
        instrument: e.instrument == null
            ? null
            : parseInstrument(e.instrument!),
        isSelfTransfer: title.$3,
        rawText: e.raw.join(' | '),
      ),
    );
  }

  for (final original in lines) {
    var line = original;
    final dm = _gpayDate.firstMatch(line);
    final date = dm == null
        ? null
        : parseStatementDate('${dm[1]} ${dm[2]} ${dm[3]}');
    if (date != null) {
      finish();
      entryNumber++;
      current = _GpayEntry(entryNumber, date);
      line = line.substring(dm!.end);
    }
    final e = current;
    if (e == null) continue;
    // Only lines that carry part of the entry are kept as its evidence, so
    // page headers and footers (phone number, email) stay out.
    var used = date != null;

    final time = _gpayTime.firstMatch(line);
    if (time != null) {
      e.time ??= time[1];
      line = line.replaceRange(time.start, time.end, ' ').trim();
      used = true;
    }
    for (final a in _gpayAmount.allMatches(line)) {
      e.amounts.add(a[1]!);
      used = true;
    }
    line = line.replaceAll(_gpayAmount, ' ').trim();
    final ref = _gpayRef.firstMatch(line);
    if (ref != null) {
      e.ref ??= ref[1];
      line = line.replaceRange(ref.start, ref.end, ' ').trim();
      used = true;
    }
    if (line.isNotEmpty) {
      final inst = _gpayInstrument.firstMatch(line);
      if (e.title == null && _titleRe.hasMatch(line)) {
        e.title = line;
        used = true;
      } else if (e.title != null && inst != null && e.instrument == null) {
        e.instrument = inst[2];
        used = true;
      }
    }
    if (used) e.raw.add(original);
  }
  finish();

  return AppStatementResult(
    app: UpiApp.googlePay,
    rows: rows,
    errors: errors,
    sentTotal: sent,
    receivedTotal: received,
  );
}

final class _GpayEntry {
  _GpayEntry(this.number, this.date);

  final int number;
  final LocalDate date;
  final List<String> raw = [];
  final List<String> amounts = [];
  String? time;
  String? title;
  String? ref;
  String? instrument;
}

/// Dedupe hashes for app statement rows, one per row, in order. Built from
/// the app and its references rather than an account, so the same row
/// imported again is recognised whichever account it was put in.
List<String> appRowHashes(UpiApp app, List<AppStatementRow> rows) {
  final seen = <String, int>{};
  return [
    for (final row in rows)
      () {
        final key = [
          'app:v1',
          app.adapter,
          row.date.toIso(),
          row.direction.wire,
          row.amount.value,
          row.appRef ?? row.upiRef ?? row.title.toLowerCase(),
        ].join('|');
        final n = seen[key] = (seen[key] ?? 0) + 1;
        return sha256.convert(utf8.encode('$key|$n')).toString();
      }(),
  ];
}
