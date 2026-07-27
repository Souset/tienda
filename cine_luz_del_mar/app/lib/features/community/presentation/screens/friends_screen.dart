import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/content_width.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/app_shimmer.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/community_providers.dart';

/// Amigos: amistades aceptadas y solicitudes pendientes.
class FriendsScreen extends ConsumerWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) return const SizedBox.shrink();

    final friendships = ref.watch(friendshipsProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Amigos'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Amigos'),
              Tab(text: 'Solicitudes'),
            ],
          ),
        ),
        body: ContentColumn(
          child: friendships.when(
            loading: () => const ShimmerList(),
            error: (error, _) => ErrorView(
              error: error,
              onRetry: () => ref.invalidate(friendshipsProvider),
            ),
            data: (all) {
              final accepted = all
                  .where((f) => f.status == 'accepted')
                  .toList();
              final pending = all.where((f) => f.status == 'pending').toList();
              return TabBarView(
                children: [
                  accepted.isEmpty
                      ? const EmptyState(
                          icon: Icons.group_outlined,
                          title: 'Todavía no tienes amigos aquí',
                          message:
                              'Añade a otras personas desde sus '
                              'publicaciones en la comunidad.',
                        )
                      : ListView(
                          children: [
                            for (final f in accepted)
                              _FriendTile(friendship: f, myUid: user.id),
                          ],
                        ),
                  pending.isEmpty
                      ? const EmptyState(
                          icon: Icons.mark_email_unread_outlined,
                          title: 'Sin solicitudes pendientes',
                        )
                      : ListView(
                          children: [
                            for (final f in pending)
                              _FriendTile(friendship: f, myUid: user.id),
                          ],
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FriendTile extends ConsumerWidget {
  const _FriendTile({required this.friendship, required this.myUid});

  final Friendship friendship;
  final String myUid;

  Future<void> _run(
    BuildContext context,
    Future<void> Function() action,
  ) async {
    try {
      await action();
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
    final otherUid = friendship.uids.firstWhere(
      (uid) => uid != myUid,
      orElse: () => myUid,
    );
    final other = ref.watch(userProfileProvider(otherUid)).value;
    final controller = ref.read(communityControllerProvider.notifier);
    final isPending = friendship.status == 'pending';
    final iRequested = friendship.requestedBy == myUid;

    return ListTile(
      leading: UserAvatar(
        photoUrl: other?.photoUrl,
        name: other?.displayName ?? '…',
        size: 44,
      ),
      title: Text(other?.displayName ?? 'Cargando…'),
      subtitle: isPending
          ? Text(iRequested ? 'Solicitud enviada' : 'Quiere ser tu amigo')
          : Text(other?.userRole.label ?? ''),
      trailing: isPending && !iRequested
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Aceptar',
                  icon: const Icon(Icons.check_circle_outline),
                  onPressed: () => _run(
                    context,
                    () => controller.acceptFriendship(friendship.id),
                  ),
                ),
                IconButton(
                  tooltip: 'Rechazar',
                  icon: const Icon(Icons.cancel_outlined),
                  onPressed: () => _run(
                    context,
                    () => controller.removeFriendship(friendship.id),
                  ),
                ),
              ],
            )
          : IconButton(
              tooltip: isPending ? 'Cancelar solicitud' : 'Eliminar amistad',
              icon: const Icon(Icons.person_remove_outlined),
              onPressed: () => _run(
                context,
                () => controller.removeFriendship(friendship.id),
              ),
            ),
    );
  }
}
