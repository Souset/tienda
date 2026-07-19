import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/widgets/brand_wordmark.dart';
import '../../domain/assistant_message.dart';
import '../providers/assistant_providers.dart';

/// Chat con el asistente de IA de la asociación (Gemini).
class AssistantScreen extends ConsumerStatefulWidget {
  const AssistantScreen({super.key});

  @override
  ConsumerState<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends ConsumerState<AssistantScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  static const suggestions = [
    '¿Qué actividades hay próximamente?',
    'Recomiéndame una película',
    '¿Cómo me hago socio?',
    'Resume las últimas noticias',
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send([String? text]) {
    final message = text ?? _controller.text;
    if (message.trim().isEmpty) return;
    _controller.clear();
    ref.read(assistantControllerProvider.notifier).send(message);
    // Baja al final cuando el frame ya incluye el mensaje nuevo.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chat = ref.watch(assistantControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistente'),
        actions: [
          if (chat.messages.isNotEmpty)
            IconButton(
              tooltip: 'Nueva conversación',
              icon: const Icon(Icons.refresh_rounded),
              onPressed: () =>
                  ref.read(assistantControllerProvider.notifier).clear(),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: chat.messages.isEmpty
                ? _Welcome(onSuggestion: _send)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    itemCount: chat.messages.length + (chat.isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == chat.messages.length) {
                        return const _TypingIndicator();
                      }
                      return _Bubble(message: chat.messages[index]);
                    },
                  ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      enabled: !chat.isTyping,
                      decoration: const InputDecoration(
                        hintText: 'Pregunta lo que quieras…',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: chat.isTyping ? null : _send,
                    icon: const Icon(Icons.arrow_upward_rounded),
                    tooltip: 'Enviar',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Welcome extends StatelessWidget {
  const _Welcome({required this.onSuggestion});

  final ValueChanged<String> onSuggestion;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BrandWordmark(fontSize: 40),
            const SizedBox(height: 12),
            Text(
              'Pregúntame por la agenda, las películas\no cualquier cosa de la asociación.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                for (final s in _AssistantScreenState.suggestions)
                  ActionChip(label: Text(s), onPressed: () => onSuggestion(s)),
              ],
            ),
          ],
        ).animate().fadeIn(duration: 350.ms).moveY(begin: 16, end: 0),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});

  final AssistantMessage message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final fromUser = message.fromUser;

    return Align(
      alignment: fromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        decoration: BoxDecoration(
          color: fromUser ? scheme.primary : scheme.surfaceContainerLow,
          border: fromUser
              ? null
              : Border.all(
                  color: message.isError ? scheme.error : scheme.outlineVariant,
                ),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(fromUser ? 16 : 4),
            bottomRight: Radius.circular(fromUser ? 4 : 16),
          ),
        ),
        child: SelectableText(
          message.text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: fromUser ? scheme.onPrimary : scheme.onSurface,
            height: 1.45,
          ),
        ),
      ).animate().fadeIn(duration: 200.ms).moveY(begin: 6, end: 0),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLow,
          border: Border.all(color: scheme.outlineVariant),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < 3; i++)
              Container(
                    width: 7,
                    height: 7,
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    decoration: BoxDecoration(
                      color: scheme.onSurfaceVariant,
                      shape: BoxShape.circle,
                    ),
                  )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .fade(
                    begin: 0.25,
                    end: 1,
                    duration: 500.ms,
                    delay: (i * 160).ms,
                  ),
          ],
        ),
      ),
    );
  }
}
