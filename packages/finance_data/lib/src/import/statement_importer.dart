import 'package:drift/drift.dart';
import 'package:finance_core/finance_core.dart';

import '../db/database.dart';

/// What an import did, for the import report screen. Every line of the file
/// after the header is counted in exactly one of [created], [duplicates],
/// [failed] or blank lines, so the numbers always add up.
final class ImportOutcome {
  const ImportOutcome({
    required this.batchId,
    required this.created,
    required this.duplicates,
    required this.errors,
    required this.balanceWarnings,
    required this.transfersMarked,
  });

  final String batchId;
  final int created;
  final int duplicates;
  final List<RowError> errors;
  final List<BalanceWarning> balanceWarnings;
  final int transfersMarked;

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
      for (var i = 0; i < result.rows.length; i++) {
        if (existing.contains(hashes[i])) {
          duplicates++;
          continue;
        }
        await _insertRow(accountId, batchId, hashes[i], result.rows[i], now);
        created++;
      }

      final transfers = result.rows.isEmpty
          ? 0
          : await _markTransfers(
              result.periodFrom!.addDays(-transferSearchDays),
              result.periodTo!.addDays(transferSearchDays),
              now,
            );

      await (_db.update(
        _db.importBatches,
      )..where((b) => b.id.equals(batchId))).write(
        ImportBatchesCompanion(
          status: const Value(ImportStatus.completed),
          parsedCount: Value(result.rows.length),
          failedCount: Value(result.errors.length),
          duplicateCount: Value(duplicates),
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
        errors: result.errors,
        balanceWarnings: result.balanceWarnings,
        transfersMarked: transfers,
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

  Future<void> _insertRow(
    String accountId,
    String batchId,
    String hash,
    StatementRow row,
    DateTime now,
  ) async {
    final parsed = parseDescription(row.description);
    final (flow, reason) = defaultFlow(row.direction, row.description);
    final recordId = newId();
    final txId = newId();

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

    await _db
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

  /// Re-runs transfer detection over a date range of the whole ledger, so a
  /// second account's statement can complete a pair with the first.
  /// Transactions you changed by hand are left alone. Returns how many
  /// transactions changed.
  Future<int> _markTransfers(LocalDate from, LocalDate to, DateTime now) async {
    final accounts = {
      for (final a in await _db.select(_db.accounts).get()) a.id: a,
    };
    final ownVpas = {
      for (final a in accounts.values)
        for (final h in a.upiHandles) h.toString(),
    };
    final txs =
        await (_db.select(_db.transactions)..where(
              (t) =>
                  t.localDate.isBetweenValues(from.toIso(), to.toIso()) &
                  t.deletedAt.isNull() &
                  t.flowReason.equals(FlowReason.user.wire).not(),
            ))
            .get();
    final matches = detectTransfers([
      for (final t in txs)
        TransferCandidate(
          id: t.id,
          accountId: t.accountId,
          accountKind: accounts[t.accountId]?.kind,
          direction: t.direction,
          amount: Paise(t.amountPaise),
          date: t.localDate,
          description: t.descriptionRaw ?? '',
          vpa: t.vpa,
        ),
    ], ownVpas: ownVpas);

    var changed = 0;
    for (final t in txs) {
      final m = matches[t.id];
      if (m == null) continue;
      if (t.flow == TransactionFlow.transfer &&
          t.flowReason == m.reason &&
          t.transferPairId == m.counterpartId) {
        continue;
      }
      await (_db.update(
        _db.transactions,
      )..where((x) => x.id.equals(t.id))).write(
        TransactionsCompanion(
          flow: const Value(TransactionFlow.transfer),
          flowReason: Value(m.reason),
          transferPairId: Value(m.counterpartId),
          counterpartyKind: const Value(CounterpartyKind.self),
          updatedAt: Value(now),
          version: Value(t.version + 1),
        ),
      );
      changed++;
    }
    return changed;
  }
}
