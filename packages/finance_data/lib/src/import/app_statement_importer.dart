import 'package:drift/drift.dart';
import 'package:finance_core/finance_core.dart';

import '../db/database.dart';
import 'ledger_links.dart';
import 'statement_importer.dart';

/// One bank account or card in an app statement, with the account it is
/// likely to be. [account] is null when nothing matches, and importing then
/// adds it as a new account.
final class InstrumentMatch {
  const InstrumentMatch({
    required this.instrument,
    required this.rows,
    this.account,
  });

  /// Null for rows the app printed no account for.
  final PaymentInstrument? instrument;
  final int rows;
  final Account? account;

  /// Key for [AppStatementImporter.import]'s `accounts` map.
  String get key => instrument?.key ?? '';
}

/// A dry run of an app statement import, shown before anything is saved.
final class AppImportPreview {
  const AppImportPreview({
    required this.result,
    required this.alreadyImported,
    required this.matchesBankRows,
    required this.instruments,
  });

  final AppStatementResult result;

  /// Rows already imported from an earlier copy of this statement.
  final int alreadyImported;

  /// New rows whose payment is already here from a bank statement. They
  /// add detail to it instead of becoming a second transaction.
  final int matchesBankRows;
  final List<InstrumentMatch> instruments;

  int get newRows => result.rows.length - alreadyImported;
}

/// The account most likely to be [instrument]: same kind and the same last
/// digits, or failing that, the same bank on an account with no digits
/// saved yet.
Account? suggestAccount(PaymentInstrument instrument, List<Account> accounts) {
  final sameKind = accounts
      .where((a) => a.kind == instrument.kind && !a.isArchived)
      .toList();
  for (final a in sameKind) {
    final l = a.last4;
    if (l != null &&
        (l.endsWith(instrument.digits) || instrument.digits.endsWith(l))) {
      return a;
    }
  }
  final bank = instrument.institution;
  if (bank == null) return null;
  String key(String s) => s.toLowerCase().replaceAll(RegExp('[^a-z]'), '');
  final want = key(bank);
  for (final a in sameKind) {
    if (a.last4 != null) continue;
    final have = key(a.institution);
    final n = have.length < want.length ? have.length : want.length;
    if (n >= 6 && have.substring(0, n) == want.substring(0, n)) return a;
  }
  return null;
}

