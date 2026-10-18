import 'package:drift/drift.dart';
import 'package:finance_core/finance_core.dart';

import '../categories/category_service.dart';
import '../db/database.dart';
import 'ledger_links.dart';

/// What an import did, for the import report screen. Every line of the file
/// after the header is counted in exactly one of [created], [matched],
/// [duplicates], [failed] or blank lines, so the numbers always add up.
final class ImportOutcome {
  const ImportOutcome({
    required this.batchId,
    required this.created,
    required this.duplicates,
    this.matched = 0,
    required this.errors,
    required this.balanceWarnings,
    required this.transfersMarked,
    this.needsCategory = 0,
  });

  final String batchId;
  final int created;
  final int duplicates;

  /// Rows joined to a transaction another source already created (a bank
  /// row and the payment app's row for the same UPI payment).
  final int matched;
  final List<RowError> errors;
  final List<BalanceWarning> balanceWarnings;
  final int transfersMarked;

  /// Transactions in the statement's period still without a confident
  /// category, for the review list.
  final int needsCategory;

  int get failed => errors.length;
}

/// A dry run, shown before anything is saved.
final class ImportPreview {
  const ImportPreview({required this.result, required this.alreadyImported});

  final StatementParseResult result;

  /// Rows already in the database from an earlier import.
  final int alreadyImported;

  int get newRows => result.rows.length - alreadyImported;
}

