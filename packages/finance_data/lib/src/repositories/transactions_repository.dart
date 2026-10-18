import 'package:drift/drift.dart';
import 'package:finance_core/finance_core.dart';

import '../db/database.dart';

/// Which transactions a list shows. Every field left null means "any".
final class TransactionFilter {
  const TransactionFilter({
    this.month,
    this.accountId,
    this.categoryId,
    this.needsCategory = false,
    this.direction,
    this.search,
  });

  /// Any day in the month; only that IST calendar month is shown.
  final LocalDate? month;
  final String? accountId;
  final String? categoryId;

  /// Only those with no category or a guess below [categoryReviewBelow],
  /// leaving out transfers.
  final bool needsCategory;
  final Direction? direction;

  /// Matched against the payee, UPI ID and narration, ignoring case.
  final String? search;

  bool get isEmpty =>
      month == null &&
      accountId == null &&
      categoryId == null &&
      !needsCategory &&
      direction == null &&
      (search == null || search!.trim().isEmpty);

  TransactionFilter copyWith({
    LocalDate? Function()? month,
    String? Function()? accountId,
    String? Function()? categoryId,
    bool? needsCategory,
    Direction? Function()? direction,
    String? Function()? search,
  }) => TransactionFilter(
    month: month == null ? this.month : month(),
    accountId: accountId == null ? this.accountId : accountId(),
    categoryId: categoryId == null ? this.categoryId : categoryId(),
    needsCategory: needsCategory ?? this.needsCategory,
    direction: direction == null ? this.direction : direction(),
    search: search == null ? this.search : search(),
  );

  @override
  bool operator ==(Object other) =>
      other is TransactionFilter &&
      other.month == month &&
      other.accountId == accountId &&
      other.categoryId == categoryId &&
      other.needsCategory == needsCategory &&
      other.direction == direction &&
      other.search == search;

  @override
  int get hashCode => Object.hash(
    month,
    accountId,
    categoryId,
    needsCategory,
    direction,
    search,
  );
}

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

  /// Newest first, narrowed by [filter].
  Stream<List<Transaction>> watchFiltered(
    TransactionFilter filter, {
    int limit = 1000,
  }) {
    final q = _db.select(_db.transactions)
      ..where((t) => t.deletedAt.isNull())
      ..orderBy([
        (t) => OrderingTerm.desc(t.localDate),
        (t) => OrderingTerm.desc(t.createdAt),
      ])
      ..limit(limit);
    if (filter.month case final m?) {
      final first = LocalDate(m.year, m.month, 1);
      final last = LocalDate(m.year, m.month, first.daysInMonth);
      q.where((t) => t.localDate.isBetweenValues(first.toIso(), last.toIso()));
    }
    if (filter.accountId case final id?) {
      q.where((t) => t.accountId.equals(id));
    }
    if (filter.categoryId case final id?) {
      q.where((t) => t.categoryId.equals(id));
    }
    if (filter.direction case final d?) {
      q.where((t) => t.direction.equals(d.wire));
    }
    if (filter.needsCategory) {
      q.where(
        (t) =>
            t.flow.equals(TransactionFlow.transfer.wire).not() &
            (t.categoryId.isNull() |
                t.categorizationConfidence.isSmallerThanValue(
                  categoryReviewBelow,
                )),
      );
    }
    final search = filter.search?.trim().toLowerCase();
    if (search != null && search.isNotEmpty) {
      final like = '%${search.replaceAll('%', '').replaceAll('_', '')}%';
      q.where(
        (t) =>
            t.counterpartyName.lower().like(like) |
            t.vpa.lower().like(like) |
            t.descriptionRaw.lower().like(like),
      );
    }
    return q.watch();
  }

  /// One transaction, kept up to date; null once it is gone.
  Stream<Transaction?> watchOne(String id) => (_db.select(
    _db.transactions,
  )..where((t) => t.id.equals(id))).watchSingleOrNull();

  /// The months that have transactions, newest first, as their first day.
  Stream<List<LocalDate>> watchMonths() {
    final month = _db.transactions.localDate.substr(1, 7);
    return (_db.selectOnly(_db.transactions, distinct: true)
          ..addColumns([month])
          ..where(_db.transactions.deletedAt.isNull())
          ..orderBy([OrderingTerm.desc(month)]))
        .map((r) {
          final parts = r.read(month)!.split('-');
          return LocalDate(int.parse(parts[0]), int.parse(parts[1]), 1);
        })
        .watch();
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
