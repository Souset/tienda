// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'film.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Film _$FilmFromJson(Map<String, dynamic> json) => _Film(
  title: json['title'] as String? ?? '',
  year: (json['year'] as num?)?.toInt(),
  director: json['director'] as String?,
  synopsis: json['synopsis'] as String?,
  posterUrl: json['posterUrl'] as String?,
  genres:
      (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  avgRating: (json['avgRating'] as num?)?.toDouble() ?? 0,
  ratingsCount: (json['ratingsCount'] as num?)?.toInt() ?? 0,
  featured: json['featured'] as bool? ?? false,
  searchTokens:
      (json['searchTokens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  createdAt: const NullableTimestampConverter().fromJson(json['createdAt']),
  updatedAt: const NullableTimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$FilmToJson(_Film instance) => <String, dynamic>{
  'title': instance.title,
  'year': instance.year,
  'director': instance.director,
  'synopsis': instance.synopsis,
  'posterUrl': instance.posterUrl,
  'genres': instance.genres,
  'avgRating': instance.avgRating,
  'ratingsCount': instance.ratingsCount,
  'featured': instance.featured,
  'searchTokens': instance.searchTokens,
  'createdAt': const NullableTimestampConverter().toJson(instance.createdAt),
  'updatedAt': const NullableTimestampConverter().toJson(instance.updatedAt),
};

_FilmRating _$FilmRatingFromJson(Map<String, dynamic> json) => _FilmRating(
  score: (json['score'] as num?)?.toDouble() ?? 0,
  review: json['review'] as String?,
  authorName: json['authorName'] as String?,
  createdAt: const NullableTimestampConverter().fromJson(json['createdAt']),
);

Map<String, dynamic> _$FilmRatingToJson(
  _FilmRating instance,
) => <String, dynamic>{
  'score': instance.score,
  'review': instance.review,
  'authorName': instance.authorName,
  'createdAt': const NullableTimestampConverter().toJson(instance.createdAt),
};
