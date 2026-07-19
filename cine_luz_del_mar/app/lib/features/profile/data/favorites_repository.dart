import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/services/collections.dart';
import '../../../shared/models/models.dart';

/// Favoritos del usuario: listas de ids en users/{uid}
/// (favoriteFilms / favoriteEvents / favoriteResources).
///
/// El perfil se observa vía sessionProvider, así que la UI se actualiza sola
/// al alternar un favorito.
class FavoritesRepository {
  FavoritesRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<void> toggle({
    required String uid,
    required String field, // favoriteFilms | favoriteEvents
    required String itemId,
    required bool isFavorite,
  }) async {
    try {
      await _firestore.collection(Col.users).doc(uid).update({
        field: isFavorite
            ? FieldValue.arrayRemove([itemId])
            : FieldValue.arrayUnion([itemId]),
      });
    } on FirebaseException catch (e) {
      throw e.code == 'permission-denied'
          ? const PermissionException()
          : const NetworkException();
    }
  }

  /// Carga documentos por ids (en bloques de 10, límite de whereIn).
  Future<List<T>> fetchByIds<T>(
    String collection,
    List<String> ids,
    T Function(Map<String, dynamic> data, String id) mapper,
  ) async {
    final results = <T>[];
    for (var i = 0; i < ids.length; i += 10) {
      final chunk = ids.sublist(i, i + 10 > ids.length ? ids.length : i + 10);
      final snap = await _firestore
          .collection(collection)
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      results.addAll([for (final d in snap.docs) mapper(d.data(), d.id)]);
    }
    return results;
  }
}

final favoritesRepositoryProvider = Provider<FavoritesRepository>(
  (ref) => FavoritesRepository(),
);

final favoriteFilmsProvider = FutureProvider.family<List<Film>, List<String>>(
  (ref, ids) => ids.isEmpty
      ? Future.value(const [])
      : ref
            .read(favoritesRepositoryProvider)
            .fetchByIds(
              Col.films,
              ids,
              (data, id) => Film.fromJson(data).copyWith(id: id),
            ),
);

final favoriteEventsProvider =
    FutureProvider.family<List<EventItem>, List<String>>(
      (ref, ids) => ids.isEmpty
          ? Future.value(const [])
          : ref
                .read(favoritesRepositoryProvider)
                .fetchByIds(
                  Col.events,
                  ids,
                  (data, id) => EventItem.fromJson(data).copyWith(id: id),
                ),
    );