/// Imports a PhonePe or Google Pay statement. One statement covers several
/// bank accounts and cards, so each row goes to the account its instrument
/// maps to. A row whose UPI reference is already in the ledger from a bank
/// statement is joined to that transaction rather than added again, and the
/// bank importer does the same the other way round. Runs in one database
/// transaction.
class AppStatementImporter {
  AppStatementImporter(this._db, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final FinanceDatabase _db;
  final DateTime Function() _clock;

  Future<AppImportPreview> preview(AppStatementResult result) async {
    final accounts = await _db.select(_db.accounts).get();
    final hashes = appRowHashes(result.app, result.rows);
    final existing = await _existingHashes(hashes);
    var matches = 0;
    for (var i = 0; i < result.rows.length; i++) {
      final row = result.rows[i];
      if (existing.contains(hashes[i]) || row.upiRef == null) continue;
      final tx = await findByUpiRef(
        _db,
        upiRef: row.upiRef!,
        direction: row.direction,
        amount: row.amount,
        kind: SourceKind.upiAppRow,
      );
      if (tx != null) matches++;
    }
    return AppImportPreview(
      result: result,
      alreadyImported: existing.length,
      matchesBankRows: matches,
      instruments: [
        for (final e in result.instruments.entries)
          InstrumentMatch(
            instrument: e.key,
            rows: e.value,
            account: e.key == null ? null : suggestAccount(e.key!, accounts),
          ),
      ],
    );
  }

  /// [accounts] maps [InstrumentMatch.key] to an account id. An instrument
  /// left out, or mapped to null, is added as a new account.
  Future<ImportOutcome> import({
    required AppStatementResult result,
    Map<String, String?> accounts = const {},
    ImportKind kind = ImportKind.statementPdf,
  }) {
    return _db.transaction(() async {
      final now = _clock().toUtc();
      final accountFor = await _resolveAccounts(result, accounts, now);
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
              adapter: Value(result.app.adapter),
              periodFrom: Value(result.periodFrom),
              periodTo: Value(result.periodTo),
            ),
          );

      final hashes = appRowHashes(result.app, result.rows);
      final existing = await _existingHashes(hashes);
      var created = 0;
      var duplicates = 0;
      var matched = 0;
      for (var i = 0; i < result.rows.length; i++) {
        if (existing.contains(hashes[i])) {
          duplicates++;
          continue;
        }
        final row = result.rows[i];
        final linked = await _insertRow(
          accountFor[row.instrument?.key ?? ''],
          batchId,
          hashes[i],
          row,
          result.app,
          now,
        );
        linked ? matched++ : created++;
      }

      final transfers = result.rows.isEmpty
          ? 0
          : await markTransfers(
              _db,
              result.periodFrom!.addDays(-StatementImporter.transferSearchDays),
              result.periodTo!.addDays(StatementImporter.transferSearchDays),
              now,
            );

      final warnings = [
        if (result.totalsMatch == false)
          {
            'reason': 'totals_mismatch',
            'message':
                "The rows don't add up to the totals printed on the "
                'statement.',
          },
      ];
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
            ...warnings,
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
        balanceWarnings: const [],
        transfersMarked: transfers,
      );
    });
  }

  /// Instrument key → account id, adding accounts for instruments that have
  /// none. An account matched by bank name gets its last digits filled in,
  /// so the next statement matches it directly.
  Future<Map<String, String?>> _resolveAccounts(
    AppStatementResult result,
    Map<String, String?> chosen,
    DateTime now,
  ) async {
    final out = <String, String?>{};
    final all = await _db.select(_db.accounts).get();
    final byId = {for (final a in all) a.id: a};
    for (final instrument in result.instruments.keys) {
      if (instrument == null) {
        out[''] = chosen[''];
        continue;
      }
      final id = chosen[instrument.key];
      final account = id == null ? null : byId[id];
      if (account != null) {
        if (account.last4 == null) {
          await (_db.update(
            _db.accounts,
          )..where((a) => a.id.equals(account.id))).write(
            AccountsCompanion(
              last4: Value(instrument.digits),
              updatedAt: Value(now),
              version: Value(account.version + 1),
            ),
          );
        }
        out[instrument.key] = account.id;
        continue;
      }
      final created = await _db
          .into(_db.accounts)
          .insertReturning(
            AccountsCompanion.insert(
              id: newId(),
              createdAt: now,
              updatedAt: now,
              kind: instrument.kind,
              institution:
                  instrument.institution ??
                  (instrument.kind == AccountKind.creditCard
                      ? 'Credit card'
                      : 'Bank account'),
              displayName: instrument.label,
              last4: Value(instrument.digits),
            ),
          );
      out[instrument.key] = created.id;
    }
    return out;
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

  /// Saves the row as evidence, then joins it to the bank's transaction for
  /// the same payment or creates a new one. Returns true when joined.
  Future<bool> _insertRow(
    String? accountId,
    String batchId,
    String hash,
    AppStatementRow row,
    UpiApp app,
    DateTime now,
  ) async {
    final payee = parsePayee(row.counterpartyName, upiRef: row.upiRef);
    final recordId = newId();
    await _db
        .into(_db.sourceRecords)
        .insert(
          SourceRecordsCompanion.insert(
            id: recordId,
            createdAt: now,
            updatedAt: now,
            kind: SourceKind.upiAppRow,
            batchId: Value(batchId),
            dedupeHash: hash,
            parseStatus: ParseStatus.parsed,
            parsed: Value({
              'app': app.adapter,
              'position': row.position,
              'date': row.date.toIso(),
              'occurredAt': row.occurredAt?.toIso8601String(),
              'direction': row.direction.wire,
              'amountPaise': row.amount.value,
              'title': row.title,
              'upiRef': row.upiRef,
              'appRef': row.appRef,
              'instrument': row.instrument?.label,
              'selfTransfer': row.isSelfTransfer,
              'description': payee.toJson(),
            }),
            rawText: Value(row.rawText),
            receivedAt: now,
          ),
        );

    final existing = row.upiRef == null
        ? null
        : await findByUpiRef(
            _db,
            upiRef: row.upiRef!,
            direction: row.direction,
            amount: row.amount,
            kind: SourceKind.upiAppRow,
          );
    final keepFlow = existing != null && existing.flowReason == FlowReason.user;
    if (existing != null) {
      // Bank narrations cut names short ("TEA STALL OWN") or show the
      // account holder instead of the shop, so the app's payee wins. The
      // bank's account and date stay.
      await (_db.update(
        _db.transactions,
      )..where((t) => t.id.equals(existing.id))).write(
        TransactionsCompanion(
          counterpartyName: Value(payee.counterpartyName),
          merchantKey: Value(payee.merchantKey),
          counterpartyKind: Value(
            row.isSelfTransfer
                ? CounterpartyKind.self
                : payee.counterpartyKind == CounterpartyKind.unknown
                ? existing.counterpartyKind
                : payee.counterpartyKind,
          ),
          occurredAt: row.occurredAt == null
              ? const Value.absent()
              : Value(row.occurredAt!),
          flow: row.isSelfTransfer && !keepFlow
              ? const Value(TransactionFlow.transfer)
              : const Value.absent(),
          flowReason: row.isSelfTransfer && !keepFlow
              ? const Value(FlowReason.selfTransfer)
              : const Value.absent(),
          reconciliationStatus: const Value(ReconciliationStatus.matched),
          updatedAt: Value(now),
          version: Value(existing.version + 1),
        ),
      );
      await _link(existing.id, recordId, now);
      return true;
    }

    final (flow, reason) = row.isSelfTransfer
        ? (TransactionFlow.transfer, FlowReason.selfTransfer)
        : defaultFlow(row.direction, row.title);
    final txId = newId();
    final card = row.instrument?.kind == AccountKind.creditCard;
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
            occurredAt: row.occurredAt ?? row.date.startInstant,
            localDate: row.date,
            channel: Channel.upi,
            counterpartyName: Value(payee.counterpartyName),
            merchantKey: Value(payee.merchantKey),
            counterpartyKind: Value(
              row.isSelfTransfer
                  ? CounterpartyKind.self
                  : payee.counterpartyKind,
            ),
            upiRef: Value(row.upiRef),
            cardLast4: Value(card ? row.instrument!.digits : null),
            descriptionRaw: Value(row.title),
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
          kind: SourceKind.upiAppRow,
        ),
      );
}
