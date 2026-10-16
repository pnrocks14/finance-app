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
    );
    return _db.into(_db.accounts).insertReturning(row);
  }
}
