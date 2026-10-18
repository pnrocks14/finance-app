import 'package:drift/drift.dart';
import 'package:finance_core/finance_core.dart';

import '../db/database.dart';

/// Monthly limits per category. One limit per category, used for every
/// month from when it was set.
class BudgetsRepository {
  BudgetsRepository(this._db, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final FinanceDatabase _db;
  final DateTime Function() _clock;

  /// Category id to its monthly limit.
  Stream<Map<String, Paise>> watchLimits() =>
      (_db.select(
        _db.budgets,
      )..orderBy([(b) => OrderingTerm.asc(b.effectiveFrom)])).watch().map(
        (rows) => {for (final b in rows) b.categoryId: Paise(b.limitPaise)},
      );

  /// Sets or changes a category's monthly limit.
  Future<void> setLimit(String categoryId, Paise limit) {
    if (limit <= Paise.zero) {
      throw ArgumentError.value(limit, 'limit', 'Must be more than zero');
    }
    return _db.transaction(() async {
      final now = _clock().toUtc();
      await remove(categoryId);
      await _db
          .into(_db.budgets)
          .insert(
            BudgetsCompanion.insert(
              id: newId(),
              createdAt: now,
              updatedAt: now,
              categoryId: categoryId,
              limitPaise: limit.value,
              effectiveFrom: monthOf(LocalDate.ofInstant(now)),
            ),
          );
    });
  }

  Future<void> remove(String categoryId) => (_db.delete(
    _db.budgets,
  )..where((b) => b.categoryId.equals(categoryId))).go();
}
