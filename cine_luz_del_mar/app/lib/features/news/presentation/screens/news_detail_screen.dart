import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_shimmer.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../providers/news_providers.dart';

/// Detalle de una noticia: cabecera, título, etiquetas y cuerpo completo.
class NewsDetailScreen extends ConsumerWidget {
  const NewsDetailScreen({super.key, required this.newsId});

  final String newsId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsItemProvider(newsId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Noticia'),
        actions: [
          if (newsAsync.value != null)
            IconButton(
              icon: const Icon(Icons.share_outlined),
              tooltip: 'Compartir',
              onPressed: () {
                final item = newsAsync.value!;
                SharePlus.instance.share(
                  ShareParams(text: '${item.title} — Cine Luz del Mar'),
                );
              },
            ),
        ],
      ),
      body: newsAsync.when(
        loading: () => const _NewsDetailShimmer(),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(newsItemProvider(newsId)),
        ),
        data: (item) {
          if (item == null) {
            return const EmptyState(
              icon: Icons.newspaper_outlined,
              title: 'Noticia no encontrada',
              message: 'Puede que ya no esté disponible.',
            );
          }

          final theme = Theme.of(context);
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.coverUrl != null && item.coverUrl!.isNotEmpty)
                  Hero(
                    tag: 'news-$newsId',
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: CachedNetworkImage(
                        imageUrl: item.coverUrl!,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => const AppShimmer(
                          radius: 0,
                          height: double.infinity,
                        ),
                        errorWidget: (_, _, _) => Container(
                          color: theme.colorScheme.surfaceContainer,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.newspaper,
                            size: 40,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        [
                              Text(
                                item.title,
                                style: theme.textTheme.displaySmall,
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 10,
                                runSpacing: 8,
                                children: [
                                  if (item.publishedAt != null)
                                    Text(
                                      Formatters.fullDate.format(
                                        item.publishedAt!,
                                      ),
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                  for (final tag in item.tags)
                                    Chip(
                                      label: Text(tag),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                item.body,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  height: 1.6,
                                ),
                              ),
                            ]
                            .animate(interval: 60.ms)
                            .fadeIn(duration: 300.ms)
                            .moveY(begin: 8, end: 0),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Esqueleto de carga del detalle.
class _NewsDetailShimmer extends StatelessWidget {
  const _NewsDetailShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        AppShimmer(height: 200, radius: AppTheme.radiusL),
        const SizedBox(height: 20),
        const AppShimmer(height: 28, width: 260),
        const SizedBox(height: 12),
        const AppShimmer(height: 16, width: 160),
        const SizedBox(height: 20),
        const AppShimmer(height: 14),
        const SizedBox(height: 8),
        const AppShimmer(height: 14),
        const SizedBox(height: 8),
        const AppShimmer(height: 14, width: 220),
      ],
    );
  }
}
