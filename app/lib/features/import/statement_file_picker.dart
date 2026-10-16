import 'package:file_picker/file_picker.dart';

/// A statement file the user picked.
final class PickedStatement {
  const PickedStatement({required this.name, required this.bytes});
  final String name;
  final List<int> bytes;
}

/// Picks a statement file. Behind an interface so tests can supply bytes.
abstract interface class StatementFilePicker {
  /// Returns null if the user backed out.
  Future<PickedStatement?> pick();
}

/// Uses the Android document picker, so the app needs no storage
/// permission: it only sees the one file you choose.
class SystemStatementFilePicker implements StatementFilePicker {
  const SystemStatementFilePicker();

  static const maxBytes = 20 * 1024 * 1024;

  @override
  Future<PickedStatement?> pick() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['csv', 'txt', 'tsv', 'pdf'],
    );
    if (file == null) return null;
    final size = await file.length();
    if (size != null && size > maxBytes) {
      throw const FormatException('That file is over 20 MB');
    }
    return PickedStatement(name: file.name, bytes: await file.readAsBytes());
  }
}
