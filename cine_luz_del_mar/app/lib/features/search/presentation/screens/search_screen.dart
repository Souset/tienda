import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../domain/search_results.dart';
import '../providers/search_providers.dart';

/// Buscador global: eventos, películas, noticias, biblioteca y personas.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // La pantalla siempre arranca con una búsqueda limpia.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchQueryProvider.notifier).clear();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final results = ref.watch(searchResultsProvider);
    final term = ref.watch(searchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onChanged: (value) =>
              ref.read(searchQueryProvider.notifier).update(value),
          decoration: InputDecoration(
            hintText: 'Buscar películas, actividades, noticias…',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            suffixIcon: _controller.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () {
                      _controller.clear();
                      ref.read(searchQueryProvider.notifier).clear();
                      setState(() {});
                    },
                  ),
          ),
          style: theme.textTheme.bodyLarge,
        ),
      ),
      body: term.length < 2
          ? const EmptyState(
              icon: Icons.search,
              title: 'Busca en toda la asociación',
              message:
                  'Películas, actividades, noticias, material de la '
                  'biblioteca y personas de la comunidad.',
            )
          : results.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => ErrorView(
                error: error,
                onRetry: () => ref.invalidate(searchResultsProvider),
              ),
              data: (data) => data.isEmpty
                  ? EmptyState(
                      icon: Icons.search_off_rounded,
                      title: 'Sin resultados para "$term"',
                      message: 'Prueba con otra palabra o revisa la Agenda.',
                    )
                  : _ResultsList(results: data),
            ),
    );
  }
}

class _ResultsList extends StatelessWidget {
  const _ResultsList({required this.results});

  final SearchResults results;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        if (results.events.isNotEmpty) ...[
          const SectionHeader(title: 'Actividades'),
          for (final event in results.events)
            ListTile(
              leading: const Icon(Icons.calendar_month_outlined),
              title: Text(event.title, maxLines: 1),
              subtitle: Text(
                event.start == null
                    ? event.venue?.name ?? ''
                    : Formatters.dateTime.format(event.start!),
              ),
              onTap: () => context.push('/agenda/${event.id}'),
            ),
        ],
        if (results.films.isNotEmpty) ...[
          const SectionHeader(title: 'Películas'),
          for (final film in results.films)
            ListTile(
              leading: const Icon(Icons.theaters_outlined),
              title: Text(film.title, maxLines: 1),
              subtitle: Text(
                [
                  if (film.year != null) '${film.year}',
                  if (film.director != null) film.director!,
                ].join(' · '),
              ),
              trailing: film.ratingsCount > 0
                  ? Text(
                      '★ ${film.avgRating.toStringAsFixed(1)}',
                      style: theme.textTheme.labelMedium,
                    )
                  : null,
              onTap: () => context.push('/peliculas/${film.id}'),
            ),
        ],
        if (results.news.isNotEmpty) ...[
          const SectionHeader(title: 'Noticias'),
          for (final item in results.news)
            ListTile(
              leading: const Icon(Icons.newspaper),
              title: Text(item.title, maxLines: 2),
              subtitle: item.publishedAt == null
                  ? null
                  : Text(Formatters.relative(item.publishedAt!)),
              onTap: () => context.push('/noticias/${item.id}'),
            ),
        ],
        if (results.resources.isNotEmpty) ...[
          const SectionHeader(title: 'Biblioteca'),
          for (final resource in results.resources)
            ListTile(
              leading: const Icon(Icons.video_library_outlined),
              title: Text(resource.title, maxLines: 1),
              subtitle: resource.category == null
                  ? null
                  : Text(resource.category!),
              onTap: () => context.go('/biblioteca'),
            ),
        ],
        if (results.users.isNotEmpty) ...[
          const SectionHeader(title: 'Personas'),
          for (final user in results.users)
            ListTile(
              leading: UserAvatar(
                photoUrl: user.photoUrl,
                name: user.displayName,
                size: 40,
              ),
              title: Text(user.displayName, maxLines: 1),
              subtitle: Text(user.userRole.label),
              onTap: () => context.go('/comunidad'),
            ),
        ],
      ],
    );
  }
}
