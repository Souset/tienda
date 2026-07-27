import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../core/config/user_role.dart';
import '../../../core/services/collections.dart';
import '../../../core/utils/search_tokens.dart';
import '../../../shared/models/models.dart';
import '../domain/search_results.dart';

/// Buscador global sobre los campos `searchTokens` (prefijos normalizados)
/// de cada colección. Lanza las consultas en paralelo y tolera el fallo de
/// cualquiera de ellas (p. ej. por permisos) sin romper el resto.
class SearchRepository {
  SearchRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<SearchResults> search(
    String term, {
    required bool signedIn,
    required UserRole role,
  }) async {
    final token = normalizeSearchTerm(
      term,
    ).split(RegExp(r'[^a-z0-9]+')).where((w) => w.length >= 2);
    if (token.isEmpty) return const SearchResults();
    // Se busca por la palabra más larga (más selectiva) del término.
    final query = token.reduce((a, b) => a.length >= b.length ? a : b);
    final needle = query.length > 15 ? query.substring(0, 15) : query;

    final results = await Future.wait([
      _events(needle),
      _films(needle),
      _news(needle),
      _resources(needle, role),
      signedIn ? _users(needle) : Future.value(const <AppUser>[]),
    ]);

    return SearchResults(
      events: results[0] as List<EventItem>,
      films: results[1] as List<Film>,
      news: results[2] as List<NewsItem>,
      resources: results[3] as List<LibraryResource>,
      users: results[4] as List<AppUser>,
    );
  }

  Future<List<T>> _guarded<T>(
    Future<QuerySnapshot<Map<String, dynamic>>> future,
    T Function(String id, Map<String, dynamic> data) mapper,
  ) async {
    try {
      final snap = await future;
      return [for (final doc in snap.docs) mapper(doc.id, doc.data())];
    } catch (error) {
      debugPrint('Búsqueda parcial fallida: $error');
      return const [];
    }
  }

  Future<List<EventItem>> _events(String needle) => _guarded(
    _firestore
        .collection(Col.events)
        .where('status', isEqualTo: 'published')
        .where('searchTokens', arrayContains: needle)
        .orderBy('start')
        .limit(10)
        .get(),
    (id, data) => EventItem.fromJson(data).copyWith(id: id),
  );

  Future<List<Film>> _films(String needle) => _guarded(
    _firestore
        .collection(Col.films)
        .where('searchTokens', arrayContains: needle)
        .orderBy('title')
        .limit(10)
        .get(),
    (id, data) => Film.fromJson(data).copyWith(id: id),
  );

  Future<List<NewsItem>> _news(String needle) => _guarded(
    _firestore
        .collection(Col.news)
        .where('status', isEqualTo: 'published')
        .where('searchTokens', arrayContains: needle)
        .orderBy('publishedAt', descending: true)
        .limit(10)
        .get(),
    (id, data) => NewsItem.fromJson(data).copyWith(id: id),
  );

  Future<List<LibraryResource>> _resources(String needle, UserRole role) {
    var query = _firestore
        .collection(Col.library)
        .where('searchTokens', arrayContains: needle);
    // El filtro de visibilidad replica las reglas para no recibir denegados.
    if (role.rank < UserRole.socio.rank) {
      query = query.where('minRole', isEqualTo: 'invitado');
    } else if (role.rank < UserRole.coordinador.rank) {
      query = query.where('minRole', whereIn: ['invitado', 'socio']);
    }
    return _guarded(
      query.limit(10).get(),
      (id, data) => LibraryResource.fromJson(data).copyWith(id: id),
    );
  }

  Future<List<AppUser>> _users(String needle) => _guarded(
    _firestore
        .collection(Col.users)
        .where('searchTokens', arrayContains: needle)
        .orderBy('displayName')
        .limit(10)
        .get(),
    (id, data) => AppUser.fromJson(data).copyWith(id: id),
  );
}
