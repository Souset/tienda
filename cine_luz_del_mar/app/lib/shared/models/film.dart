import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters.dart';

part 'film.freezed.dart';
part 'film.g.dart';

/// Documento `films/{id}`: ficha de película del catálogo.
@freezed
abstract class Film with _$Film {
  const Film._();

  const factory Film({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    @Default('') String title,
    int? year,
    String? director,
    String? synopsis,
    String? posterUrl,
    @Default(<String>[]) List<String> genres,
    @Default(0) double avgRating,
    @Default(0) int ratingsCount,
    @Default(false) bool featured,
    @Default(<String>[]) List<String> searchTokens,
    @NullableTimestampConverter() DateTime? createdAt,
    @NullableTimestampConverter() DateTime? updatedAt,
  }) = _Film;

  factory Film.fromJson(Map<String, dynamic> json) => _$FilmFromJson(json);
}

/// Documento `films/{id}/ratings/{uid}`: valoración de un socio sobre una
/// película.
@freezed
abstract class FilmRating with _$FilmRating {
  const FilmRating._();

  const factory FilmRating({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    @Default(0) double score,
    String? review,
    String? authorName,
    @NullableTimestampConverter() DateTime? createdAt,
  }) = _FilmRating;

  factory FilmRating.fromJson(Map<String, dynamic> json) =>
      _$FilmRatingFromJson(json);
}
