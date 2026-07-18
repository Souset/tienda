// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NewsItem _$NewsItemFromJson(Map<String, dynamic> json) => _NewsItem(
  title: json['title'] as String? ?? '',
  body: json['body'] as String? ?? '',
  coverUrl: json['coverUrl'] as String?,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  featured: json['featured'] as bool? ?? false,
  status: json['status'] as String? ?? 'draft',
  publishedAt: const NullableTimestampConverter().fromJson(json['publishedAt']),
  authorUid: json['authorUid'] as String? ?? '',
  searchTokens:
      (json['searchTokens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  createdAt: const NullableTimestampConverter().fromJson(json['createdAt']),
  updatedAt: const NullableTimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$NewsItemToJson(_NewsItem instance) => <String, dynamic>{
  'title': instance.title,
  'body': instance.body,
  'coverUrl': instance.coverUrl,
  'tags': instance.tags,
  'featured': instance.featured,
  'status': instance.status,
  'publishedAt': const NullableTimestampConverter().toJson(
    instance.publishedAt,
  ),
  'authorUid': instance.authorUid,
  'searchTokens': instance.searchTokens,
  'createdAt': const NullableTimestampConverter().toJson(instance.createdAt),
  'updatedAt': const NullableTimestampConverter().toJson(instance.updatedAt),
};
