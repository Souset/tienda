// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Post _$PostFromJson(Map<String, dynamic> json) => _Post(
  authorUid: json['authorUid'] as String? ?? '',
  authorName: json['authorName'] as String?,
  authorPhotoUrl: json['authorPhotoUrl'] as String?,
  text: json['text'] as String? ?? '',
  imageUrls:
      (json['imageUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
  commentsCount: (json['commentsCount'] as num?)?.toInt() ?? 0,
  visibility: json['visibility'] as String? ?? 'members',
  createdAt: const NullableTimestampConverter().fromJson(json['createdAt']),
  updatedAt: const NullableTimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$PostToJson(_Post instance) => <String, dynamic>{
  'authorUid': instance.authorUid,
  'authorName': instance.authorName,
  'authorPhotoUrl': instance.authorPhotoUrl,
  'text': instance.text,
  'imageUrls': instance.imageUrls,
  'likesCount': instance.likesCount,
  'commentsCount': instance.commentsCount,
  'visibility': instance.visibility,
  'createdAt': const NullableTimestampConverter().toJson(instance.createdAt),
  'updatedAt': const NullableTimestampConverter().toJson(instance.updatedAt),
};

_PostComment _$PostCommentFromJson(Map<String, dynamic> json) => _PostComment(
  authorUid: json['authorUid'] as String? ?? '',
  authorName: json['authorName'] as String?,
  authorPhotoUrl: json['authorPhotoUrl'] as String?,
  text: json['text'] as String? ?? '',
  createdAt: const NullableTimestampConverter().fromJson(json['createdAt']),
);

Map<String, dynamic> _$PostCommentToJson(
  _PostComment instance,
) => <String, dynamic>{
  'authorUid': instance.authorUid,
  'authorName': instance.authorName,
  'authorPhotoUrl': instance.authorPhotoUrl,
  'text': instance.text,
  'createdAt': const NullableTimestampConverter().toJson(instance.createdAt),
};
