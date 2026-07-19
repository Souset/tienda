import '../../../../shared/models/app_user.dart';
import '../../../../shared/models/film.dart';

/// Contrato de la capa de películas (catálogo y valoraciones).
abstract class FilmsRepository {
  /// Catálogo completo ordenado por título.
  Stream<List<Film>> watchAll();

  /// Detalle reactivo de una película (null si no existe).
  Stream<Film?> watchFilm(String id);

  /// Últimas valoraciones de una película, más recientes primero.
  Stream<List<FilmRating>> watchRatings(String id, {int limit = 20});

  /// Valoración del usuario [uid] sobre la película [id] (null si no valoró).
  Stream<FilmRating?> watchMyRating(String id, String uid);

  /// Crea o actualiza la valoración de [user] recalculando la media.
  Future<void> rate(String filmId, AppUser user, double score, String? review);

  /// Elimina la valoración del usuario [uid] recalculando la media.
  Future<void> deleteMyRating(String filmId, String uid);
}
