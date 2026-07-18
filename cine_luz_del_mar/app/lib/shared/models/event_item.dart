import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters.dart';

part 'event_item.freezed.dart';
part 'event_item.g.dart';

/// Objeto embebido en [EventItem]: ubicación física del evento.
@freezed
abstract class Venue with _$Venue {
  const Venue._();

  const factory Venue({
    @Default('') String name,
    @Default('') String address,
    @Default(0) double lat,
    @Default(0) double lng,
    @Default('') String geohash,
  }) = _Venue;

  factory Venue.fromJson(Map<String, dynamic> json) => _$VenueFromJson(json);
}

/// Documento `events/{id}`: proyección, taller u otro evento organizado.
@freezed
abstract class EventItem with _$EventItem {
  const EventItem._();

  // Usa `explicitToJson` porque embebe [Venue], otro objeto freezed: sin
  // esto, `toJson` escribiría la instancia de Venue tal cual en vez de su
  // Map. El analizador no reconoce este uso sobre el factory (es el patrón
  // documentado por freezed), de ahí el ignore puntual.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory EventItem({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    @Default('proyeccion') String type,
    @Default('') String title,
    @Default('') String description,
    @NullableTimestampConverter() DateTime? start,
    @NullableTimestampConverter() DateTime? end,
    Venue? venue,
    @Default(0) int capacity,
    @Default(0) int reservedCount,
    String? coverUrl,
    String? filmId,
    @Default('draft') String status,
    @Default(false) bool featured,
    @Default(<String>[]) List<String> searchTokens,
    @NullableTimestampConverter() DateTime? createdAt,
    @NullableTimestampConverter() DateTime? updatedAt,
  }) = _EventItem;

  factory EventItem.fromJson(Map<String, dynamic> json) =>
      _$EventItemFromJson(json);
}

/// Documento `events/{id}/reservations/{uid}`: reserva de plaza de un socio.
@freezed
abstract class Reservation with _$Reservation {
  const Reservation._();

  const factory Reservation({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    @Default('active') String status,
    String? userName,
    @NullableTimestampConverter() DateTime? createdAt,
    @NullableTimestampConverter() DateTime? checkedInAt,
  }) = _Reservation;

  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);
}
