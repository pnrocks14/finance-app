import 'dart:typed_data';

import 'package:pdfrx/pdfrx.dart';

/// The PDF needs a password before its text can be read.
final class PdfPasswordRequired implements Exception {
  const PdfPasswordRequired();
}

/// Pulls the text out of a PDF statement. Behind an interface so tests can
/// supply text without the native PDF engine.
abstract interface class PdfTextExtractor {
  Future<String> extract(List<int> bytes);
}

/// Reads PDFs with PDFium, on the device. Nothing is uploaded.
class PdfiumTextExtractor implements PdfTextExtractor {
  const PdfiumTextExtractor();

  @override
  Future<String> extract(List<int> bytes) async {
    await pdfrxFlutterInitialize();
    final PdfDocument doc;
    try {
      doc = await PdfDocument.openData(
        Uint8List.fromList(bytes),
        sourceName: 'statement',
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
