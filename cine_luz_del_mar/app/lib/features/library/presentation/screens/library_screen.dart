import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/user_role.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/widgets/app_shimmer.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/library_providers.dart';

/// Pantalla de Biblioteca: material de la asociación (documentos, podcasts,
/// vídeos y enlaces). Rama pública del shell: visible sin sesión, pero solo
/// muestra el material cuyo `minRole` sea alcanzable por el rol actual.
class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(currentRoleProvider);
    final resourcesAsync = ref.watch(resourcesProvider);
    final showGuestBanner = !role.atLeast(UserRole.socio);

    return Scaffold(
      appBar: AppBar(title: const Text('Biblioteca')),
      body: Column(
        children: [
          if (showGuestBanner) const _GuestBanner(),
          const SizedBox(height: 8),
          const _TypeFilterRow(),
          Expanded(
            child: resourcesAsync.when(
              loading: () => const _LibraryShimmer(),
              error: (error, _) => ErrorView(
                error: error,
                onRetry: () => ref.invalidate(resourcesProvider),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return const EmptyState(
                    icon: Icons.video_library_outlined,
                    title: 'Sin recursos todavía',
                    message: 'En cuanto añadamos material lo verás aquí.',
                  );
                }
                final categories =
                    items
                        .map((r) => r.category)
                        .whereType<String>()
                        .where((c) => c.isNotEmpty)
                        .toSet()
                        .toList()
                      ..sort();
                return Column(
                  children: [
                    if (categories.isNotEmpty)
                      _CategoryFilterRow(categories: categories),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(20),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 260,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.72,
                            ),
                        itemCount: items.length,
                        itemBuilder: (context, index) =>
                            _ResourceCard(resource: items[index]),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Banner sutil para invitados: invita a iniciar sesión como socio.
class _GuestBanner extends StatelessWidget {
  const _GuestBanner();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lock_outline,
            size: 18,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Inicia sesión como socio para ver todo el material',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Metadatos de un filtro de tipo de recurso.
class _TypeFilter {
  const _TypeFilter(this.value, this.label, this.icon);

  final String? value;
  final String label;
  final IconData icon;
}

const _typeFilters = <_TypeFilter>[
  _TypeFilter(null, 'Todos', Icons.apps_rounded),
  _TypeFilter('document', 'Documentos', Icons.description_outlined),
  _TypeFilter('podcast', 'Podcasts', Icons.podcasts_outlined),
  _TypeFilter('video', 'Vídeos', Icons.play_circle_outline),
  _TypeFilter('link', 'Enlaces', Icons.link),
];

/// Icono monocromo asociado a cada tipo de recurso.
IconData _iconForType(String type) {
  switch (type) {
    case 'document':
      return Icons.description_outlined;
    case 'podcast':
      return Icons.podcasts_outlined;
    case 'video':
      return Icons.play_circle_outline;
    case 'link':
      return Icons.link;
    default:
      return Icons.description_outlined;
  }
}

/// Etiqueta legible del tipo de recurso para el chip de la tarjeta.
String _labelForType(String type) {
  switch (type) {
    case 'document':
      return 'Documento';
    case 'podcast':
      return 'Podcast';
    case 'video':
      return 'Vídeo';
    case 'link':
      return 'Enlace';
    default:
      return type;
  }
}

/// Fila horizontal de chips para filtrar por tipo de recurso.
class _TypeFilterRow extends ConsumerWidget {
  const _TypeFilterRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedTypeProvider);
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _typeFilters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _typeFilters[index];
          return FilterChip(
            selected: selected == filter.value,
            avatar: Icon(filter.icon, size: 18),
            label: Text(filter.label),
            onSelected: (_) =>
                ref.read(selectedTypeProvider.notifier).state = filter.value,
          );
        },
      ),
    );
  }
}

/// Fila horizontal de chips para filtrar por categoría (dinámica, según las
/// categorías presentes en los recursos actualmente cargados).
class _CategoryFilterRow extends ConsumerWidget {
  const _CategoryFilterRow({required this.categories});

  final List<String> categories;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedCategoryProvider);
    final options = <String?>[null, ...categories];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
        itemCount: options.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final value = options[index];
          return ChoiceChip(
            selected: selected == value,
            label: Text(value ?? 'Todas'),
            onSelected: (_) =>
                ref.read(selectedCategoryProvider.notifier).state = value,
          );
        },
      ),
    );
  }
}

/// Tarjeta de un recurso de la biblioteca.
class _ResourceCard extends StatelessWidget {
  const _ResourceCard({required this.resource});

  final LibraryResource resource;

  Future<void> _open(BuildContext context) async {
    if (resource.url.isEmpty) return;
    try {
      final uri = Uri.parse(resource.url);
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened && context.mounted) _showError(context);
    } catch (_) {
      if (context.mounted) _showError(context);
    }
  }

  void _showError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No se pudo abrir el recurso')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMembersOnly = resource.minRole != 'invitado';
    final description = resource.description ?? '';

    return InkWell(
      borderRadius: BorderRadius.circular(AppTheme.radiusM),
      onTap: () => _open(context),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _ResourceCover(resource: resource),
                  if (isMembersOnly)
                    const Positioned(top: 8, right: 8, child: _Badge()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resource.title,
                    style: theme.textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Chip(
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    avatar: Icon(_iconForType(resource.type), size: 16),
                    label: Text(_labelForType(resource.type)),
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

/// Portada del recurso: imagen si hay `coverUrl`, si no un icono monocromo
/// según el tipo.
class _ResourceCover extends StatelessWidget {
  const _ResourceCover({required this.resource});

  final LibraryResource resource;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final coverUrl = resource.coverUrl;
    final fallback = Container(
      color: theme.colorScheme.surfaceContainerHigh,
      alignment: Alignment.center,
      child: Icon(
        _iconForType(resource.type),
        size: 32,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
    if (coverUrl == null || coverUrl.isEmpty) return fallback;
    return CachedNetworkImage(
      imageUrl: coverUrl,
      fit: BoxFit.cover,
      placeholder: (_, _) => AppShimmer(radius: 0, height: double.infinity),
      errorWidget: (_, _, _) => fallback,
    );
  }
}

/// Badge "Socios" para recursos restringidos a rangos superiores a invitado.
class _Badge extends StatelessWidget {
  const _Badge();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'Socios',
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Esqueleto de carga: fila de chips ya visible + cuadrícula de tarjetas.
class _LibraryShimmer extends StatelessWidget {
  const _LibraryShimmer();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 260,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.72,
      ),
      itemCount: 6,
      itemBuilder: (context, index) =>
          AppShimmer(radius: AppTheme.radiusM, height: double.infinity),
    );
  }
}
