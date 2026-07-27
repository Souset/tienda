import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/models/film.dart';
import '../../../../shared/widgets/app_shimmer.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../../shared/widgets/favorite_button.dart';
import '../providers/films_providers.dart';
import '../widgets/star_rating.dart';

/// Detalle de una película: ficha, valoración media y sistema de reseñas.
class FilmDetailScreen extends ConsumerWidget {
  const FilmDetailScreen({super.key, required this.filmId});

  final String filmId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filmAsync = ref.watch(filmProvider(filmId));

    return Scaffold(
      appBar: AppBar(actions: [FavoriteButton.film(filmId)]),
      body: filmAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(filmProvider(filmId)),
        ),
        data: (film) {
          if (film == null) {
            return const ErrorView(error: NotFoundException());
          }
          return _FilmDetailBody(film: film);
        },
      ),
    );
  }
}

class _FilmDetailBody extends StatelessWidget {
  const _FilmDetailBody({required this.film});

  final Film film;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final subtitle = [
      if (film.director != null && film.director!.isNotEmpty) film.director!,
      if (film.year != null) '${film.year}',
    ].join(' · ');

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      children: [
        // Cabecera: póster + título + director/año + valoración media.
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'film-${film.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                child: _Poster(posterUrl: film.posterUrl),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(film.title, style: theme.textTheme.headlineSmall),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  _AverageRating(film: film),
                  if (film.genres.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: film.genres
                          .map((g) => _GenreChip(label: g))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        if (film.synopsis != null && film.synopsis!.isNotEmpty) ...[
          const SizedBox(height: 28),
          Text('Sinopsis', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            film.synopsis!,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
          ),
        ],
        const SizedBox(height: 32),
        _MyRatingSection(filmId: film.id),
        const SizedBox(height: 32),
        _ReviewsSection(filmId: film.id),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }
}

/// Póster de tamaño fijo con fallback a icono.
class _Poster extends StatelessWidget {
  const _Poster({this.posterUrl});

  final String? posterUrl;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    const width = 120.0;
    const height = width * 1.5;
    final fallback = Container(
      width: width,
      height: height,
      color: scheme.surfaceContainer,
      alignment: Alignment.center,
      child: Icon(
        Icons.movie_outlined,
        color: scheme.onSurfaceVariant,
        size: 32,
      ),
    );
    final url = posterUrl;
    if (url == null || url.isEmpty) return fallback;
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      placeholder: (_, _) =>
          const AppShimmer(width: width, height: height, radius: 0),
      errorWidget: (_, _, _) => fallback,
    );
  }
}

/// Valoración media con estrellas monocromas y número de valoraciones.
class _AverageRating extends StatelessWidget {
  const _AverageRating({required this.film});

  final Film film;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    if (film.ratingsCount == 0) {
      return Text(
        'Sin valoraciones aún',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      );
    }
    final plural = film.ratingsCount == 1 ? 'valoración' : 'valoraciones';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              film.avgRating.toStringAsFixed(1),
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(width: 8),
            StarRatingDisplay(value: film.avgRating),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '(${film.ratingsCount} $plural)',
          style: theme.textTheme.labelMedium?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Chip de género.
class _GenreChip extends StatelessWidget {
  const _GenreChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Text(label, style: theme.textTheme.labelSmall),
    );
  }
}

/// Sección "Tu valoración": distintos estados según sesión y verificación.
class _MyRatingSection extends ConsumerStatefulWidget {
  const _MyRatingSection({required this.filmId});

  final String filmId;

  @override
  ConsumerState<_MyRatingSection> createState() => _MyRatingSectionState();
}

class _MyRatingSectionState extends ConsumerState<_MyRatingSection> {
  final _reviewController = TextEditingController();
  double _score = 0;
  bool _initialised = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  /// Rellena el formulario con la valoración existente una única vez.
  void _syncFromExisting(FilmRating? existing) {
    if (_initialised || existing == null) return;
    _initialised = true;
    _score = existing.score;
    _reviewController.text = existing.review ?? '';
  }

  Future<void> _save() async {
    final user = ref.read(currentUserProvider);
    if (user == null || _score <= 0) return;
    final review = _reviewController.text.trim();
    await ref
        .read(filmsControllerProvider.notifier)
        .rate(widget.filmId, user, _score, review.isEmpty ? null : review);
    _afterAction('¡Valoración guardada!');
  }

