import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/services/collections.dart';
import '../../../../shared/models/app_user.dart';
import '../../../../shared/models/film.dart';
import '../../domain/rating_math.dart';
import '../../domain/repositories/films_repository.dart';

/// Implementación de [FilmsRepository] con Cloud Firestore.
///
/// El recálculo de la media se hace dentro de una transacción y solo escribe
/// en `films/{id}` los campos `avgRating`, `ratingsCount` y `updatedAt`, tal
/// y como exigen las reglas de seguridad desplegadas.
class FilmsRepositoryImpl implements FilmsRepository {
  FilmsRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _films =>
      _firestore.collection(Col.films);

  @override
  Stream<List<Film>> watchAll() {
    return _films
        .orderBy('title')
        .limit(100)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => Film.fromJson(d.data()).copyWith(id: d.id))
              .toList(),
        );
  }

  @override
  Stream<Film?> watchFilm(String id) {
    return _films.doc(id).snapshots().map((doc) {
      final data = doc.data();
      if (!doc.exists || data == null) return null;
      return Film.fromJson(data).copyWith(id: doc.id);
    });
  }

  @override
  Stream<List<FilmRating>> watchRatings(String id, {int limit = 20}) {
    return _films
        .doc(id)
        .collection('ratings')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => FilmRating.fromJson(d.data()).copyWith(id: d.id))
              .toList(),
        );
  }

  @override
  Stream<FilmRating?> watchMyRating(String id, String uid) {
    return _films.doc(id).collection('ratings').doc(uid).snapshots().map((doc) {
      final data = doc.data();
      if (!doc.exists || data == null) return null;
      return FilmRating.fromJson(data).copyWith(id: doc.id);
    });
  }

  @override
  Future<void> rate(
    String filmId,
    AppUser user,
    double score,
    String? review,
  ) async {
    final filmRef = _films.doc(filmId);
    final ratingRef = filmRef.collection('ratings').doc(user.id);

    try {
      await _firestore.runTransaction((tx) async {
        final filmSnap = await tx.get(filmRef);
        if (!filmSnap.exists) {
          throw const NotFoundException('La película ya no existe');
        }
        final ratingSnap = await tx.get(ratingRef);

        final film = Film.fromJson(filmSnap.data()!);
        final previous = ratingSnap.exists
            ? (ratingSnap.data()?['score'] as num?)?.toDouble()
            : null;

        final result = recalcRating(
          previous: previous,
          newScore: score,
          currentAvg: film.avgRating,
          currentCount: film.ratingsCount,
        );

        tx.set(ratingRef, {
          'score': score,
          'review': review,
          'authorName': user.displayName,
          'createdAt': FieldValue.serverTimestamp(),
        });
        tx.update(filmRef, {
          'avgRating': result.avg,
          'ratingsCount': result.count,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
    } on FirebaseException catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<void> deleteMyRating(String filmId, String uid) async {
    final filmRef = _films.doc(filmId);
    final ratingRef = filmRef.collection('ratings').doc(uid);

    try {
      await _firestore.runTransaction((tx) async {
        final filmSnap = await tx.get(filmRef);
        if (!filmSnap.exists) {
          throw const NotFoundException('La película ya no existe');
        }
        final ratingSnap = await tx.get(ratingRef);
        if (!ratingSnap.exists) return; // Nada que borrar.

        final film = Film.fromJson(filmSnap.data()!);
        final previous = (ratingSnap.data()?['score'] as num?)?.toDouble();

        final result = recalcRating(
          previous: previous,
          newScore: null,
          currentAvg: film.avgRating,
          currentCount: film.ratingsCount,
        );

        tx.delete(ratingRef);
        tx.update(filmRef, {
          'avgRating': result.avg,
          'ratingsCount': result.count,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
    } on FirebaseException catch (error) {
      throw _mapError(error);
    }
  }

  /// Traduce errores de Firestore a excepciones tipadas de la app.
  AppException _mapError(FirebaseException error) {
    return switch (error.code) {
      'permission-denied' => const PermissionException(
        'No puedes valorar: verifica tu correo e inténtalo de nuevo',
      ),
      'not-found' => const NotFoundException('La película ya no existe'),
      'unavailable' || 'network-request-failed' => const NetworkException(),
      _ => const UnknownException(),
    };
  }
}
