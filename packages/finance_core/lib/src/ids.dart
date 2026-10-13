import 'package:uuid/uuid.dart';

const Uuid _uuid = Uuid();

/// A new row id: a UUID v7 string.
///
/// UUID v7 starts with a timestamp, so ids sort by creation time, and they are
/// globally unique, so rows can be merged across devices if sync is ever added.
String newId() => _uuid.v7();
