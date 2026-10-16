// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:drift/drift.dart' hide isNull;
import 'package:drift_dev/api/migrations_native.dart';
import 'package:finance_core/finance_core.dart';
import 'package:finance_data/src/db/database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated/schema.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    // These simple tests verify all possible schema updates with a simple (no
    // data) migration. This is a quick way to ensure that written database
    // migrations properly alter the schema.
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = FinanceDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  test(
    'v1 transactions survive the move to v2 with a default reason',
    () async {
      final schema = await verifier.schemaAt(1);
      final old = schema.rawDatabase;
      const now = '2026-10-01T00:00:00.000Z';
      old.execute(
        'INSERT INTO transactions (id, created_at, updated_at, version, '
        'direction, amount_paise, occurred_at, local_date, channel, flow, '
        "reconciliation_status) VALUES ('t1', '$now', '$now', 1, 'debit', "
        "45000, '$now', '2026-10-01', 'upi', 'spend', 'single')",
      );

      final db = FinanceDatabase(schema.newConnection());
      await verifier.migrateAndValidate(db, 2);
      final row = await db.select(db.transactions).getSingle();
      expect(row.amountPaise, 45000);
      expect(row.flowReason, FlowReason.direction);
      expect(row.transferPairId, isNull);
      await db.close();
    },
  );
}
