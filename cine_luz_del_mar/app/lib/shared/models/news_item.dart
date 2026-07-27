import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters.dart';

part 'news_item.freezed.dart';
part 'news_item.g.dart';

/// Documento `news/{id}`: noticia/artículo publicado por la asociación.
@freezed
abstract class NewsItem with _$NewsItem {
  const NewsItem._();

  const factory NewsItem({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    @Default('') String title,
    @Default('') String body,
    String? coverUrl,
    @Default(<String>[]) List<String> tags,
    @Default(false) bool featured,
    @Default('draft') String status,
    @NullableTimestampConverter() DateTime? publishedAt,
    @Default('') String authorUid,
    @Default(<String>[]) List<String> searchTokens,
    @NullableTimestampConverter() DateTime? createdAt,
    @NullableTimestampConverter() DateTime? updatedAt,
  }) = _NewsItem;

  factory NewsItem.fromJson(Map<String, dynamic> json) =>
      _$NewsItemFromJson(json);
}
