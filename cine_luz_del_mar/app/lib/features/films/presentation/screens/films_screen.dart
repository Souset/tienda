import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/models/film.dart';
import '../../../../shared/widgets/app_shimmer.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/poster_card.dart';
import '../providers/films_providers.dart';

/// Catálogo de películas: grid responsive de pósters (2/4/6 columnas).
class FilmsScreen extends ConsumerWidget {
  const FilmsScreen({super.key});

  /// Número de columnas según el ancho disponible.
  int _columns(double width) {
    if (width >= 1024) return 6;
    if (width >= 600) return 4;
    return 2;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filmsAsync = ref.watch(filmsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Buscar',
            onPressed: () => context.push('/buscar'),
          ),
        ],
      ),
      body: filmsAsync.when(
        loading: () => _LoadingGrid(columns: _columns),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(filmsProvider),
        ),
        data: (films) {
          if (films.isEmpty) {
            return const EmptyState(
              icon: Icons.theaters_outlined,
              title: 'Catálogo vacío',
              message: 'Aún no hay películas en el catálogo.',
            );
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              final columns = _columns(constraints.maxWidth);
              const crossSpacing = 16.0;
              // Ancho real de cada póster (para pasarlo fijo a PosterCard).
              final tileWidth =
                  (constraints.maxWidth - 32 - crossSpacing * (columns - 1)) /
                  columns;
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: crossSpacing,
                  // Póster 2:3 + espacio para título y año debajo.
                  mainAxisExtent: tileWidth * 1.5 + 48,
                ),
                itemCount: films.length,
                itemBuilder: (context, index) {
                  final film = films[index];
                  return _FilmTile(film: film, width: tileWidth);
                },
              );
            },
          );
        },
      ),
    );
  }
}

/// Celda de película: póster con título y año, navega al detalle.
class _FilmTile extends StatelessWidget {
  const _FilmTile({required this.film, required this.width});

  final Film film;
  final double width;

  @override
  Widget build(BuildContext context) {
    return PosterCard(
      imageUrl: film.posterUrl,
      title: film.title,
      subtitle: film.year?.toString(),
      width: width,
      heroTag: 'film-${film.id}',
      onTap: () => context.push('/peliculas/${film.id}'),
    );
  }
}

/// Grid de placeholders shimmer durante la carga.
class _LoadingGrid extends StatelessWidget {
  const _LoadingGrid({required this.columns});

  final int Function(double) columns;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = columns(constraints.maxWidth);
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: count,
            mainAxisSpacing: 20,
            crossAxisSpacing: 16,
            childAspectRatio: 0.62,
          ),
          itemCount: count * 3,
          itemBuilder: (_, _) => const AppShimmer(height: 240, radius: 12),
        );
      },
    );
  }
}
