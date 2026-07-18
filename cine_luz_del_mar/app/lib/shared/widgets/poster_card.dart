import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'app_shimmer.dart';

/// Tarjeta de póster estilo Netflix/Letterboxd: imagen 2:3 con esquinas
/// redondeadas, escala sutil al pulsar y título opcional debajo.
class PosterCard extends StatefulWidget {
  const PosterCard({
    super.key,
    required this.imageUrl,
    this.title,
    this.subtitle,
    this.width = 140,
    this.onTap,
    this.heroTag,
  });

  final String? imageUrl;
  final String? title;
  final String? subtitle;
  final double width;
  final VoidCallback? onTap;
  final Object? heroTag;

  @override
  State<PosterCard> createState() => _PosterCardState();
}

class _PosterCardState extends State<PosterCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = widget.width * 1.5;

    Widget image = Container(
      width: widget.width,
      height: height,
      color: theme.colorScheme.surfaceContainer,
      child: Icon(
        Icons.movie_outlined,
        color: theme.colorScheme.onSurfaceVariant,
        size: 32,
      ),
    );
    final url = widget.imageUrl;
    if (url != null && url.isNotEmpty) {
      image = CachedNetworkImage(
        imageUrl: url,
        width: widget.width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (_, _) =>
            AppShimmer(width: widget.width, height: height, radius: 0),
        errorWidget: (_, _, _) => image,
      );
    }

    Widget poster = ClipRRect(
      borderRadius: BorderRadius.circular(AppTheme.radiusM),
      child: image,
    );
    if (widget.heroTag != null) {
      poster = Hero(tag: widget.heroTag!, child: poster);
    }

    return AnimatedScale(
      scale: _pressed ? 0.96 : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: SizedBox(
          width: widget.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              poster,
              if (widget.title != null) ...[
                const SizedBox(height: 8),
                Text(
                  widget.title!,
                  style: theme.textTheme.labelLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (widget.subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  widget.subtitle!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
