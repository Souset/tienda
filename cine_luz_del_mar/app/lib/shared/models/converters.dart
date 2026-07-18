import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

/// Conversión Firestore Timestamp <-> DateTime para modelos freezed.
///
/// Acepta también ISO-8601 (seeds/tests) y milisegundos epoch. Serializa
/// siempre a Timestamp para que Firestore indexe fechas nativamente.
class TimestampConverter implements JsonConverter<DateTime, Object> {
  const TimestampConverter();

  @override
  DateTime fromJson(Object json) => switch (json) {
    Timestamp t => t.toDate(),
    String s => DateTime.parse(s),
    int ms => DateTime.fromMillisecondsSinceEpoch(ms),
    _ => throw ArgumentError('Fecha no reconocida: $json'),
  };

  @override
  Object toJson(DateTime date) => Timestamp.fromDate(date);
}

class NullableTimestampConverter implements JsonConverter<DateTime?, Object?> {
  const NullableTimestampConverter();

  @override
  DateTime? fromJson(Object? json) =>
      json == null ? null : const TimestampConverter().fromJson(json);

  @override
  Object? toJson(DateTime? date) =>
      date == null ? null : Timestamp.fromDate(date);
}
