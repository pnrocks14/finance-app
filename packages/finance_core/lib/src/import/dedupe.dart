import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'statement_csv.dart';

/// Description with case and spacing normalised, so a re-export that only
/// changes whitespace still dedupes.
String _normalize(String s) =>
    s.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();

/// Dedupe hashes for statement rows, one per row, in order.
///
/// The key is account + date + direction + amount + description + balance.
/// Two genuinely identical rows in one file (two ₹20 chai payments with no
/// balance column) also get their occurrence number, so both are kept,
/// while importing the same file again reproduces the same hashes.
List<String> statementRowHashes(String accountId, List<StatementRow> rows) {
  final seen = <String, int>{};
  return [
    for (final row in rows)
      () {
        final key = [
          'stmt:v1',
          accountId,
          row.date.toIso(),
          row.direction.wire,
          row.amount.value,
          _normalize(row.description),
          row.balance?.value ?? '',
        ].join('|');
        final n = seen[key] = (seen[key] ?? 0) + 1;
        return sha256.convert(utf8.encode('$key|$n')).toString();
      }(),
  ];
}
