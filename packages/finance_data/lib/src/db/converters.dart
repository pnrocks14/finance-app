import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:finance_core/finance_core.dart';

/// Stores a [WireEnum] by its stable wire name (`"bank_account"`), never by
/// its Dart name or index.
class WireEnumConverter<T extends WireEnum> extends TypeConverter<T, String> {
  const WireEnumConverter(this.values);

  final List<T> values;

  @override
  T fromSql(String fromDb) => enumFromWire(values, fromDb);

  @override
  String toSql(T value) => value.wire;
}

/// A JSON object column, e.g. parsed SMS fields or a rule's match spec.
class JsonMapConverter extends TypeConverter<Map<String, Object?>, String> {
  const JsonMapConverter();

  @override
  Map<String, Object?> fromSql(String fromDb) =>
      (jsonDecode(fromDb) as Map<String, Object?>?) ?? const {};

  @override
  String toSql(Map<String, Object?> value) => jsonEncode(value);
}

/// A JSON array column, e.g. a list of UPI handles or record ids.
class JsonListConverter extends TypeConverter<List<Object?>, String> {
  const JsonListConverter();

  @override
  List<Object?> fromSql(String fromDb) =>
      (jsonDecode(fromDb) as List<Object?>?) ?? const [];

  @override
  String toSql(List<Object?> value) => jsonEncode(value);
}

/// An IST calendar day stored as `"YYYY-MM-DD"`.
class LocalDateConverter extends TypeConverter<LocalDate, String> {
  const LocalDateConverter();

  @override
  LocalDate fromSql(String fromDb) => LocalDate.parse(fromDb);

  @override
  String toSql(LocalDate value) => value.toIso();
}
