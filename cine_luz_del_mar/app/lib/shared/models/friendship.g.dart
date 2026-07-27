// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friendship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Friendship _$FriendshipFromJson(Map<String, dynamic> json) => _Friendship(
  uids:
      (json['uids'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  status: json['status'] as String? ?? 'pending',
  requestedBy: json['requestedBy'] as String? ?? '',
  createdAt: const NullableTimestampConverter().fromJson(json['createdAt']),
);

Map<String, dynamic> _$FriendshipToJson(
  _Friendship instance,
) => <String, dynamic>{
  'uids': instance.uids,
  'status': instance.status,
  'requestedBy': instance.requestedBy,
  'createdAt': const NullableTimestampConverter().toJson(instance.createdAt),
};
