// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    _AppNotification(
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      type: json['type'] as String? ?? 'general',
      route: json['route'] as String?,
      read: json['read'] as bool? ?? false,
      createdAt: const NullableTimestampConverter().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$AppNotificationToJson(
  _AppNotification instance,
) => <String, dynamic>{
  'title': instance.title,
  'body': instance.body,
  'type': instance.type,
  'route': instance.route,
  'read': instance.read,
  'createdAt': const NullableTimestampConverter().toJson(instance.createdAt),
};
