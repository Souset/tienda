import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/widgets/app_shimmer.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/content_width.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/notifications_providers.dart';

/// Pantalla de Notificaciones: bandeja personal del usuario.
///
/// Ruta protegida `/notificaciones`: solo se llega aquí con sesión iniciada,
/// por lo que siempre hay un [currentUserProvider] resuelto.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inboxAsync = ref.watch(inboxProvider);
    final uid = ref.watch(currentUserProvider)?.id;
    final hasUnread = inboxAsync.value?.any((n) => !n.read) ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        actions: [
          if (hasUnread && uid != null)
            IconButton(
              tooltip: 'Marcar todas leídas',
              icon: const Icon(Icons.done_all),
              onPressed: () =>
                  ref.read(notificationsRepositoryProvider).markAllRead(uid),
            ),
        ],
      ),
      body: inboxAsync.when(
        loading: () => const ShimmerList(maxWidth: ContentWidth.list),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(inboxProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const EmptyState(
              icon: Icons.notifications_none,
              title: 'Sin novedades por ahora',
              message: 'Aquí verás avisos de la asociación cuando lleguen.',
            );
          }
          if (uid == null) {
            // No debería ocurrir en una ruta protegida, pero se protege
            // igualmente por si la sesión expira mientras se ve la pantalla.
            return const EmptyState(
              icon: Icons.notifications_none,
              title: 'Sin novedades por ahora',
            );
          }
          return ContentColumn(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              separatorBuilder: (_, _) =>
                  const Divider(height: 1, indent: 20, endIndent: 20),
              itemBuilder: (context, index) {
                final item = items[index];
                return _NotificationTile(
                  item: item,
                  onTap: () async {
                    if (!item.read) {
                      await ref
                          .read(notificationsRepositoryProvider)
                          .markRead(uid, item.id);
                    }
                    final route = item.route;
                    if (route != null && route.isNotEmpty && context.mounted) {
                      context.push(route);
                    }
                  },
                  onDismissed: () => ref
                      .read(notificationsRepositoryProvider)
                      .delete(uid, item.id),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// Fila de una notificación: punto de no leída, título, cuerpo y fecha.
///
/// Envuelta en [Dismissible] para permitir borrarla con un deslizamiento.
class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.item,
    required this.onTap,
    required this.onDismissed,
  });

  final AppNotification item;
  final VoidCallback onTap;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        color: theme.colorScheme.error,
        child: Icon(Icons.delete_outline, color: theme.colorScheme.onError),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: SizedBox(
                  width: 8,
                  height: 8,
                  child: item.read
                      ? null
                      : DecoratedBox(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface,
                            shape: BoxShape.circle,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: item.read
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                    ),
                    if (item.body.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.body,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (item.createdAt != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        Formatters.relative(item.createdAt!),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
