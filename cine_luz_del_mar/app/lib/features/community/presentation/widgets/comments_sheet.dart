import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/config/user_role.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_shimmer.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/community_providers.dart';

/// Abre el bottom sheet de comentarios de una publicación.
Future<void> showCommentsSheet(BuildContext context, String postId) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => _CommentsSheet(postId: postId),
  );
}

/// Hoja de comentarios: lista de comentarios y campo para escribir uno nuevo.
class _CommentsSheet extends ConsumerStatefulWidget {
  const _CommentsSheet({required this.postId});

  final String postId;

  @override
  ConsumerState<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends ConsumerState<_CommentsSheet> {
  final _controller = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    final user = ref.read(currentUserProvider);
    if (text.isEmpty || user == null) return;

    setState(() => _sending = true);
    await ref
        .read(communityControllerProvider.notifier)
        .addComment(postId: widget.postId, author: user, text: text);
    if (!mounted) return;
    setState(() => _sending = false);

    final state = ref.read(communityControllerProvider);
    if (state.hasError) {
      _showError(state.error);
    } else {
      _controller.clear();
    }
  }

  Future<void> _delete(String commentId) async {
    await ref
        .read(communityControllerProvider.notifier)
        .deleteComment(widget.postId, commentId);
    if (!mounted) return;
    final state = ref.read(communityControllerProvider);
    if (state.hasError) _showError(state.error);
  }

  void _showError(Object? error) {
    final message = error is AppException
        ? error.message
        : 'No se pudo completar la acción';
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);
    final role = ref.watch(currentRoleProvider);
    final canComment = role.atLeast(UserRole.socio);
    final commentsAsync = ref.watch(commentsProvider(widget.postId));

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Text('Comentarios', style: theme.textTheme.titleMedium),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: commentsAsync.when(
                  loading: () =>
                      const ShimmerList(itemCount: 4, itemHeight: 64),
                  error: (error, _) => ErrorView(
                    error: error,
                    onRetry: () =>
                        ref.invalidate(commentsProvider(widget.postId)),
                  ),
                  data: (comments) {
                    if (comments.isEmpty) {
                      return const EmptyState(
                        icon: Icons.mode_comment_outlined,
                        title: 'Sin comentarios',
                        message: 'Sé la primera persona en comentar.',
                      );
                    }
                    return ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.all(20),
                      itemCount: comments.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        final mine = comment.authorUid == user?.id;
                        final canDelete = mine || role.canManageMembers;
                        return _CommentTile(
                          authorName: comment.authorName,
                          authorPhotoUrl: comment.authorPhotoUrl,
                          text: comment.text,
                          createdAt: comment.createdAt,
                          onDelete: canDelete
                              ? () => _delete(comment.id)
                              : null,
                        );
                      },
                    );
                  },
                ),
              ),
              if (canComment && user != null) ...[
                const Divider(height: 1),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            minLines: 1,
                            maxLines: 4,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              hintText: 'Escribe un comentario…',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filled(
                          onPressed: _sending ? null : _send,
                          icon: _sending
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.send_rounded),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

/// Fila de un comentario individual: avatar, nombre, texto y fecha relativa.
class _CommentTile extends StatelessWidget {
  const _CommentTile({
    required this.authorName,
    required this.authorPhotoUrl,
    required this.text,
    required this.createdAt,
    this.onDelete,
  });

  final String? authorName;
  final String? authorPhotoUrl;
  final String text;
  final DateTime? createdAt;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserAvatar(photoUrl: authorPhotoUrl, name: authorName, size: 36),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      authorName ?? 'Socio',
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                  if (createdAt != null)
                    Text(
                      Formatters.relative(createdAt!),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(text, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
        if (onDelete != null)
          IconButton(
            visualDensity: VisualDensity.compact,
            iconSize: 18,
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Borrar comentario',
          ),
      ],
    );
  }
}
