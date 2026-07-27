import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/widgets/app_shimmer.dart';
import '../../../../shared/widgets/brand_wordmark.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/poster_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../providers/home_providers.dart';
import '../widgets/home_banner.dart';
import '../widgets/home_news_row.dart';
import '../widgets/upcoming_event_card.dart';

/// Pantalla de Inicio: escaparate de la aplicación con banner editable y
/// carruseles de próximas actividades, películas destacadas y noticias.
///
/// Cada sección observa su propio provider de forma independiente: si una
/// falla o tarda, el resto de la pantalla sigue funcionando con normalidad.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configAsync = ref.watch(homeConfigProvider);
    final eventsAsync = ref.watch(upcomingEventsProvider);
    final filmsAsync = ref.watch(featuredFilmsProvider);
    final newsAsync = ref.watch(latestNewsProvider);

    // Solo mostramos el estado vacío acogedor cuando todas las secciones ya
    // resolvieron (con o sin error) y ninguna tiene contenido que ofrecer.
    final allSettled =
        !configAsync.isLoading &&
        !eventsAsync.isLoading &&
        !filmsAsync.isLoading &&
        !newsAsync.isLoading;
    final allEmpty =
        allSettled &&
        (configAsync.value == null) &&
        (eventsAsync.value?.isEmpty ?? true) &&
        (filmsAsync.value?.isEmpty ?? true) &&
        (newsAsync.value?.isEmpty ?? true);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: const BrandWordmark(fontSize: 28),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                tooltip: 'Buscar',
                onPressed: () => context.push('/buscar'),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none),
                tooltip: 'Notificaciones',
                onPressed: () => context.push('/notificaciones'),
              ),
              const SizedBox(width: 4),
            ],
          ),
          if (allEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  BrandWordmark(fontSize: 40),
                  SizedBox(height: 12),
                  EmptyState(
                    icon: Icons.movie_filter_outlined,
                    title: 'Todavía no hay nada por aquí',
                    message:
                        'En cuanto haya actividades, películas o noticias '
                        'las verás en este espacio.',
                  ),
                ],
              ),
            )
          else
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 8),
                _BannerSection(
                  configAsync: configAsync,
                ).animate().fadeIn(duration: 300.ms).moveY(begin: 16, end: 0),
                _UpcomingSection(eventsAsync: eventsAsync)
                    .animate(delay: 80.ms)
                    .fadeIn(duration: 300.ms)
                    .moveY(begin: 16, end: 0),
                _FeaturedFilmsSection(filmsAsync: filmsAsync)
                    .animate(delay: 160.ms)
                    .fadeIn(duration: 300.ms)
                    .moveY(begin: 16, end: 0),
                _LatestNewsSection(newsAsync: newsAsync)
                    .animate(delay: 240.ms)
                    .fadeIn(duration: 300.ms)
                    .moveY(begin: 16, end: 0),
                const SizedBox(height: 24),
              ]),
            ),
        ],
      ),
    );
  }
}

/// Banner editable desde `app_config/home`. Si no hay configuración
/// publicada, la sección no ocupa espacio.
class _BannerSection extends StatelessWidget {
  const _BannerSection({required this.configAsync});

  final AsyncValue<HomeConfig?> configAsync;

  @override
  Widget build(BuildContext context) {
    if (configAsync.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: AspectRatio(
          aspectRatio: 20 / 9,
          child: AppShimmer(radius: AppTheme.radiusL, height: double.infinity),
        ),
      );
    }

    final config = configAsync.value;
    if (configAsync.hasError || config == null) return const SizedBox.shrink();

    return HomeBanner(
      config: config,
      onTap: () => context.push(config.bannerRoute ?? '/agenda'),
    );
  }
}

/// Carrusel horizontal de próximas actividades.
class _UpcomingSection extends StatelessWidget {
  const _UpcomingSection({required this.eventsAsync});

  final AsyncValue<List<EventItem>> eventsAsync;

  @override
  Widget build(BuildContext context) {
    if (eventsAsync.isLoading) {
      return _CarouselShimmer(
        title: 'Próximas actividades',
        itemWidth: 280,
        itemHeight: 150,
      );
    }

    final events = eventsAsync.value ?? const <EventItem>[];
    if (eventsAsync.hasError || events.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Próximas actividades',
          actionLabel: 'Ver todo',
          onAction: () => context.go('/agenda'),
        ),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: events.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final event = events[index];
              return UpcomingEventCard(
                event: event,
                onTap: () => context.push('/agenda/${event.id}'),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Carrusel horizontal de películas destacadas.
class _FeaturedFilmsSection extends StatelessWidget {
  const _FeaturedFilmsSection({required this.filmsAsync});

  final AsyncValue<List<Film>> filmsAsync;

  @override
  Widget build(BuildContext context) {
    if (filmsAsync.isLoading) {
      return _CarouselShimmer(
        title: 'Películas destacadas',
        itemWidth: 130,
        itemHeight: 195,
      );
    }

    final films = filmsAsync.value ?? const <Film>[];
    if (filmsAsync.hasError || films.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Películas destacadas',
          actionLabel: 'Ver todo',
          onAction: () => context.push('/peliculas'),
        ),
        SizedBox(
          height: 225,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: films.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final film = films[index];
              return PosterCard(
                imageUrl: film.posterUrl,
                title: film.title,
                width: 130,
                heroTag: 'film-${film.id}',
                onTap: () => context.push('/peliculas/${film.id}'),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Últimas noticias, en formato de filas compactas.
class _LatestNewsSection extends StatelessWidget {
  const _LatestNewsSection({required this.newsAsync});

  final AsyncValue<List<NewsItem>> newsAsync;

  @override
  Widget build(BuildContext context) {
    if (newsAsync.isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 28),
            const AppShimmer(height: 22, width: 160),
            const SizedBox(height: 16),
            for (var i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    const AppShimmer.circle(size: 64),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          AppShimmer(height: 14),
                          SizedBox(height: 8),
                          AppShimmer(height: 10, width: 80),
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

    final news = newsAsync.value ?? const <NewsItem>[];
    if (newsAsync.hasError || news.isEmpty) return const SizedBox.shrink();
    final latest = news.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Noticias',
          actionLabel: 'Ver todo',
          onAction: () => context.push('/noticias'),
        ),
        for (final item in latest)
          HomeNewsRow(
            item: item,
            onTap: () => context.push('/noticias/${item.id}'),
          ),
      ],
    );
  }
}

/// Esqueleto de carga genérico para carruseles horizontales.
class _CarouselShimmer extends StatelessWidget {
  const _CarouselShimmer({
    required this.title,
    required this.itemWidth,
    required this.itemHeight,
  });

  final String title;
  final double itemWidth;
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title),
        SizedBox(
          height: itemHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, _) => AppShimmer(
              width: itemWidth,
              height: itemHeight,
              radius: AppTheme.radiusM,
            ),
          ),
        ),
      ],
    );
  }
}
