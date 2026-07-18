// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  displayName: json['displayName'] as String? ?? '',
  email: json['email'] as String? ?? '',
  photoUrl: json['photoUrl'] as String?,
  role: json['role'] as String? ?? 'invitado',
  bio: json['bio'] as String?,
  favoriteGenres:
      (json['favoriteGenres'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  fcmTokens:
      (json['fcmTokens'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  favoriteFilms:
      (json['favoriteFilms'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  favoriteEvents:
      (json['favoriteEvents'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  favoriteResources:
      (json['favoriteResources'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  searchTokens:
      (json['searchTokens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  createdAt: const NullableTimestampConverter().fromJson(json['createdAt']),
  updatedAt: const NullableTimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'displayName': instance.displayName,
  'email': instance.email,
  'photoUrl': instance.photoUrl,
  'role': instance.role,
  'bio': instance.bio,
  'favoriteGenres': instance.favoriteGenres,
  'fcmTokens': instance.fcmTokens,
  'favoriteFilms': instance.favoriteFilms,
  'favoriteEvents': instance.favoriteEvents,
  'favoriteResources': instance.favoriteResources,
  'searchTokens': instance.searchTokens,
  'createdAt': const NullableTimestampConverter().toJson(instance.createdAt),
  'updatedAt': const NullableTimestampConverter().toJson(instance.updatedAt),
};
