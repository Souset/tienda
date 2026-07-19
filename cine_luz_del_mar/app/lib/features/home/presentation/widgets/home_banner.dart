import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/models.dart';

/// Banner principal de Inicio: imagen o degradado de fondo, overlay oscuro
/// inferior y título/subtítulo editables desde `app_config/home`.
class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key, required this.config, required this.onTap});

  final HomeConfig config;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = config.bannerImageUrl;
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;
    final title = config.bannerTitle;
    final subtitle = config.bannerSubtitle;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          child: AspectRatio(
            aspectRatio: 20 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (hasImage)
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => _gradientBackground(theme),
                    errorWidget: (_, _, _) => _gradientBackground(theme),
                  )
                else
                  _gradientBackground(theme),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.78),
                      ],
                      stops: const [0.35, 1],
                    ),
                  ),
                ),
                if ((title != null && title.isNotEmpty) ||
                    (subtitle != null && subtitle.isNotEmpty))
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 18,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (title != null && title.isNotEmpty)
                          Text(
                            title,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (subtitle != null && subtitle.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _gradientBackground(ThemeData theme) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surfaceContainerHigh,
            theme.colorScheme.surfaceContainerLowest,
          ],
        ),
      ),
    );
  }
}
