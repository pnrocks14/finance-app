import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../security/secret_store.dart';
import 'connection.dart';
import 'database.dart';

/// Opens the app's encrypted database in the private application support
/// directory, creating the key on first launch.
Future<FinanceDatabase> openAppDatabase(SecretStore store) async {
  final dir = await getApplicationSupportDirectory();
  final key = await obtainDatabaseKey(store);
  return openFinanceDatabaseFile(
    File(p.join(dir.path, 'finance.db')),
    hexKey: key,
  );
}
