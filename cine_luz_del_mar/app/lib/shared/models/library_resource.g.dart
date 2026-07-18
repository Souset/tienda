// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_resource.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LibraryResource _$LibraryResourceFromJson(Map<String, dynamic> json) =>
    _LibraryResource(
      type: json['type'] as String? ?? 'document',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      url: json['url'] as String? ?? '',
      category: json['category'] as String?,
      coverUrl: json['coverUrl'] as String?,
      minRole: json['minRole'] as String? ?? 'invitado',
      searchTokens:
          (json['searchTokens'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      createdAt: const NullableTimestampConverter().fromJson(json['createdAt']),
      updatedAt: const NullableTimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$LibraryResourceToJson(
  _LibraryResource instance,
) => <String, dynamic>{
  'type': instance.type,
  'title': instance.title,
  'description': instance.description,
  'url': instance.url,
  'category': instance.category,
  'coverUrl': instance.coverUrl,
  'minRole': instance.minRole,
  'searchTokens': instance.searchTokens,
  'createdAt': const NullableTimestampConverter().toJson(instance.createdAt),
  'updatedAt': const NullableTimestampConverter().toJson(instance.updatedAt),
};
