import 'package:drift/drift.dart';
import 'package:finance_core/finance_core.dart';

import '../db/database.dart';

/// Read access to the ledger for screens.
class TransactionsRepository {
  TransactionsRepository(this._db);

  final FinanceDatabase _db;

  /// Newest first, optionally limited to one IST calendar month.
  Stream<List<Transaction>> watch({LocalDate? month, int limit = 500}) {
    final q = _db.select(_db.transactions)
      ..where((t) => t.deletedAt.isNull())
      ..orderBy([
        (t) => OrderingTerm.desc(t.localDate),
        (t) => OrderingTerm.desc(t.createdAt),
      ])
      ..limit(limit);
    if (month != null) {
      final first = LocalDate(month.year, month.month, 1);
      final last = LocalDate(month.year, month.month, first.daysInMonth);
      q.where((t) => t.localDate.isBetweenValues(first.toIso(), last.toIso()));
    }
    return q.watch();
  }

  Stream<int> watchCount() {
    final count = _db.transactions.id.count();
    return (_db.selectOnly(_db.transactions)
          ..addColumns([count])
          ..where(_db.transactions.deletedAt.isNull()))
        .map((r) => r.read(count) ?? 0)
        .watchSingle();
  }
}

/// Past imports, newest first, for the import history.
class ImportBatchesRepository {
  ImportBatchesRepository(this._db);

  final FinanceDatabase _db;

  Stream<List<ImportBatch>> watchRecent({int limit = 20}) =>
      (_db.select(_db.importBatches)
            ..orderBy([(b) => OrderingTerm.desc(b.createdAt)])
            ..limit(limit))
          .watch();
}
