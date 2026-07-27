import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters.dart';

part 'friendship.freezed.dart';
part 'friendship.g.dart';

/// Documento `friendships/{id}`: relación de amistad entre dos socios.
@freezed
abstract class Friendship with _$Friendship {
  const Friendship._();

  const factory Friendship({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    @Default(<String>[]) List<String> uids,
    @Default('pending') String status,
    @Default('') String requestedBy,
    @NullableTimestampConverter() DateTime? createdAt,
  }) = _Friendship;

  factory Friendship.fromJson(Map<String, dynamic> json) =>
      _$FriendshipFromJson(json);
}
