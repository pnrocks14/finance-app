import 'package:drift/drift.dart';
import 'package:finance_core/finance_core.dart';

import '../categories/category_service.dart';
import 'converters.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    UserProfiles,
    Accounts,
    ImportBatches,
    SourceRecords,
    Transactions,
    TransactionSources,
    ReconciliationReviews,
    Categories,
    CategoryRules,
    TrainingLabels,
    Budgets,
    Goals,
    RecurringSeries,
    Insights,
    Proposals,
    PlanExtensions,
    AuditLog,
    AiRequests,
  ],
)
class FinanceDatabase extends _$FinanceDatabase {
  FinanceDatabase(super.executor);

  /// Bump this and add a step in [migration] whenever a table changes. Run
  /// `dart run drift_dev make-migrations` (from packages/finance_data) to
  /// snapshot the schema and generate a migration test.
  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _createAuditLogGuards();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(transactions, transactions.flowReason);
        await m.addColumn(transactions, transactions.transferPairId);
        await m.create(transactionsAccountDate);
      }
      if (from < 3 && to >= 3) {
        await m.addColumn(accounts, accounts.openingBalancePaise);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await seedCategoryRows(this, DateTime.now().toUtc());
    },
  );

  /// The audit log is append-only: these triggers make any UPDATE or DELETE
  /// on it fail, whatever code path tries it.
  Future<void> _createAuditLogGuards() async {
    await customStatement('''
      CREATE TRIGGER audit_log_no_update BEFORE UPDATE ON audit_log
      BEGIN SELECT RAISE(ABORT, 'audit_log is append-only'); END;
    ''');
    await customStatement('''
      CREATE TRIGGER audit_log_no_delete BEFORE DELETE ON audit_log
      BEGIN SELECT RAISE(ABORT, 'audit_log is append-only'); END;
    ''');
  }
}
