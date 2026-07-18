import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters.dart';

part 'app_notification.freezed.dart';
part 'app_notification.g.dart';

/// Documento `notifications/{uid}/items/{id}`: notificación enviada a un
/// usuario.
@freezed
abstract class AppNotification with _$AppNotification {
  const AppNotification._();

  const factory AppNotification({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    @Default('') String title,
    @Default('') String body,
    @Default('general') String type,
    String? route,
    @Default(false) bool read,
    @NullableTimestampConverter() DateTime? createdAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}
