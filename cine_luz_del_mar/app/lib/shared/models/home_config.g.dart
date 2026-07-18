// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HomeConfig _$HomeConfigFromJson(Map<String, dynamic> json) => _HomeConfig(
  bannerTitle: json['bannerTitle'] as String?,
  bannerSubtitle: json['bannerSubtitle'] as String?,
  bannerImageUrl: json['bannerImageUrl'] as String?,
  bannerRoute: json['bannerRoute'] as String?,
  featuredFilmIds:
      (json['featuredFilmIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  featuredEventIds:
      (json['featuredEventIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  featuredNewsIds:
      (json['featuredNewsIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$HomeConfigToJson(_HomeConfig instance) =>
    <String, dynamic>{
      'bannerTitle': instance.bannerTitle,
      'bannerSubtitle': instance.bannerSubtitle,
      'bannerImageUrl': instance.bannerImageUrl,
      'bannerRoute': instance.bannerRoute,
      'featuredFilmIds': instance.featuredFilmIds,
      'featuredEventIds': instance.featuredEventIds,
      'featuredNewsIds': instance.featuredNewsIds,
    };
