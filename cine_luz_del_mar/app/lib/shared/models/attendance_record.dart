import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters.dart';

part 'attendance_record.freezed.dart';
part 'attendance_record.g.dart';

/// Documento `attendance/{uid}/records/{eventId}`: registro de asistencia de
/// un socio a un evento.
@freezed
abstract class AttendanceRecord with _$AttendanceRecord {
  const AttendanceRecord._();

  const factory AttendanceRecord({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    String? eventTitle,
    String? eventType,
    @NullableTimestampConverter() DateTime? checkedInAt,
  }) = _AttendanceRecord;

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRecordFromJson(json);
}
