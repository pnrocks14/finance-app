import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:finance_core/finance_core.dart';
import 'package:finance_data/finance_data.dart';
import 'package:flutter_test/flutter_test.dart';

// Test-only keys, built at runtime so they don't read like a committed secret.
final _key = 'ab' * 32;
final _otherKey = 'cd' * 32;

void main() {
  test('this SQLite build supports encryption', () {
    expect(sqliteSupportsEncryption(), isTrue);
  });

  group('encrypted file database', () {
    late Directory dir;

    setUp(() => dir = Directory.systemTemp.createTempSync('finance_db_test'));
    tearDown(() => dir.deleteSync(recursive: true));

    test(
      'round-trips data with the right key and rejects a wrong key',
      () async {
        final file = File('${dir.path}/finance.db');
        final db = openFinanceDatabaseFile(file, hexKey: _key);
        await db.into(db.accounts).insert(_account('HDFC Savings'));
        await db.close();

        // The file must not contain the plain text it stores.
        final bytes = file.readAsBytesSync();
        expect(String.fromCharCodes(bytes).contains('HDFC Savings'), isFalse);
        expect(
          String.fromCharCodes(bytes.take(16)).startsWith('SQLite format'),
          isFalse,
        );

        final reopened = openFinanceDatabaseFile(file, hexKey: _key);
        final accounts = await reopened.select(reopened.accounts).get();
        expect(accounts.single.displayName, 'HDFC Savings');
        expect(accounts.single.kind, AccountKind.bankAccount);
        await reopened.close();

        final wrong = openFinanceDatabaseFile(file, hexKey: _otherKey);
        await expectLater(
          wrong.select(wrong.accounts).get(),
          throwsA(anything),
        );
        await wrong.close();
      },
    );

    test('rejects malformed keys before touching the file', () {
      expect(
        () =>
            openFinanceDatabaseFile(File('${dir.path}/x.db'), hexKey: 'short'),
        throwsArgumentError,
      );
    });
  });

  group('schema', () {
    late FinanceDatabase db;

    setUp(() => db = openInMemoryFinanceDatabase());
    tearDown(() => db.close());

    test('creates every table', () async {
      final rows = await db
          .customSelect("SELECT name FROM sqlite_master WHERE type = 'table'")
          .get();
      final names = rows.map((r) => r.read<String>('name')).toSet();
      expect(
        names,
        containsAll(<String>[
          'user_profiles',
          'accounts',
          'import_batches',
          'source_records',
          'transactions',
          'transaction_sources',
          'reconciliation_reviews',
          'categories',
          'category_rules',
          'training_labels',
          'budgets',
          'goals',
          'recurring_series',
          'insights',
          'proposals',
          'plan_extensions',
          'audit_log',
          'ai_requests',
        ]),
      );
    });

    test(
      'stores enums by wire name, dates as ISO text and money as paise',
      () async {
        final accountId = newId();
        await db.into(db.accounts).insert(_account('Card', id: accountId));
        final occurredAt = DateTime.utc(2026, 10, 11, 19);
        await db
            .into(db.transactions)
            .insert(
              TransactionsCompanion.insert(
                id: newId(),
                createdAt: occurredAt,
                updatedAt: occurredAt,
                accountId: Value(accountId),
                direction: Direction.debit,
                amountPaise: 45000,
                occurredAt: occurredAt,
                localDate: LocalDate.ofInstant(occurredAt),
                channel: Channel.upi,
                flow: TransactionFlow.spend,
                reconciliationStatus: ReconciliationStatus.single,
                counterpartyKind: const Value(CounterpartyKind.merchant),
              ),
            );

        final raw = await db
            .customSelect(
              'SELECT direction, amount_paise, local_date, occurred_at, counterparty_kind '
              'FROM transactions',
            )
            .getSingle();
        expect(raw.read<String>('direction'), 'debit');
        expect(raw.read<int>('amount_paise'), 45000);
        expect(raw.read<String>('local_date'), '2026-10-12');
        expect(
          raw.read<String>('occurred_at'),
          startsWith('2026-10-11T19:00:00'),
        );
        expect(raw.read<String>('counterparty_kind'), 'merchant');
      },
    );

    test('rejects non-positive amounts', () async {
      final now = DateTime.utc(2026, 10, 12);
      final insert = db
          .into(db.transactions)
          .insert(
            TransactionsCompanion.insert(
              id: newId(),
              createdAt: now,
              updatedAt: now,
              direction: Direction.debit,
              amountPaise: 0,
              occurredAt: now,
              localDate: LocalDate.ofInstant(now),
              channel: Channel.upi,
              flow: TransactionFlow.spend,
              reconciliationStatus: ReconciliationStatus.single,
            ),
          );
      await expectLater(insert, throwsA(anything));
    });

    test('dedupe hash is unique', () async {
      Future<void> add() => db
          .into(db.sourceRecords)
          .insert(
            SourceRecordsCompanion.insert(
              id: newId(),
              createdAt: DateTime.utc(2026),
              updatedAt: DateTime.utc(2026),
              kind: SourceKind.sms,
              dedupeHash: 'same-hash',
              parseStatus: ParseStatus.parsed,
              receivedAt: DateTime.utc(2026),
            ),
          );
      await add();
      await expectLater(add(), throwsA(anything));
    });

    test('audit log is append-only', () async {
      final now = DateTime.utc(2026, 10, 12);
      await db
          .into(db.auditLog)
          .insert(
            AuditLogCompanion.insert(
              id: newId(),
              createdAt: now,
              updatedAt: now,
              sequence: 1,
              event: AuditEvent.proposalCreated,
              actor: 'test',
              prevHash: '',
              hash: 'abc',
            ),
          );
      await expectLater(
        db.customStatement("UPDATE audit_log SET actor = 'someone else'"),
        throwsA(anything),
      );
      await expectLater(
        db.customStatement('DELETE FROM audit_log'),
        throwsA(anything),
      );
      expect(await db.select(db.auditLog).get(), hasLength(1));
    });

    test('foreign keys are enforced', () async {
      final now = DateTime.utc(2026, 10, 12);
      final insert = db
          .into(db.budgets)
          .insert(
            BudgetsCompanion.insert(
              id: newId(),
              createdAt: now,
              updatedAt: now,
              categoryId: 'no-such-category',
              limitPaise: 100000,
              effectiveFrom: LocalDate(2026, 10, 1),
            ),
          );
      await expectLater(insert, throwsA(anything));
    });
  });
}

AccountsCompanion _account(String name, {String? id}) {
  final now = DateTime.utc(2026, 10, 12);
  return AccountsCompanion.insert(
    id: id ?? newId(),
    createdAt: now,
    updatedAt: now,
    kind: AccountKind.bankAccount,
    institution: 'HDFC Bank',
    displayName: name,
  );
}
