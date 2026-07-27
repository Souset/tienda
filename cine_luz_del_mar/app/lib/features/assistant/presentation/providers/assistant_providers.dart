import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/assistant_service.dart';
import '../../domain/assistant_message.dart';

final assistantServiceProvider = Provider<AssistantService>(
  (ref) => AssistantService(),
);

/// Conversación con el asistente: lista de mensajes + estado de escritura.
class AssistantChatState {
  const AssistantChatState({this.messages = const [], this.isTyping = false});

  final List<AssistantMessage> messages;
  final bool isTyping;

  AssistantChatState copyWith({
    List<AssistantMessage>? messages,
    bool? isTyping,
  }) {
    return AssistantChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

class AssistantController extends Notifier<AssistantChatState> {
  @override
  AssistantChatState build() => const AssistantChatState();

  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isTyping) return;

    state = state.copyWith(
      messages: [
        ...state.messages,
        AssistantMessage(text: trimmed, fromUser: true),
      ],
      isTyping: true,
    );

    try {
      final reply = await ref.read(assistantServiceProvider).send(trimmed);
      state = state.copyWith(
        messages: [
          ...state.messages,
          AssistantMessage(text: reply, fromUser: false),
        ],
        isTyping: false,
      );
    } on AppException catch (error) {
      state = state.copyWith(
        messages: [
          ...state.messages,
          AssistantMessage(text: error.message, fromUser: false, isError: true),
        ],
        isTyping: false,
      );
    }
  }

  void clear() {
    ref.read(assistantServiceProvider).reset();
    state = const AssistantChatState();
  }
}

final assistantControllerProvider =
    NotifierProvider<AssistantController, AssistantChatState>(
      AssistantController.new,
    );
