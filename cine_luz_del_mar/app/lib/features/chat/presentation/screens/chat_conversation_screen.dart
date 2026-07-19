import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/widgets/confirm_dialog.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/chat_providers.dart';

/// Conversación de chat con burbujas, lecturas y separadores de día.
class ChatConversationScreen extends ConsumerStatefulWidget {
  const ChatConversationScreen({
    super.key,
    required this.chatId,
    this.other,
    this.isGroup = false,
    this.groupName,
  });

  final String chatId;
  final AppUser? other;
  final bool isGroup;
  final String? groupName;

  @override
  ConsumerState<ChatConversationScreen> createState() =>
      _ChatConversationScreenState();
}

class _ChatConversationScreenState
    extends ConsumerState<ChatConversationScreen> {
  final _controller = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final me = ref.read(currentUserProvider);
    final text = _controller.text.trim();
    if (me == null || text.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      await ref
          .read(chatRepositoryProvider)
          .sendMessage(chatId: widget.chatId, myUid: me.id, text: text);
      _controller.clear();
    } on AppException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _deleteMessage(ChatMessage message) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Borrar mensaje',
      message: 'Se eliminará para todos.',
      confirmLabel: 'Borrar',
      destructive: true,
    );
    if (!ok) return;
    try {
      await ref
          .read(chatRepositoryProvider)
          .deleteMessage(widget.chatId, message.id);
    } on AppException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final me = ref.watch(currentUserProvider);
    final messages = ref.watch(chatMessagesProvider(widget.chatId));

    // Marca como leídos los mensajes ajenos al pintarlos.
    ref.listen(chatMessagesProvider(widget.chatId), (_, next) {
      final list = next.value;
      if (list != null && me != null) {
        ref
            .read(chatRepositoryProvider)
            .markRead(chatId: widget.chatId, myUid: me.id, messages: list);
      }
    });

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            if (widget.isGroup)
              CircleAvatar(radius: 18, child: const Icon(Icons.group, size: 20))
            else
              UserAvatar(
                photoUrl: widget.other?.photoUrl,
                name: widget.other?.displayName ?? 'Chat',
                size: 36,
              ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.isGroup
                    ? (widget.groupName ?? 'Grupo')
                    : (widget.other?.displayName ?? 'Conversación'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text(
                  error is AppException
                      ? error.message
                      : 'No se pudo cargar la conversación',
                ),
              ),
              data: (list) => ListView.builder(
                reverse: true,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final message = list[index];
                  final mine = message.senderUid == me?.id;
                  final showDay =
                      index == list.length - 1 ||
                      !_sameDay(list[index + 1].createdAt, message.createdAt);
                  return Column(
                    children: [
                      if (showDay && message.createdAt != null)
                        _DaySeparator(date: message.createdAt!),
                      _MessageBubble(
                        message: message,
                        mine: mine,
                        showSender: widget.isGroup && !mine,
                        onLongPress: mine
                            ? () => _deleteMessage(message)
                            : null,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: const InputDecoration(
                        hintText: 'Escribe un mensaje…',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _sending ? null : _send,
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

  bool _sameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return true;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _DaySeparator extends StatelessWidget {
  const _DaySeparator({required this.date});

  final DateTime date;

  String _label() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    if (day == today) return 'Hoy';
    if (day == today.subtract(const Duration(days: 1))) return 'Ayer';
    return Formatters.fullDate.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        _label(),
        textAlign: TextAlign.center,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _MessageBubble extends ConsumerWidget {
  const _MessageBubble({
    required this.message,
    required this.mine,
    this.showSender = false,
    this.onLongPress,
  });

  final ChatMessage message;
  final bool mine;
  final bool showSender;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // En grupos, nombre del emisor sobre las burbujas ajenas.
    final sender = showSender
        ? ref.watch(chatUserProvider(message.senderUid)).value
        : null;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: onLongPress,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.75,
          ),
          decoration: BoxDecoration(
            color: mine ? scheme.primary : scheme.surfaceContainerLow,
            border: mine ? null : Border.all(color: scheme.outlineVariant),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(mine ? 16 : 4),
              bottomRight: Radius.circular(mine ? 4 : 16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (sender != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      sender.displayName,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              Text(
                message.text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: mine ? scheme.onPrimary : scheme.onSurface,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (message.createdAt != null)
                    Text(
                      Formatters.time.format(message.createdAt!),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: mine
                            ? scheme.onPrimary.withValues(alpha: 0.7)
                            : scheme.onSurfaceVariant,
                        fontSize: 10,
                      ),
                    ),
                  if (mine && message.readBy.length > 1) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.done_all,
                      size: 14,
                      color: scheme.onPrimary.withValues(alpha: 0.8),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ).animate().fadeIn(duration: 180.ms),
      ),
    );
  }
}