/// Imports a parsed statement into the ledger: one source record per row as
/// evidence, one transaction per new row, then transfer detection across
/// your accounts. Runs in a single database transaction, so an import either
/// lands completely or not at all.
class StatementImporter {
  StatementImporter(this._db, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final FinanceDatabase _db;
  final DateTime Function() _clock;

  /// Days on either side of the imported period searched for transfer pairs.
  static const transferSearchDays = 3;

  Future<ImportPreview> preview({
    required String accountId,
    required StatementParseResult result,
  }) async {
    final hashes = statementRowHashes(accountId, result.rows);
    final existing = await _existingHashes(hashes);
    return ImportPreview(result: result, alreadyImported: existing.length);
  }

  Future<ImportOutcome> import({
    required String accountId,
    required StatementParseResult result,
    ImportKind kind = ImportKind.statementCsv,
  }) {
    return _db.transaction(() async {
      final now = _clock().toUtc();
      final batchId = newId();
      await _db
          .into(_db.importBatches)
          .insert(
            ImportBatchesCompanion.insert(
              id: batchId,
              createdAt: now,
              updatedAt: now,
              kind: kind,
              status: ImportStatus.running,
              adapter: Value(result.layout.preset?.id ?? 'generic_csv'),
              accountId: Value(accountId),
              periodFrom: Value(result.periodFrom),
              periodTo: Value(result.periodTo),
            ),
          );

      final hashes = statementRowHashes(accountId, result.rows);
      final existing = await _existingHashes(hashes);
      var created = 0;
      var duplicates = 0;
      var matched = 0;
      for (var i = 0; i < result.rows.length; i++) {
        if (existing.contains(hashes[i])) {
          duplicates++;
          continue;
        }
        final linked = await _insertRow(
          accountId,
          batchId,
          hashes[i],
          result.rows[i],
          now,
        );
        linked ? matched++ : created++;
      }

      final from = result.periodFrom?.addDays(-transferSearchDays);
      final to = result.periodTo?.addDays(transferSearchDays);
      final transfers = from == null || to == null
          ? 0
          : await markTransfers(_db, from, to, now);
      final categories = CategoryService(_db, clock: _clock);
      var needsCategory = 0;
      if (from != null && to != null) {
        await categories.recategorize(from: from, to: to);
        needsCategory = await categories.countNeedingCategory(
          result.periodFrom!,
          result.periodTo!,
        );
      }

      await (_db.update(
        _db.importBatches,
      )..where((b) => b.id.equals(batchId))).write(
        ImportBatchesCompanion(
          status: const Value(ImportStatus.completed),
          parsedCount: Value(result.rows.length),
          failedCount: Value(result.errors.length),
          duplicateCount: Value(duplicates),
          matchedCount: Value(matched),
          createdCount: Value(created),
          errors: Value([
            for (final e in result.errors) e.toJson(),
            for (final w in result.balanceWarnings) w.toJson(),
          ]),
          updatedAt: Value(now),
        ),
      );

      return ImportOutcome(
        batchId: batchId,
        created: created,
        duplicates: duplicates,
        matched: matched,
        errors: result.errors,
        balanceWarnings: result.balanceWarnings,
        transfersMarked: transfers,
        needsCategory: needsCategory,
      );
    });
  }

  Future<Set<String>> _existingHashes(List<String> hashes) async {
    final found = <String>{};
    for (var i = 0; i < hashes.length; i += 500) {
      final chunk = hashes.sublist(i, (i + 500).clamp(0, hashes.length));
      final rows =
          await (_db.selectOnly(_db.sourceRecords)
                ..addColumns([_db.sourceRecords.dedupeHash])
                ..where(_db.sourceRecords.dedupeHash.isIn(chunk)))
              .get();
      found.addAll(rows.map((r) => r.read(_db.sourceRecords.dedupeHash)!));
    }
    return found;
  }

  /// Saves the row as evidence, then joins it to the transaction a payment
  /// app's statement already created for it, or creates a new one. Returns
  /// true when it was joined.
  Future<bool> _insertRow(
    String accountId,
    String batchId,
    String hash,
    StatementRow row,
    DateTime now,
  ) async {
    final parsed = parseDescription(row.description);
    final (flow, reason) = defaultFlow(row.direction, row.description);
    final recordId = newId();

    await _db
        .into(_db.sourceRecords)
        .insert(
          SourceRecordsCompanion.insert(
            id: recordId,
            createdAt: now,
            updatedAt: now,
            kind: SourceKind.statementRow,
            batchId: Value(batchId),
            dedupeHash: hash,
            parseStatus: ParseStatus.parsed,
            parsed: Value({
              'line': row.lineNumber,
              'date': row.date.toIso(),
              'valueDate': row.valueDate?.toIso(),
              'direction': row.direction.wire,
              'amountPaise': row.amount.value,
              'balancePaise': row.balance?.value,
              'reference': row.reference,
              'description': parsed.toJson(),
            }),
            rawText: Value(row.rawCells.join(' | ')),
            receivedAt: now,
          ),
        );

    final existing = parsed.upiRef == null
        ? null
        : await findByUpiRef(
            _db,
            upiRef: parsed.upiRef!,
            direction: row.direction,
            amount: row.amount,
            kind: SourceKind.statementRow,
          );
    if (existing != null) {
      // The app's payee name and exact time are kept. The bank statement
      // decides the account and adds its narration and reference.
      await (_db.update(
        _db.transactions,
      )..where((t) => t.id.equals(existing.id))).write(
        TransactionsCompanion(
          accountId: Value(accountId),
          descriptionRaw: Value(row.description),
          bankRef: Value(existing.bankRef ?? parsed.bankRef),
          vpa: Value(existing.vpa ?? parsed.vpa),
          reconciliationStatus: const Value(ReconciliationStatus.matched),
          updatedAt: Value(now),
          version: Value(existing.version + 1),
        ),
      );
      await _link(existing.id, recordId, now);
      return true;
    }

    final txId = newId();
    await _db
        .into(_db.transactions)
        .insert(
          TransactionsCompanion.insert(
            id: txId,
            createdAt: now,
            updatedAt: now,
            accountId: Value(accountId),
            direction: row.direction,
            amountPaise: row.amount.value,
            // Statements carry only a date, so the instant is the start of
            // that IST day. An SMS can supply the exact time later.
            occurredAt: row.date.startInstant,
            localDate: row.date,
            channel: parsed.channel,
            counterpartyName: Value(parsed.counterpartyName),
            merchantKey: Value(parsed.merchantKey),
            vpa: Value(parsed.vpa),
            counterpartyKind: Value(parsed.counterpartyKind),
            upiRef: Value(parsed.upiRef),
            bankRef: Value(parsed.bankRef),
            cardLast4: Value(parsed.cardLast4),
            descriptionRaw: Value(row.description),
            flow: flow,
            flowReason: Value(reason),
            reconciliationStatus: ReconciliationStatus.single,
          ),
        );
    await _link(txId, recordId, now);
    return false;
  }

  Future<void> _link(String txId, String recordId, DateTime now) => _db
      .into(_db.transactionSources)
      .insert(
        TransactionSourcesCompanion.insert(
          id: newId(),
          createdAt: now,
          updatedAt: now,
          transactionId: txId,
          sourceRecordId: recordId,
          kind: SourceKind.statementRow,
        ),
      );
}
