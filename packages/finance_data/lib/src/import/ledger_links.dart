import 'package:drift/drift.dart';
import 'package:finance_core/finance_core.dart';

import '../db/database.dart';

/// Re-runs transfer detection over a date range of the whole ledger, so a
/// second account's statement can complete a pair with the first.
/// Transactions you changed by hand are left alone, and so are ones a
/// payment app already called a self transfer. Returns how many
/// transactions changed.
Future<int> markTransfers(
  FinanceDatabase db,
  LocalDate from,
  LocalDate to,
  DateTime now,
) async {
  final accounts = {
    for (final a in await db.select(db.accounts).get()) a.id: a,
  };
  final ownVpas = {
    for (final a in accounts.values)
      for (final h in a.upiHandles) h.toString(),
  };
  final cardIssuers = {
    for (final a in accounts.values)
      if (a.kind == AccountKind.creditCard) a.institution,
  };
  final txs =
      await (db.select(db.transactions)..where(
            (t) =>
                t.localDate.isBetweenValues(from.toIso(), to.toIso()) &
                t.deletedAt.isNull() &
                t.flowReason.isIn([
                  FlowReason.user.wire,
                  FlowReason.selfTransfer.wire,
                ]).not(),
          ))
          .get();
  final matches = detectTransfers(
    [
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
          counterpartyName: t.counterpartyName,
          upiRef: t.upiRef,
        ),
    ],
    ownVpas: ownVpas,
    cardIssuers: cardIssuers,
  );

  var changed = 0;
  for (final t in txs) {
    final m = matches[t.id];
    if (m == null) continue;
    if (t.flow == TransactionFlow.transfer &&
        t.flowReason == m.reason &&
        t.transferPairId == m.counterpartId) {
      continue;
    }
    await (db.update(db.transactions)..where((x) => x.id.equals(t.id))).write(
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

/// The live transaction that another source already created for this UPI
/// payment: same UPI reference, direction and amount, and no record of
/// [kind] linked yet. A bank row and an app row for one payment carry the
/// same 12-digit reference, which is how they are joined.
Future<Transaction?> findByUpiRef(
  FinanceDatabase db, {
  required String upiRef,
  required Direction direction,
  required Paise amount,
  required SourceKind kind,
  Set<String> exclude = const {},
}) async {
  final candidates =
      await (db.select(db.transactions)..where(
            (t) =>
                t.upiRef.equals(upiRef) &
                t.direction.equals(direction.wire) &
                t.amountPaise.equals(amount.value) &
                t.deletedAt.isNull(),
          ))
          .get();
  for (final t in candidates) {
    if (exclude.contains(t.id)) continue;
    final linked =
        await (db.select(db.transactionSources)..where(
              (s) => s.transactionId.equals(t.id) & s.kind.equals(kind.wire),
            ))
            .getSingleOrNull();
    if (linked == null) return t;
  }
  return null;
}
