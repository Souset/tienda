// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Chat _$ChatFromJson(Map<String, dynamic> json) => _Chat(
  type: json['type'] as String? ?? 'direct',
  memberUids:
      (json['memberUids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  name: json['name'] as String?,
  lastMessageText: json['lastMessageText'] as String?,
  lastMessageSenderUid: json['lastMessageSenderUid'] as String?,
  lastMessageAt: const NullableTimestampConverter().fromJson(
    json['lastMessageAt'],
  ),
  createdAt: const NullableTimestampConverter().fromJson(json['createdAt']),
);

Map<String, dynamic> _$ChatToJson(_Chat instance) => <String, dynamic>{
  'type': instance.type,
  'memberUids': instance.memberUids,
  'name': instance.name,
  'lastMessageText': instance.lastMessageText,
  'lastMessageSenderUid': instance.lastMessageSenderUid,
  'lastMessageAt': const NullableTimestampConverter().toJson(
    instance.lastMessageAt,
  ),
  'createdAt': const NullableTimestampConverter().toJson(instance.createdAt),
};

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
  senderUid: json['senderUid'] as String? ?? '',
  text: json['text'] as String? ?? '',
  imageUrl: json['imageUrl'] as String?,
  readBy:
      (json['readBy'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  createdAt: const NullableTimestampConverter().fromJson(json['createdAt']),
);

Map<String, dynamic> _$ChatMessageToJson(
  _ChatMessage instance,
) => <String, dynamic>{
  'senderUid': instance.senderUid,
  'text': instance.text,
  'imageUrl': instance.imageUrl,
  'readBy': instance.readBy,
  'createdAt': const NullableTimestampConverter().toJson(instance.createdAt),
};
