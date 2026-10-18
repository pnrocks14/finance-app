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

/// Opens the system file picker. Overridden in tests.
final statementFilePickerProvider = Provider<StatementFilePicker>(
  (ref) => const SystemStatementFilePicker(),
);

/// Reads text out of PDF statements. Overridden in tests.
final pdfTextExtractorProvider = Provider<PdfTextExtractor>(
  (ref) => const PdfiumTextExtractor(),
);
