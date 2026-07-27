import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/widgets/app_shimmer.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/content_width.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/chat_providers.dart';
import 'chat_conversation_screen.dart';

/// Lista de conversaciones del usuario.
class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  Future<void> _newChat(BuildContext context, WidgetRef ref) async {
    final me = ref.read(currentUserProvider);
    if (me == null) return;

    // Elegir tipo de conversación.
    final type = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Chat directo'),
              subtitle: const Text('Conversación con una persona'),
              onTap: () => Navigator.of(context).pop('direct'),
            ),
            ListTile(
              leading: const Icon(Icons.group_outlined),
              title: const Text('Grupo'),
              subtitle: const Text('Con nombre y varias personas'),
              onTap: () => Navigator.of(context).pop('group'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (type == null || !context.mounted) return;

    List<AppUser> users;
    try {
      users = await ref.read(chatRepositoryProvider).listUsers(limit: 50);
    } on AppException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
      return;
    }
    users.removeWhere((u) => u.id == me.id);
    if (!context.mounted) return;

    if (type == 'group') {
      final result =
          await showModalBottomSheet<({String name, List<String> uids})>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            showDragHandle: true,
            builder: (context) => _GroupCreator(users: users),
          );
      if (result == null || !context.mounted) return;
      try {
        final chatId = await ref
            .read(chatRepositoryProvider)
            .createGroupChat(
              myUid: me.id,
              name: result.name,
              memberUids: result.uids,
            );
        if (context.mounted) {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ChatConversationScreen(
                chatId: chatId,
                isGroup: true,
                groupName: result.name,
              ),
            ),
          );
        }
      } on AppException catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.message)));
        }
      }
      return;
    }

    final selected = await showModalBottomSheet<AppUser>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => _UserPicker(users: users),
    );
    if (selected == null || !context.mounted) return;

    try {
      final chatId = await ref
          .read(chatRepositoryProvider)
          .openDirectChat(myUid: me.id, otherUid: selected.id);
      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) =>
                ChatConversationScreen(chatId: chatId, other: selected),
          ),
        );
      }
    } on AppException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final me = ref.watch(currentUserProvider);
    final chats = ref.watch(myChatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          IconButton(
            tooltip: 'Nuevo chat',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _newChat(context, ref),
          ),
        ],
      ),
      body: ContentColumn(
        child: chats.when(
          loading: () => const ShimmerList(itemHeight: 72),
          error: (error, _) => ErrorView(
            error: error,
            onRetry: () => ref.invalidate(myChatsProvider),
          ),
          data: (list) => list.isEmpty
              ? const EmptyState(
                  icon: Icons.chat_bubble_outline,
                  title: 'Aún no tienes conversaciones',
                  message: 'Empieza una con el lápiz de arriba.',
                )
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) =>
                      _ChatTile(chat: list[index], myUid: me?.id ?? ''),
                ),
        ),
      ),
    );
  }
}

class _ChatTile extends ConsumerWidget {
  const _ChatTile({required this.chat, required this.myUid});

  final Chat chat;
  final String myUid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isGroup = chat.type == 'group';
    final otherUid = isGroup
        ? null
        : chat.memberUids.firstWhere((u) => u != myUid, orElse: () => myUid);
    final other = otherUid == null
        ? null
        : ref.watch(chatUserProvider(otherUid)).value;

    final title = isGroup
        ? (chat.name ?? 'Grupo')
        : (other?.displayName ?? '…');
    final lastIsMine = chat.lastMessageSenderUid == myUid;
    final unread = chat.lastMessageText != null && !lastIsMine;

    return ListTile(
      leading: isGroup
          ? CircleAvatar(
              radius: 22,
              backgroundColor: theme.colorScheme.surfaceContainerHigh,
              child: const Icon(Icons.group),
            )
          : UserAvatar(
              photoUrl: other?.photoUrl,
              name: other?.displayName ?? '',
              size: 44,
            ),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: chat.lastMessageText == null
          ? null
          : Text(
              '${lastIsMine ? 'Tú: ' : ''}${chat.lastMessageText}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: unread ? FontWeight.w600 : null,
              ),
            ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (chat.lastMessageAt != null)
            Text(
              Formatters.relative(chat.lastMessageAt!),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          if (unread) ...[
            const SizedBox(height: 6),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ChatConversationScreen(
            chatId: chat.id,
            other: other,
            isGroup: isGroup,
            groupName: chat.name,
          ),
        ),
      ),
    );
  }
}

/// Creación de grupo: nombre + selección múltiple de personas.
class _GroupCreator extends StatefulWidget {
  const _GroupCreator({required this.users});

  final List<AppUser> users;

  @override
  State<_GroupCreator> createState() => _GroupCreatorState();
}

class _GroupCreatorState extends State<_GroupCreator> {
  final _name = TextEditingController();
  final Set<String> _selected = {};
  String _filter = '';

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.users
        .where(
          (u) => u.displayName.toLowerCase().contains(_filter.toLowerCase()),
        )
        .toList();
    final canCreate = _name.text.trim().isNotEmpty && _selected.isNotEmpty;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: TextField(
              controller: _name,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Nombre del grupo',
                hintText: 'Taller de guion 2026',
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar personas…',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => _filter = value),
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final user in filtered.take(30))
                  CheckboxListTile(
                    value: _selected.contains(user.id),
                    onChanged: (checked) => setState(() {
                      checked == true
                          ? _selected.add(user.id)
                          : _selected.remove(user.id);
                    }),
                    secondary: UserAvatar(
                      photoUrl: user.photoUrl,
                      name: user.displayName,
                      size: 36,
                    ),
                    title: Text(user.displayName),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: canCreate
                    ? () => Navigator.of(
                        context,
                      ).pop((name: _name.text.trim(), uids: _selected.toList()))
                    : null,
                child: Text(
                  _selected.isEmpty
                      ? 'Elige participantes'
                      : 'Crear grupo (${_selected.length})',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserPicker extends StatefulWidget {
  const _UserPicker({required this.users});

  final List<AppUser> users;

  @override
  State<_UserPicker> createState() => _UserPickerState();
}

class _UserPickerState extends State<_UserPicker> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.users
        .where(
          (u) => u.displayName.toLowerCase().contains(_filter.toLowerCase()),
        )
        .toList();
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Buscar persona…',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => _filter = value),
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final user in filtered.take(20))
                  ListTile(
                    leading: UserAvatar(
                      photoUrl: user.photoUrl,
                      name: user.displayName,
                      size: 40,
                    ),
                    title: Text(user.displayName),
                    subtitle: Text(user.userRole.label),
                    onTap: () => Navigator.of(context).pop(user),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
