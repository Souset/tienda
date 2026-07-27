import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/widgets/app_shimmer.dart';

/// Fila compacta de noticia para el resumen de Inicio: miniatura + título +
/// fecha relativa.
class HomeNewsRow extends StatelessWidget {
  const HomeNewsRow({super.key, required this.item, this.onTap});

  final NewsItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final url = item.coverUrl;
    final fallback = Container(
      color: theme.colorScheme.surfaceContainer,
      alignment: Alignment.center,
      child: Icon(
        Icons.newspaper,
        size: 20,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusS),
              child: SizedBox(
                width: 64,
                height: 64,
                child: (url == null || url.isEmpty)
                    ? fallback
                    : CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => const AppShimmer(
                          radius: 0,
                          height: double.infinity,
                        ),
                        errorWidget: (_, _, _) => fallback,
                      ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: theme.textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.publishedAt != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      Formatters.relative(item.publishedAt!),
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
    );
  }
}