  Future<void> _delete() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    await ref
        .read(filmsControllerProvider.notifier)
        .deleteRating(widget.filmId, user.id);
    if (mounted) {
      setState(() {
        _score = 0;
        _reviewController.clear();
      });
    }
    _afterAction('Valoración eliminada');
  }

  void _afterAction(String successMessage) {
    if (!mounted) return;
    final state = ref.read(filmsControllerProvider);
    final messenger = ScaffoldMessenger.of(context);
    if (state.hasError) {
      final error = state.error;
      final message = error is AppException
          ? error.message
          : 'No se pudo completar la acción';
      messenger.showSnackBar(SnackBar(content: Text(message)));
    } else {
      messenger.showSnackBar(SnackBar(content: Text(successMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final user = ref.watch(currentUserProvider);
    final emailVerified = ref.watch(emailVerifiedProvider);

    Widget body;
    if (user == null) {
      // Sin sesión: invitación a acceder.
      body = _Notice(
        icon: Icons.lock_outline,
        text: 'Inicia sesión para valorar esta película.',
        actionLabel: 'Acceder',
        onAction: () => context.go('/acceso'),
      );
    } else if (!emailVerified) {
      // Email sin verificar: aviso.
      body = _Notice(
        icon: Icons.mark_email_unread_outlined,
        text: 'Verifica tu correo para poder valorar películas.',
        actionLabel: 'Verificar correo',
        onAction: () => context.push('/acceso/verificar'),
      );
    } else {
      final myRatingAsync = ref.watch(myRatingProvider(widget.filmId));
      _syncFromExisting(myRatingAsync.value);
      final hasExisting = myRatingAsync.value != null;
      final controllerState = ref.watch(filmsControllerProvider);
      final loading = controllerState.isLoading;

      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: StarRatingInput(
              value: _score,
              onChanged: (v) => setState(() => _score = v),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _reviewController,
            minLines: 2,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Escribe una reseña (opcional)',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: (loading || _score <= 0) ? null : _save,
                  child: loading
                      ? const _BtnSpinner()
                      : Text(hasExisting ? 'Actualizar' : 'Guardar'),
                ),
              ),
              if (hasExisting) ...[
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: loading ? null : _delete,
                  child: const Text('Eliminar'),
                ),
              ],
            ],
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tu valoración', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: body,
        ),
      ],
    );
  }
}

/// Aviso con icono, texto y acción (para estados sin sesión / sin verificar).
class _Notice extends StatelessWidget {
  const _Notice({
    required this.icon,
    required this.text,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      children: [
        Icon(icon, color: scheme.onSurfaceVariant),
        const SizedBox(height: 12),
        Text(
          text,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        if (actionLabel != null && onAction != null) ...[
          const SizedBox(height: 12),
          FilledButton(onPressed: onAction, child: Text(actionLabel!)),
        ],
      ],
    );
  }
}

/// Lista de las últimas reseñas de la película.
class _ReviewsSection extends ConsumerWidget {
  const _ReviewsSection({required this.filmId});

  final String filmId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final ratingsAsync = ref.watch(filmRatingsProvider(filmId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reseñas', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        ratingsAsync.when(
          loading: () => const ShimmerList(itemCount: 2, itemHeight: 72),
          error: (_, _) => Text(
            'No se pudieron cargar las reseñas',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          data: (ratings) {
            // Solo mostramos reseñas con texto; el resto cuenta para la media.
            final withText = ratings
                .where((r) => (r.review ?? '').trim().isNotEmpty)
                .toList();
            if (withText.isEmpty) {
              return Text(
                'Todavía no hay reseñas escritas. ¡Sé el primero!',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              );
            }
            return Column(
              children: withText.map((r) => _ReviewTile(rating: r)).toList(),
            );
          },
        ),
      ],
    );
  }
}

/// Tarjeta de una reseña: avatar, autor, estrellas, texto y antigüedad.
class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.rating});

  final FilmRating rating;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final created = rating.createdAt;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              UserAvatar(name: rating.authorName, size: 36),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rating.authorName ?? 'Anónimo',
                      style: theme.textTheme.labelLarge,
                    ),
                    const SizedBox(height: 2),
                    StarRatingDisplay(value: rating.score, size: 14),
                  ],
                ),
              ),
              if (created != null)
                Text(
                  Formatters.relative(created),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          if ((rating.review ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(rating.review!, style: theme.textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}

/// Spinner pequeño para el interior de un botón durante la acción.
class _BtnSpinner extends StatelessWidget {
  const _BtnSpinner();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
