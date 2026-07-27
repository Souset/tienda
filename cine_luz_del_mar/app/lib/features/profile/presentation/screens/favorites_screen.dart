import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/content_width.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/poster_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/favorites_repository.dart';

/// Favoritos del usuario: películas y actividades guardadas.
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) return const SizedBox.shrink();

    final films = ref.watch(favoriteFilmsProvider(user.favoriteFilms));
    final events = ref.watch(favoriteEventsProvider(user.favoriteEvents));
    final isEmpty = user.favoriteFilms.isEmpty && user.favoriteEvents.isEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: isEmpty
          ? const EmptyState(
              icon: Icons.favorite_border,
              title: 'Todavía no tienes favoritos',
              message:
                  'Toca el corazón en cualquier película o actividad '
                  'para guardarla aquí.',
            )
          : ContentColumn(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  if (user.favoriteFilms.isNotEmpty) ...[
                    const SectionHeader(title: 'Películas'),
                    SizedBox(
                      height: 240,
                      child: films.when(
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, _) => Center(child: Text('Error: $e')),
                        data: (list) => ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: list.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 12),
                          itemBuilder: (_, i) => PosterCard(
                            imageUrl: list[i].posterUrl,
                            title: list[i].title,
                            subtitle: list[i].year?.toString(),
                            width: 130,
                            onTap: () =>
                                context.push('/peliculas/${list[i].id}'),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (user.favoriteEvents.isNotEmpty) ...[
                    const SectionHeader(title: 'Actividades'),
                    events.when(
                      loading: () => const LinearProgressIndicator(),
                      error: (e, _) => Center(child: Text('Error: $e')),
                      data: (list) => Column(
                        children: [
                          for (final event in list)
                            ListTile(
                              leading: const Icon(
                                Icons.calendar_month_outlined,
                              ),
                              title: Text(event.title, maxLines: 1),
                              subtitle: event.start == null
                                  ? null
                                  : Text(
                                      Formatters.dateTime.format(event.start!),
                                    ),
                              onTap: () => context.push('/agenda/${event.id}'),
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
