import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/models/app_user.dart';
import '../../../../shared/models/film.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/films_repository_impl.dart';
import '../../domain/repositories/films_repository.dart';

/// Repositorio de películas (implementación Firestore).
final filmsRepositoryProvider = Provider<FilmsRepository>((ref) {
  return FilmsRepositoryImpl();
});

/// Catálogo completo de películas.
final filmsProvider = StreamProvider<List<Film>>((ref) {
  return ref.watch(filmsRepositoryProvider).watchAll();
});

/// Detalle reactivo de una película por id.
final filmProvider = StreamProvider.family<Film?, String>((ref, id) {
  return ref.watch(filmsRepositoryProvider).watchFilm(id);
});

/// Últimas valoraciones de una película.
final filmRatingsProvider = StreamProvider.family<List<FilmRating>, String>((
  ref,
  id,
) {
  return ref.watch(filmsRepositoryProvider).watchRatings(id);
});

/// Valoración del usuario actual sobre una película (null sin sesión/reseña).
final myRatingProvider = StreamProvider.family<FilmRating?, String>((ref, id) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream<FilmRating?>.value(null);
  return ref.watch(filmsRepositoryProvider).watchMyRating(id, user.id);
});

/// Controlador de acciones de valoración (valorar / eliminar).
class FilmsController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  FilmsRepository get _repo => ref.read(filmsRepositoryProvider);

  Future<void> rate(
    String filmId,
    AppUser user,
    double score,
    String? review,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.rate(filmId, user, score, review),
    );
  }

  Future<void> deleteRating(String filmId, String uid) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.deleteMyRating(filmId, uid));
  }
}

final filmsControllerProvider =
    NotifierProvider<FilmsController, AsyncValue<void>>(FilmsController.new);
