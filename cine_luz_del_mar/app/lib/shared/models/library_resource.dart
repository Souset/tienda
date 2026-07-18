import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters.dart';

part 'library_resource.freezed.dart';
part 'library_resource.g.dart';

/// Documento `library/{id}`: recurso de la biblioteca (documento, podcast,
/// vídeo o enlace).
@freezed
abstract class LibraryResource with _$LibraryResource {
  const LibraryResource._();

  const factory LibraryResource({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,

    /// Tipo de recurso: `document` | `podcast` | `video` | `link`.
    @Default('document') String type,
    @Default('') String title,
    String? description,
    @Default('') String url,
    String? category,
    String? coverUrl,
    @Default('invitado') String minRole,
    @Default(<String>[]) List<String> searchTokens,
    @NullableTimestampConverter() DateTime? createdAt,
    @NullableTimestampConverter() DateTime? updatedAt,
  }) = _LibraryResource;

  factory LibraryResource.fromJson(Map<String, dynamic> json) =>
      _$LibraryResourceFromJson(json);
}
