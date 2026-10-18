import 'package:finance_core/finance_core.dart';
import 'package:finance_data/finance_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/import/pdf_text.dart';
import '../features/import/statement_file_picker.dart';
import 'providers.dart';

final accountsRepositoryProvider = FutureProvider<AccountsRepository>(
  (ref) async => AccountsRepository(await ref.watch(databaseProvider.future)),
);

final transactionsRepositoryProvider = FutureProvider<TransactionsRepository>(
  (ref) async =>
      TransactionsRepository(await ref.watch(databaseProvider.future)),
);

final statementImporterProvider = FutureProvider<StatementImporter>(
  (ref) async => StatementImporter(await ref.watch(databaseProvider.future)),
);

final appStatementImporterProvider = FutureProvider<AppStatementImporter>(
  (ref) async => AppStatementImporter(await ref.watch(databaseProvider.future)),
);

final accountsProvider = StreamProvider<List<Account>>((ref) async* {
  final repo = await ref.watch(accountsRepositoryProvider.future);
  yield* repo.watchActive();
});

final transactionsProvider = StreamProvider<List<Transaction>>((ref) async* {
  final repo = await ref.watch(transactionsRepositoryProvider.future);
  yield* repo.watch();
});

final categoryServiceProvider = FutureProvider<CategoryService>(
  (ref) async => CategoryService(await ref.watch(databaseProvider.future)),
);

final categoriesRepositoryProvider = FutureProvider<CategoriesRepository>(
  (ref) async => CategoriesRepository(await ref.watch(databaseProvider.future)),
);

final categoriesProvider = StreamProvider<List<Category>>((ref) async* {
  final repo = await ref.watch(categoriesRepositoryProvider.future);
  yield* repo.watchAll();
});

/// Your category rules, newest first.
final categoryRulesProvider = StreamProvider<List<CategoryRule>>((ref) async* {
  final repo = await ref.watch(categoriesRepositoryProvider.future);
  yield* repo.watchRules();
});

/// Transactions narrowed by a filter, newest first.
final filteredTransactionsProvider =
    StreamProvider.family<List<Transaction>, TransactionFilter>((
      ref,
      filter,
    ) async* {
      final repo = await ref.watch(transactionsRepositoryProvider.future);
      yield* repo.watchFiltered(filter);
    });

/// One transaction, for its detail sheet.
final transactionProvider = StreamProvider.family<Transaction?, String>((
  ref,
  id,
) async* {
  final repo = await ref.watch(transactionsRepositoryProvider.future);
  yield* repo.watchOne(id);
});

/// Months with transactions, newest first.
final monthsProvider = StreamProvider<List<LocalDate>>((ref) async* {
  final repo = await ref.watch(transactionsRepositoryProvider.future);
  yield* repo.watchMonths();
});

/// Opens the system file picker. Overridden in tests.
final statementFilePickerProvider = Provider<StatementFilePicker>(
  (ref) => const SystemStatementFilePicker(),
);

/// Reads text out of PDF statements. Overridden in tests.
final pdfTextExtractorProvider = Provider<PdfTextExtractor>(
  (ref) => const PdfiumTextExtractor(),
);

final budgetsRepositoryProvider = FutureProvider<BudgetsRepository>(
  (ref) async => BudgetsRepository(await ref.watch(databaseProvider.future)),
);

/// Category id to its monthly limit.
final budgetLimitsProvider = StreamProvider<Map<String, Paise>>((ref) async* {
  final repo = await ref.watch(budgetsRepositoryProvider.future);
  yield* repo.watchLimits();
});

final manualEntriesProvider = FutureProvider<ManualEntries>(
  (ref) async => ManualEntries(await ref.watch(databaseProvider.future)),
);

/// Each account's balance, by account id.
final accountBalancesProvider = StreamProvider<Map<String, Paise>>((
  ref,
) async* {
  final repo = await ref.watch(accountsRepositoryProvider.future);
  yield* repo.watchBalances();
});

/// Whether a transaction was added by hand, so it can be removed.
final isManualProvider = FutureProvider.family<bool, String>((ref, id) async {
  final entries = await ref.watch(manualEntriesProvider.future);
  return entries.isManual(id);
});

/// What a summary needs from each transaction.
List<MoneyMove> movesOf(Iterable<Transaction> list) => [
  for (final t in list)
    MoneyMove(
      date: t.localDate,
      amount: Paise(t.amountPaise),
      flow: t.flow,
      categoryId: t.categoryId,
    ),
];

/// Money in and out over a week, month or year, kept up to date.
final periodSummaryProvider = StreamProvider.family<PeriodSummary, Period>((
  ref,
  period,
) async* {
  final repo = await ref.watch(transactionsRepositoryProvider.future);
  yield* repo
      .watchFiltered(
        TransactionFilter(from: period.start, to: period.end),
        limit: 100000,
      )
      .map((list) => summarizePeriod(movesOf(list), period));
});
