import 'package:drift/drift.dart';
import 'package:finance_core/finance_core.dart';

import '../db/database.dart';

/// Bank accounts, cards and wallets.
class AccountsRepository {
  AccountsRepository(this._db, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final FinanceDatabase _db;
  final DateTime Function() _clock;

  Stream<List<Account>> watchActive() =>
      (_db.select(_db.accounts)
            ..where((a) => a.isArchived.equals(false))
            ..orderBy([(a) => OrderingTerm.asc(a.displayName)]))
          .watch();

  Future<List<Account>> all() => _db.select(_db.accounts).get();

  Future<Account> create({
    required AccountKind kind,
    required String institution,
    required String displayName,
    String? last4,
    List<String> upiHandles = const [],
    Paise openingBalance = Paise.zero,
  }) async {
    // Payment apps sometimes show only the last two digits of a card.
    if (last4 != null && !RegExp(r'^\d{2,4}$').hasMatch(last4)) {
      throw ArgumentError.value(last4, 'last4', 'Must be 2 to 4 digits');
    }
    final now = _clock().toUtc();
    final row = AccountsCompanion.insert(
      id: newId(),
      createdAt: now,
      updatedAt: now,
      kind: kind,
      institution: institution.trim(),
      displayName: displayName.trim(),
      last4: Value(last4),
      upiHandles: Value(upiHandles.map((h) => h.trim().toLowerCase()).toList()),
      openingBalancePaise: Value(openingBalance.value),
    );
    return _db.into(_db.accounts).insertReturning(row);
  }

  /// Renames an account, or changes its kind or opening balance.
  Future<void> update(
    String id, {
    String? displayName,
    AccountKind? kind,
    Paise? openingBalance,
  }) async {
    final a = await (_db.select(
      _db.accounts,
    )..where((r) => r.id.equals(id))).getSingle();
    await (_db.update(_db.accounts)..where((r) => r.id.equals(id))).write(
      AccountsCompanion(
        displayName: displayName == null || displayName.trim().isEmpty
            ? const Value.absent()
            : Value(displayName.trim()),
        kind: kind == null ? const Value.absent() : Value(kind),
        openingBalancePaise: openingBalance == null
            ? const Value.absent()
            : Value(openingBalance.value),
        version: Value(a.version + 1),
        updatedAt: Value(_clock().toUtc()),
      ),
    );
  }

  /// Hides an account from lists. Its transactions stay and still count.
  Future<void> archive(String id) =>
      (_db.update(_db.accounts)..where((r) => r.id.equals(id))).write(
        AccountsCompanion(
          isArchived: const Value(true),
          updatedAt: Value(_clock().toUtc()),
        ),
      );

  /// Each account's balance: its opening balance plus money in less money
  /// out. Accounts with no transactions are included.
  Stream<Map<String, Paise>> watchBalances() {
    final query = _db.customSelect(
      '''
      SELECT a.id AS id, a.opening_balance_paise + COALESCE(SUM(
        CASE t.direction WHEN 'credit' THEN t.amount_paise
          ELSE -t.amount_paise END), 0) AS balance
      FROM accounts a
      LEFT JOIN transactions t
        ON t.account_id = a.id AND t.deleted_at IS NULL
      GROUP BY a.id
      ''',
      readsFrom: {_db.accounts, _db.transactions},
    );
    return query.watch().map(
      (rows) => {
        for (final r in rows)
          r.read<String>('id'): Paise(r.read<int>('balance')),
      },
    );
  }
}
