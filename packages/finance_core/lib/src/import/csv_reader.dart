import 'dart:convert';

/// Decodes statement file bytes into text. Handles a UTF-8 or UTF-16 byte
/// order mark; anything that isn't valid UTF-8 is read as Latin-1, which is
/// what older bank exports use.
String decodeStatementBytes(List<int> bytes) {
  if (bytes.length >= 3 &&
      bytes[0] == 0xEF &&
      bytes[1] == 0xBB &&
      bytes[2] == 0xBF) {
    return utf8.decode(bytes.sublist(3), allowMalformed: true);
  }
  if (bytes.length >= 2) {
    final le = bytes[0] == 0xFF && bytes[1] == 0xFE;
    final be = bytes[0] == 0xFE && bytes[1] == 0xFF;
    if (le || be) {
      final units = <int>[];
      for (var i = 2; i + 1 < bytes.length; i += 2) {
        units.add(
          le ? bytes[i] | (bytes[i + 1] << 8) : (bytes[i] << 8) | bytes[i + 1],
        );
      }
      return String.fromCharCodes(units);
    }
  }
  try {
    return utf8.decode(bytes);
  } on FormatException {
    return latin1.decode(bytes);
  }
}

/// Picks the delimiter that splits the first lines most consistently:
/// comma, tab, semicolon or pipe.
String detectDelimiter(String text) {
  final lines = const LineSplitter()
      .convert(text)
      .where((l) => l.trim().isNotEmpty)
      .take(40)
      .toList();
  var best = ',';
  var bestScore = -1;
  for (final d in const [',', '\t', ';', '|']) {
    final counts = [
      for (final l in lines) parseCsv(l, delimiter: d).firstOrNull?.length ?? 0,
    ];
    // Score: how many lines share the most common column count (> 1).
    final freq = <int, int>{};
    for (final c in counts) {
      if (c > 1) freq[c] = (freq[c] ?? 0) + 1;
    }
    final score = freq.values.fold(0, (a, b) => a > b ? a : b);
    if (score > bestScore) {
      bestScore = score;
      best = d;
    }
  }
  return best;
}

/// Canara and some other banks write cells as Excel formulas so leading
/// zeros survive: `="00123"`. The value inside is what matters.
String _unescapeFormula(String cell) {
  final m = RegExp(r'^\s*="(.*)"\s*$', dotAll: true).firstMatch(cell);
  return m == null ? cell : m[1]!.replaceAll('""', '"');
}

/// Parses delimited text (RFC 4180: quoted fields, doubled quotes, line
/// breaks inside quotes, CRLF or LF). Returns one list of cells per line,
/// including blank lines as a single empty cell, so line numbers stay true.
List<List<String>> parseCsv(String text, {String delimiter = ','}) {
  final rows = <List<String>>[];
  var row = <String>[];
  final cell = StringBuffer();
  var inQuotes = false;
  var i = 0;
  void endCell() {
    row.add(_unescapeFormula(cell.toString()));
    cell.clear();
  }

  void endRow() {
    endCell();
    rows.add(row);
    row = <String>[];
  }

  while (i < text.length) {
    final ch = text[i];
    if (inQuotes) {
      if (ch == '"') {
        if (i + 1 < text.length && text[i + 1] == '"') {
          cell.write('"');
          i += 2;
          continue;
        }
        inQuotes = false;
      } else {
        cell.write(ch);
      }
      i++;
      continue;
    }
    if (ch == '"' && cell.toString().trim().isEmpty) {
      cell.clear();
      inQuotes = true;
    } else if (ch == delimiter) {
      endCell();
    } else if (ch == '\r') {
      endRow();
      if (i + 1 < text.length && text[i + 1] == '\n') i++;
    } else if (ch == '\n') {
      endRow();
    } else {
      cell.write(ch);
    }
    i++;
  }
  if (cell.isNotEmpty || row.isNotEmpty) endRow();
  return rows;
}
