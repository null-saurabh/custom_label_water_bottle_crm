// firestore_helpers.dart
import 'package:cloud_firestore/cloud_firestore.dart';

DateTime asDateTime(dynamic v) {
  if (v == null) return DateTime.fromMillisecondsSinceEpoch(0);
  if (v is DateTime) return v;
  if (v is Timestamp) return v.toDate();
  if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
  if (v is String) return DateTime.tryParse(v) ?? DateTime.fromMillisecondsSinceEpoch(0);
  throw ArgumentError('Unsupported date type: ${v.runtimeType}');
}

DateTime? asNullableDateTime(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  if (v is Timestamp) return v.toDate();
  if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
  if (v is String) return DateTime.tryParse(v);
  throw ArgumentError('Unsupported date type: ${v.runtimeType}');
}

double asDouble(dynamic v) {
  if (v == null) return 0.0;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? 0.0;
  throw ArgumentError('Unsupported double type: ${v.runtimeType}');
}

int asInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  if (v is double) return v.round();
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v) ?? 0;
  throw ArgumentError('Unsupported int type: ${v.runtimeType}');
}

T enumFromName<T extends Enum>(List<T> values, dynamic raw, T fallback) {
  if (raw == null) return fallback;
  final s = raw.toString().trim();
  for (final e in values) {
    if (e.name == s) return e;
  }
  return fallback;
}

Timestamp? toTs(DateTime? dt) => dt == null ? null : Timestamp.fromDate(dt);
