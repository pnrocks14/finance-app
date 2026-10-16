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

/// Opens the system file picker. Overridden in tests.
final statementFilePickerProvider = Provider<StatementFilePicker>(
  (ref) => const SystemStatementFilePicker(),
);

/// Reads text out of PDF statements. Overridden in tests.
final pdfTextExtractorProvider = Provider<PdfTextExtractor>(
  (ref) => const PdfiumTextExtractor(),
);
