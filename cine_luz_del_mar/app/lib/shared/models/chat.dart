import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

/// Documento `chats/{id}`: conversación directa o grupal entre socios.
@freezed
abstract class Chat with _$Chat {
  const Chat._();

  const factory Chat({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,

    /// Tipo de chat: `direct` | `group`.
    @Default('direct') String type,
    @Default(<String>[]) List<String> memberUids,
    String? name,
    String? lastMessageText,
    String? lastMessageSenderUid,
    @NullableTimestampConverter() DateTime? lastMessageAt,
    @NullableTimestampConverter() DateTime? createdAt,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
}

/// Documento `chats/{id}/messages/{mid}`: mensaje individual de un chat.
@freezed
abstract class ChatMessage with _$ChatMessage {
  const ChatMessage._();

  const factory ChatMessage({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    @Default('') String senderUid,
    @Default('') String text,
    String? imageUrl,
    @Default(<String>[]) List<String> readBy,
    @NullableTimestampConverter() DateTime? createdAt,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}
