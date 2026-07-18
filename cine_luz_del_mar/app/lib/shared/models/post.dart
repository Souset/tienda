import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters.dart';

part 'post.freezed.dart';
part 'post.g.dart';

/// Documento `posts/{id}`: publicación en el muro social de la asociación.
@freezed
abstract class Post with _$Post {
  const Post._();

  const factory Post({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    @Default('') String authorUid,
    String? authorName,
    String? authorPhotoUrl,
    @Default('') String text,
    @Default(<String>[]) List<String> imageUrls,
    @Default(0) int likesCount,
    @Default(0) int commentsCount,
    @Default('members') String visibility,
    @NullableTimestampConverter() DateTime? createdAt,
    @NullableTimestampConverter() DateTime? updatedAt,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}

/// Documento `posts/{id}/comments/{cid}`: comentario a una publicación.
@freezed
abstract class PostComment with _$PostComment {
  const PostComment._();

  const factory PostComment({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    @Default('') String authorUid,
    String? authorName,
    String? authorPhotoUrl,
    @Default('') String text,
    @NullableTimestampConverter() DateTime? createdAt,
  }) = _PostComment;

  factory PostComment.fromJson(Map<String, dynamic> json) =>
      _$PostCommentFromJson(json);
}
