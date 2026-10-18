/// Pure-Dart business logic for the finance app.
///
/// Nothing in this package may import Flutter, touch the file system, open a
/// database or make a network call. Storage and AI providers are reached only
/// through interfaces that `finance_data` implements.
library;

export 'src/categories/categorizer.dart';
export 'src/categories/merchant_dictionary.dart';
export 'src/categories/seed_categories.dart';
export 'src/ids.dart';
export 'src/import/csv_reader.dart';
export 'src/import/dedupe.dart';
export 'src/import/description_parser.dart';
export 'src/import/sms_parser.dart';
export 'src/import/statement_csv.dart';
export 'src/import/statement_date.dart';
export 'src/import/statement_password.dart';
export 'src/import/statement_pdf.dart';
export 'src/import/transfers.dart';
export 'src/import/upi_app_statement.dart';
export 'src/insights/budgets.dart';
export 'src/insights/month_summary.dart';
export 'src/insights/period_summary.dart';
export 'src/models/enums.dart';
export 'src/money/amount_expression.dart';
export 'src/money/inr_format.dart';
export 'src/money/paise.dart';
export 'src/time/local_date.dart';
