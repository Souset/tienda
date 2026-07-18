// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Venue _$VenueFromJson(Map<String, dynamic> json) => _Venue(
  name: json['name'] as String? ?? '',
  address: json['address'] as String? ?? '',
  lat: (json['lat'] as num?)?.toDouble() ?? 0,
  lng: (json['lng'] as num?)?.toDouble() ?? 0,
  geohash: json['geohash'] as String? ?? '',
);

Map<String, dynamic> _$VenueToJson(_Venue instance) => <String, dynamic>{
  'name': instance.name,
  'address': instance.address,
  'lat': instance.lat,
  'lng': instance.lng,
  'geohash': instance.geohash,
};

_EventItem _$EventItemFromJson(Map<String, dynamic> json) => _EventItem(
  type: json['type'] as String? ?? 'proyeccion',
  title: json['title'] as String? ?? '',
  description: json['description'] as String? ?? '',
  start: const NullableTimestampConverter().fromJson(json['start']),
  end: const NullableTimestampConverter().fromJson(json['end']),
  venue: json['venue'] == null
      ? null
      : Venue.fromJson(json['venue'] as Map<String, dynamic>),
  capacity: (json['capacity'] as num?)?.toInt() ?? 0,
  reservedCount: (json['reservedCount'] as num?)?.toInt() ?? 0,
  coverUrl: json['coverUrl'] as String?,
  filmId: json['filmId'] as String?,
  status: json['status'] as String? ?? 'draft',
  featured: json['featured'] as bool? ?? false,
  searchTokens:
      (json['searchTokens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  createdAt: const NullableTimestampConverter().fromJson(json['createdAt']),
  updatedAt: const NullableTimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$EventItemToJson(
  _EventItem instance,
) => <String, dynamic>{
  'type': instance.type,
  'title': instance.title,
  'description': instance.description,
  'start': const NullableTimestampConverter().toJson(instance.start),
  'end': const NullableTimestampConverter().toJson(instance.end),
  'venue': instance.venue?.toJson(),
  'capacity': instance.capacity,
  'reservedCount': instance.reservedCount,
  'coverUrl': instance.coverUrl,
  'filmId': instance.filmId,
  'status': instance.status,
  'featured': instance.featured,
  'searchTokens': instance.searchTokens,
  'createdAt': const NullableTimestampConverter().toJson(instance.createdAt),
  'updatedAt': const NullableTimestampConverter().toJson(instance.updatedAt),
};

_Reservation _$ReservationFromJson(Map<String, dynamic> json) => _Reservation(
  status: json['status'] as String? ?? 'active',
  userName: json['userName'] as String?,
  createdAt: const NullableTimestampConverter().fromJson(json['createdAt']),
  checkedInAt: const NullableTimestampConverter().fromJson(json['checkedInAt']),
);

Map<String, dynamic> _$ReservationToJson(
  _Reservation instance,
) => <String, dynamic>{
  'status': instance.status,
  'userName': instance.userName,
  'createdAt': const NullableTimestampConverter().toJson(instance.createdAt),
  'checkedInAt': const NullableTimestampConverter().toJson(
    instance.checkedInAt,
  ),
};
