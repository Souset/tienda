import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/widgets/app_shimmer.dart';
import '../../../../shared/widgets/content_width.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../providers/news_providers.dart';

/// Pantalla de Noticias: la primera noticia publicada se muestra como
/// tarjeta destacada y el resto como una lista de filas compactas.
class NewsListScreen extends ConsumerWidget {
  const NewsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(publishedNewsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Noticias')),
      body: newsAsync.when(
        loading: () => const _NewsListShimmer(),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(publishedNewsProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const EmptyState(
              icon: Icons.newspaper_outlined,
              title: 'Sin noticias todavía',
              message: 'En cuanto publiquemos algo lo verás aquí.',
            );
          }

          final featured = items.first;
          final rest = items.skip(1).toList();

          return ContentColumn(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: _FeaturedNewsCard(
                    item: featured,
                    onTap: () => context.push('/noticias/${featured.id}'),
                  ),
                ),
                for (final item in rest)
                  _NewsRow(
                    item: item,
                    onTap: () => context.push('/noticias/${item.id}'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Tarjeta grande de la noticia más reciente.
class _FeaturedNewsCard extends StatelessWidget {
  const _FeaturedNewsCard({required this.item, required this.onTap});

  final NewsItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'news-${item.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusL),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: _NewsImage(url: item.coverUrl),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            item.title,
            style: theme.textTheme.headlineSmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (item.publishedAt != null) ...[
            const SizedBox(height: 4),
            Text(
              Formatters.fullDate.format(item.publishedAt!),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Fila compacta de noticia: miniatura cuadrada + título + fecha relativa.
class _NewsRow extends StatelessWidget {
  const _NewsRow({required this.item, required this.onTap});

  final NewsItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusS),
              child: SizedBox(
                width: 84,
                height: 84,
                child: _NewsImage(url: item.coverUrl, iconSize: 24),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: theme.textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  if (item.publishedAt != null)
                    Text(
                      Formatters.relative(item.publishedAt!),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Imagen de portada con fallback gris + icono cuando no hay `coverUrl` o
/// falla la carga.
class _NewsImage extends StatelessWidget {
  const _NewsImage({required this.url, this.iconSize = 32});

  final String? url;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fallback = Container(
      color: theme.colorScheme.surfaceContainer,
      alignment: Alignment.center,
      child: Icon(
        Icons.newspaper,
        size: iconSize,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
    if (url == null || url!.isEmpty) return fallback;
    return CachedNetworkImage(
      imageUrl: url!,
      fit: BoxFit.cover,
      placeholder: (_, _) => AppShimmer(radius: 0, height: double.infinity),
      errorWidget: (_, _, _) => fallback,
    );
  }
}

/// Esqueleto de carga: tarjeta destacada + filas.
class _NewsListShimmer extends StatelessWidget {
  const _NewsListShimmer();

  @override
  Widget build(BuildContext context) {
    return ContentColumn(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          AppShimmer(height: 200, radius: AppTheme.radiusL),
          const SizedBox(height: 12),
          const AppShimmer(height: 24, width: 240),
          const SizedBox(height: 8),
          const AppShimmer(height: 16, width: 140),
          const SizedBox(height: 24),
          for (var i = 0; i < 5; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  AppShimmer(width: 84, height: 84, radius: AppTheme.radiusS),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        AppShimmer(height: 16),
                        SizedBox(height: 8),
                        AppShimmer(height: 12, width: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
