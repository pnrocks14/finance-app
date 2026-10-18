import 'dart:typed_data';

import 'package:pdfrx/pdfrx.dart';

/// The PDF is locked and the password given (or none) doesn't open it.
final class PdfPasswordRequired implements Exception {
  const PdfPasswordRequired();
}

/// Pulls the text out of a PDF statement. Behind an interface so tests can
/// supply text without the native PDF engine.
abstract interface class PdfTextExtractor {
  /// Throws [PdfPasswordRequired] when the PDF is locked and [password] is
  /// missing or wrong.
  Future<String> extract(List<int> bytes, {String? password});
}

/// Reads PDFs with PDFium, on the device. Nothing is uploaded.
class PdfiumTextExtractor implements PdfTextExtractor {
  const PdfiumTextExtractor();

  @override
  Future<String> extract(List<int> bytes, {String? password}) async {
    await pdfrxFlutterInitialize();
    final PdfDocument doc;
    try {
      doc = await PdfDocument.openData(
        Uint8List.fromList(bytes),
        sourceName: 'statement',
        // Returns the password once, then null, so a wrong one fails
        // instead of being retried forever.
        passwordProvider: createSimplePasswordProvider(password),
      );
    } on PdfPasswordException {
      throw const PdfPasswordRequired();
    }
    try {
      final text = StringBuffer();
      for (final page in doc.pages) {
        final pageText = await page.loadText();
        if (pageText != null) text.writeln(pageText.fullText);
      }
      return text.toString();
    } finally {
      await doc.dispose();
    }
  }
}
