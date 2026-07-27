// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceRecord _$AttendanceRecordFromJson(Map<String, dynamic> json) =>
    _AttendanceRecord(
      eventTitle: json['eventTitle'] as String?,
      eventType: json['eventType'] as String?,
      checkedInAt: const NullableTimestampConverter().fromJson(
        json['checkedInAt'],
      ),
    );

Map<String, dynamic> _$AttendanceRecordToJson(_AttendanceRecord instance) =>
    <String, dynamic>{
      'eventTitle': instance.eventTitle,
      'eventType': instance.eventType,
      'checkedInAt': const NullableTimestampConverter().toJson(
        instance.checkedInAt,
      ),
    };
