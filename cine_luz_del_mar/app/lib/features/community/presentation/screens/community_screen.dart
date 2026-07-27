import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/config/user_role.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/widgets/app_shimmer.dart';
import '../../../../shared/widgets/confirm_dialog.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/content_width.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/community_providers.dart';
import '../widgets/comments_sheet.dart';
import 'create_post_screen.dart';
import 'friends_screen.dart';

/// Comunidad: muro de publicaciones de la asociación.
class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final role = ref.watch(currentRoleProvider);
    final verified = ref.watch(emailVerifiedProvider);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Comunidad')),
        body: EmptyState(
          icon: Icons.forum_outlined,
          title: 'La comunidad es para gente del cine',
          message:
              'Inicia sesión para ver las publicaciones, comentar y '
              'conocer al resto de la asociación.',
          actionLabel: 'Iniciar sesión',
          onAction: () => context.go('/acceso'),
        ),
      );
    }

    final feed = ref.watch(feedProvider);
    final canPost = role.atLeast(UserRole.socio) && verified;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunidad'),
        actions: [
          IconButton(
            tooltip: 'Amigos',
            icon: const Icon(Icons.group_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const FriendsScreen()),
            ),
          ),
        ],
      ),
      floatingActionButton: canPost
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const CreatePostScreen(),
                ),
              ),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Publicar'),
            )
          : null,
      body: feed.when(
        loading: () =>
            const ShimmerList(itemHeight: 160, maxWidth: ContentWidth.list),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(feedProvider),
        ),
        data: (posts) {
          if (posts.isEmpty) {
            return const EmptyState(
              icon: Icons.forum_outlined,
              title: 'Todavía no hay publicaciones',
              message:
                  'Sé la primera persona en compartir algo con la comunidad.',
            );
          }
          final showBanner = !role.atLeast(UserRole.socio);
          return ContentColumn(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
              itemCount: posts.length + (showBanner ? 1 : 0),
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (showBanner && index == 0) return const _GuestBanner();
                final post = posts[showBanner ? index - 1 : index];
                return _PostCard(post: post).animate().fadeIn(duration: 250.ms);
              },
            ),
          );
        },
      ),
    );
  }
}

class _GuestBanner extends StatelessWidget {
  const _GuestBanner();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Row(
        children: [
          const Icon(Icons.badge_outlined),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Hazte socio para publicar y comentar',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta de publicación con autor, texto, imágenes y acciones.
class _PostCard extends ConsumerWidget {
  const _PostCard({required this.post});

  final Post post;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Borrar publicación',
      message: 'Esta acción no se puede deshacer.',
      confirmLabel: 'Borrar',
      destructive: true,
    );
    if (!ok) return;
    try {
      await ref.read(communityControllerProvider.notifier).deletePost(post.id);
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
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);
    final role = ref.watch(currentRoleProvider);
    final liked = ref.watch(myLikeProvider(post.id)).value ?? false;
    final isAuthor = user?.id == post.authorUid;
    final canModerate = isAuthor || role.canManageMembers;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                UserAvatar(
                  photoUrl: post.authorPhotoUrl,
                  name: post.authorName ?? '',
                  size: 40,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName ?? 'Alguien de la asociación',
                        style: theme.textTheme.titleSmall,
                      ),
                      if (post.createdAt != null)
                        Text(
                          Formatters.relative(post.createdAt!),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                if (canModerate)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'delete') _delete(context, ref);
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'delete', child: Text('Borrar')),
                    ],
                  ),
              ],
            ),
            if (post.text.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(post.text, style: theme.textTheme.bodyMedium),
            ],
            if (post.imageUrls.isNotEmpty) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                child: post.imageUrls.length == 1
                    ? AspectRatio(
                        aspectRatio: 16 / 9,
                        child: CachedNetworkImage(
                          imageUrl: post.imageUrls.first,
                          fit: BoxFit.cover,
                          placeholder: (_, _) =>
                              const AppShimmer(height: 180, radius: 0),
                          errorWidget: (_, _, _) => Container(
                            color: theme.colorScheme.surfaceContainer,
                            child: const Icon(Icons.broken_image_outlined),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 200,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: post.imageUrls.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 8),
                          itemBuilder: (_, i) => ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusS,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: post.imageUrls[i],
                              width: 260,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                _ActionButton(
                  icon: liked ? Icons.favorite : Icons.favorite_border,
                  label: '${post.likesCount}',
                  onTap: user == null
                      ? null
                      : () => ref
                            .read(communityControllerProvider.notifier)
                            .toggleLike(
                              postId: post.id,
                              uid: user.id,
                              currentlyLiked: liked,
                            ),
                ),
                const SizedBox(width: 16),
                _ActionButton(
                  icon: Icons.mode_comment_outlined,
                  label: '${post.commentsCount}',
                  onTap: () => showCommentsSheet(context, post.id),
                ),
                const Spacer(),
                if (post.visibility == 'public')
                  Icon(
                    Icons.public,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 6),
            Text(label, style: theme.textTheme.labelMedium),
          ],
        ),
      ),
    );
  }
}
