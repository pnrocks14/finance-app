import 'package:drift/drift.dart';
import 'package:finance_core/finance_core.dart';

import '../db/database.dart';

/// What you're adding by hand.
enum EntryKind { expense, income, transfer }

/// Transactions you add yourself: cash spends, income a statement won't
/// show, or moving money between your accounts.
class ManualEntries {
  ManualEntries(this._db, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final FinanceDatabase _db;
  final DateTime Function() _clock;

  /// Adds an entry on [date] at [time] (IST) and returns its id. A transfer
  /// needs [toAccountId] and makes two linked transactions, which count as
  /// neither spending nor income. A category you pick is never changed by
  /// the categoriser.
  Future<String> add({
    required EntryKind kind,
    required Paise amount,
    required String accountId,
    required LocalDate date,
    Duration time = Duration.zero,
    String? toAccountId,
    String? categoryId,
    String? note,
  }) {
    if (amount <= Paise.zero) {
      throw ArgumentError.value(amount, 'amount', 'Must be more than zero');
    }
    if (kind == EntryKind.transfer &&
        (toAccountId == null || toAccountId == accountId)) {
      throw ArgumentError.value(toAccountId, 'toAccountId');
    }
    final text = note?.trim();
    final hasNote = text != null && text.isNotEmpty;
    return _db.transaction(() async {
      final now = _clock().toUtc();
      final at = date.startInstant.add(time);
      final names = {
        for (final a in await _db.select(_db.accounts).get())
          a.id: a.displayName,
      };

      TransactionsCompanion row({
        required String id,
        required String account,
        required Direction direction,
        required TransactionFlow flow,
        required String? category,
        required String payee,
        String? pairId,
      }) => TransactionsCompanion.insert(
        id: id,
        createdAt: now,
        updatedAt: now,
        accountId: Value(account),
        direction: direction,
        amountPaise: amount.value,
        occurredAt: at,
        localDate: date,
        channel: Channel.other,
        counterpartyName: Value(payee),
        counterpartyKind: Value(
          flow == TransactionFlow.transfer
              ? CounterpartyKind.self
              : CounterpartyKind.unknown,
        ),
        categoryId: Value(category),
        categorizedBy: Value(
          category == null ? null : CategorizationMethod.manual,
        ),
        categorizationConfidence: Value(category == null ? null : 1),
        flow: flow,
        flowReason: const Value(FlowReason.user),
        transferPairId: Value(pairId),
        reconciliationStatus: ReconciliationStatus.single,
        notes: Value(hasNote ? text : null),
      );

      final id = newId();
      if (kind == EntryKind.transfer) {
        final inId = newId();
        await _db.batch(
          (b) => b.insertAll(_db.transactions, [
            row(
              id: id,
              account: accountId,
              direction: Direction.debit,
              flow: TransactionFlow.transfer,
              category: Cat.ownTransfers,
              payee: hasNote ? text : 'To ${names[toAccountId]}',
              pairId: inId,
            ),
            row(
              id: inId,
              account: toAccountId!,
              direction: Direction.credit,
              flow: TransactionFlow.transfer,
              category: Cat.ownTransfers,
              payee: hasNote ? text : 'From ${names[accountId]}',
              pairId: id,
            ),
          ]),
        );
        return id;
      }
      final categoryName = categoryId == null
          ? null
          : (await (_db.select(
              _db.categories,
            )..where((c) => c.id.equals(categoryId))).getSingleOrNull())?.name;
      final expense = kind == EntryKind.expense;
      await _db
          .into(_db.transactions)
          .insert(
            row(
              id: id,
              account: accountId,
              direction: expense ? Direction.debit : Direction.credit,
              flow: expense ? TransactionFlow.spend : TransactionFlow.income,
              category: categoryId,
              payee: hasNote
                  ? text
                  : categoryName ?? (expense ? 'Cash spend' : 'Money in'),
            ),
          );
      return id;
    });
  }

  /// True for a transaction you added here rather than one read from a
  /// statement or SMS.
  Future<bool> isManual(String id) async {
    final linked = await (_db.select(
      _db.transactionSources,
    )..where((s) => s.transactionId.equals(id))).get();
    return linked.isEmpty;
  }

  /// Removes an entry you added, and the other half of a transfer. Ones
  /// from a statement or SMS can't be removed this way.
  Future<void> delete(String id) => _db.transaction(() async {
    if (!await isManual(id)) {
      throw StateError('Only entries you added can be removed');
    }
    final t = await (_db.select(
      _db.transactions,
    )..where((r) => r.id.equals(id))).getSingle();
    final ids = [id, ?t.transferPairId];
    await (_db.update(_db.transactions)..where((r) => r.id.isIn(ids))).write(
      TransactionsCompanion(
        deletedAt: Value(_clock().toUtc()),
        updatedAt: Value(_clock().toUtc()),
      ),
    );
  });
}
