import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/config/app_config.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/services/collections.dart';
import '../../../core/utils/geohash.dart';
import '../../../core/utils/search_tokens.dart';
import '../../../shared/models/models.dart';
import '../domain/admin_stats.dart';

/// Capa de datos del panel de administración: estadísticas, CRUD de
/// contenido, gestión de socios y usuarios, portada y envío de push.
///
/// Las reglas de Firestore hacen de última barrera: aquí no se re-valida el
/// rol (la UI oculta lo que no procede y las reglas deniegan lo indebido).
class AdminRepository {
  AdminRepository({FirebaseFirestore? firestore, Dio? dio})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _dio = dio ?? Dio();

  final FirebaseFirestore _firestore;
  final Dio _dio;
  final Map<String, AppUser> _userCache = {};

  // ---------- Estadísticas ----------

  Future<AdminStats> loadStats() async {
    try {
      final results = await Future.wait([
        _firestore.collection(Col.users).count().get(),
        _firestore
            .collection(Col.members)
            .where('status', isEqualTo: 'active')
            .count()
            .get(),
        _firestore
            .collection(Col.events)
            .where('status', isEqualTo: 'published')
            .where('start', isGreaterThanOrEqualTo: Timestamp.now())
            .count()
            .get(),
        _firestore
            .collection(Col.news)
            .where('status', isEqualTo: 'published')
            .count()
            .get(),
        _firestore.collection(Col.posts).count().get(),
        _firestore.collection(Col.films).count().get(),
      ]);
      return AdminStats(
        users: results[0].count ?? 0,
        activeMembers: results[1].count ?? 0,
        upcomingEvents: results[2].count ?? 0,
        publishedNews: results[3].count ?? 0,
        posts: results[4].count ?? 0,
        films: results[5].count ?? 0,
      );
    } on FirebaseException catch (e) {
      throw _translate(e);
    }
  }

  // ---------- Contenido ----------

  Stream<List<NewsItem>> watchAllNews() => _watchAll(
    Col.news,
    (data, id) => NewsItem.fromJson(data).copyWith(id: id),
    orderBy: 'createdAt',
    descending: true,
  );

  Stream<List<EventItem>> watchAllEvents() => _watchAll(
    Col.events,
    (data, id) => EventItem.fromJson(data).copyWith(id: id),
    orderBy: 'start',
    descending: true,
  );

  Stream<List<Film>> watchAllFilms() => _watchAll(
    Col.films,
    (data, id) => Film.fromJson(data).copyWith(id: id),
    orderBy: 'title',
  );

  Stream<List<LibraryResource>> watchAllLibrary() => _watchAll(
    Col.library,
    (data, id) => LibraryResource.fromJson(data).copyWith(id: id),
    orderBy: 'createdAt',
    descending: true,
  );

  Stream<List<T>> _watchAll<T>(
    String collection,
    T Function(Map<String, dynamic> data, String id) mapper, {
    required String orderBy,
    bool descending = false,
  }) {
    return _firestore
        .collection(collection)
        .orderBy(orderBy, descending: descending)
        .limit(200)
        .snapshots()
        .map(
          (snap) => [for (final doc in snap.docs) mapper(doc.data(), doc.id)],
        );
  }

  Future<void> saveNews(NewsItem item) async {
    final data = item.toJson()
      ..['searchTokens'] = buildSearchTokens([item.title])
      ..['updatedAt'] = FieldValue.serverTimestamp();
    if (item.status == 'published' && item.publishedAt == null) {
      data['publishedAt'] = FieldValue.serverTimestamp();
    }
    await _save(Col.news, item.id, data);
  }

  Future<void> saveEvent(EventItem item) async {
    final venue = item.venue;
    final data = item.toJson()
      ..['searchTokens'] = buildSearchTokens([item.title, item.type])
      ..['updatedAt'] = FieldValue.serverTimestamp();
    if (venue != null && (venue.lat != 0 || venue.lng != 0)) {
      data['venue'] = venue
          .copyWith(geohash: encodeGeohash(venue.lat, venue.lng))
          .toJson();
    }
    await _save(Col.events, item.id, data);
  }

  Future<void> saveFilm(Film item) => _save(
    Col.films,
    item.id,
    item.toJson()
      ..['searchTokens'] = buildSearchTokens([item.title, item.director ?? ''])
      ..['updatedAt'] = FieldValue.serverTimestamp(),
  );

  Future<void> saveResource(LibraryResource item) => _save(
    Col.library,
    item.id,
    item.toJson()
      ..['searchTokens'] = buildSearchTokens([item.title, item.category ?? ''])
      ..['updatedAt'] = FieldValue.serverTimestamp(),
  );

  Future<void> _save(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      if (id.isEmpty) {
        data['createdAt'] = FieldValue.serverTimestamp();
        await _firestore.collection(collection).add(data);
      } else {
        await _firestore
            .collection(collection)
            .doc(id)
            .set(data, SetOptions(merge: true));
      }
    } on FirebaseException catch (e) {
      throw _translate(e);
    }
  }

  Future<void> deleteDocById(String collection, String id) async {
    try {
      await _firestore.collection(collection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw _translate(e);
    }
  }

  // ---------- Portada ----------

  Future<HomeConfig?> getHomeConfig() async {
    final snap = await _firestore.collection(Col.appConfig).doc('home').get();
    final data = snap.data();
    return data == null ? null : HomeConfig.fromJson(data);
  }

  Future<void> saveHomeConfig(HomeConfig config) async {
    try {
      await _firestore
          .collection(Col.appConfig)
          .doc('home')
          .set(config.toJson(), SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw _translate(e);
    }
  }

  // ---------- Socios ----------

  Stream<List<Member>> watchAllMembers() => _firestore
      .collection(Col.members)
      .orderBy('memberNumber')
      .limit(500)
      .snapshots()
      .map(
        (snap) => [
          for (final doc in snap.docs)
            Member.fromJson(doc.data()).copyWith(id: doc.id),
        ],
      );

  Stream<List<MemberFee>> watchFees(String uid) => _firestore
      .collection(Col.members)
      .doc(uid)
      .collection('fees')
      .orderBy(FieldPath.documentId, descending: true)
      .snapshots()
      .map(
        (snap) => [
          for (final doc in snap.docs)
            MemberFee.fromJson(doc.data()).copyWith(id: doc.id),
        ],
      );

  /// Alta de socio con numeración correlativa transaccional.
  Future<int> altaSocio(String uid) async {
    try {
      return await _firestore.runTransaction((tx) async {
        final counterRef = _firestore.collection(Col.counters).doc('members');
        final counter = await tx.get(counterRef);
        final next = ((counter.data()?['value'] as num?) ?? 0).toInt() + 1;
        tx.set(_firestore.collection(Col.members).doc(uid), {
          'memberNumber': next,
          'status': 'active',
          'joinedAt': FieldValue.serverTimestamp(),
          'benefits': ['Entrada libre a proyecciones', 'Descuento en talleres'],
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        tx.set(counterRef, {'value': next});
        return next;
      });
    } on FirebaseException catch (e) {
      throw _translate(e);
    }
  }

  Future<void> setMemberStatus(String uid, String status) => _save(
    Col.members,
    uid,
    {'status': status, 'updatedAt': FieldValue.serverTimestamp()},
  );

  Future<void> setFee({
    required String uid,
    required String year,
    required double amount,
    required String status,
    String? method,
  }) async {
    try {
      await _firestore
          .collection(Col.members)
          .doc(uid)
          .collection('fees')
          .doc(year)
          .set({
            'amount': amount,
            'status': status,
            'method': method,
            'paidAt': status == 'paid' ? FieldValue.serverTimestamp() : null,
          }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw _translate(e);
    }
  }

  /// Emite un certificado a un usuario (coordinador+ según reglas).
  Future<void> issueCertificate({
    required String uid,
    required String title,
    required String issuedBy,
    String? eventId,
  }) async {
    try {
      await _firestore.collection(Col.certificates).add({
        'uid': uid,
        'title': title,
        'eventId': eventId,
        'pdfUrl': null,
        'issuedBy': issuedBy,
        'issuedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw _translate(e);
    }
  }

  // ---------- Usuarios ----------

  Stream<List<AppUser>> watchUsers() => _firestore
      .collection(Col.users)
      .orderBy('displayName')
      .limit(300)
      .snapshots()
      .map(
        (snap) => [
          for (final doc in snap.docs)
            AppUser.fromJson(doc.data()).copyWith(id: doc.id),
        ],
      );

  Future<AppUser?> getUser(String uid) async {
    final cached = _userCache[uid];
    if (cached != null) return cached;
    final snap = await _firestore.collection(Col.users).doc(uid).get();
    final data = snap.data();
    if (data == null) return null;
    final user = AppUser.fromJson(data).copyWith(id: uid);
    _userCache[uid] = user;
    return user;
  }

  Future<void> setRole(String uid, String role) async {
    try {
      await _firestore.collection(Col.users).doc(uid).update({'role': role});
      _userCache.remove(uid);
    } on FirebaseException catch (e) {
      throw _translate(e);
    }
  }

  // ---------- Exportación CSV (junta) ----------

  /// CSV de socios con datos de contacto y cuota del año en curso.
  Future<String> exportMembersCsv() async {
    try {
      final year = DateTime.now().year.toString();
      final members = await _firestore
          .collection(Col.members)
          .orderBy('memberNumber')
          .get();
      final buffer = StringBuffer(
        'numero;nombre;email;estado;alta;cuota_$year;importe;pagada_el\n',
      );
      String clean(Object? value) =>
          (value?.toString() ?? '').replaceAll(';', ',').replaceAll('\n', ' ');

      for (final doc in members.docs) {
        final member = Member.fromJson(doc.data()).copyWith(id: doc.id);
        final user = await getUser(doc.id);
        final feeSnap = await _firestore
            .collection(Col.members)
            .doc(doc.id)
            .collection('fees')
            .doc(year)
            .get();
        final fee = feeSnap.data();
        final paidAt = fee?['paidAt'];
        buffer.writeln(
          [
            member.memberNumber.toString().padLeft(4, '0'),
            clean(user?.displayName),
            clean(user?.email),
            member.status,
            member.joinedAt == null
                ? ''
                : '${member.joinedAt!.day}/${member.joinedAt!.month}/${member.joinedAt!.year}',
            clean(fee?['status'] ?? 'sin cuota'),
            clean(fee?['amount'] ?? ''),
            paidAt is Timestamp
                ? '${paidAt.toDate().day}/${paidAt.toDate().month}/${paidAt.toDate().year}'
                : '',
          ].join(';'),
        );
      }
      return buffer.toString();
    } on FirebaseException catch (e) {
      throw _translate(e);
    }
  }

  // ---------- TMDB (fichas de película) ----------

  static const _tmdbBase = 'https://api.themoviedb.org/3';

  Future<String?> getTmdbKey() async {
    final snap = await _firestore
        .collection(Col.appConfig)
        .doc('features')
        .get();
    final key = snap.data()?['tmdbApiKey'] as String?;
    return (key == null || key.isEmpty) ? null : key;
  }

  Future<void> saveTmdbKey(String key) async {
    try {
      await _firestore.collection(Col.appConfig).doc('features').set({
        'tmdbApiKey': key.trim(),
      }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw _translate(e);
    }
  }

  /// Busca películas en TMDB (título + año + id) en español.
  Future<List<({int id, String title, String? year})>> searchTmdb(
    String query,
    String apiKey,
  ) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '$_tmdbBase/search/movie',
        queryParameters: {
          'query': query,
          'api_key': apiKey,
          'language': 'es-ES',
        },
      );
      final results = (response.data?['results'] as List?) ?? const [];
      return [
        for (final r in results.take(8))
          (
            id: (r['id'] as num).toInt(),
            title: (r['title'] ?? '') as String,
            year: (r['release_date'] as String?)?.split('-').firstOrNull,
          ),
      ];
    } on DioException {
      throw const NetworkException(
        'No se pudo consultar TMDB (¿clave válida?)',
      );
    }
  }

  /// Ficha completa de TMDB: sinopsis, año, dirección, géneros y póster.
  Future<
    ({
      String? synopsis,
      int? year,
      String? director,
      List<String> genres,
      String? posterUrl,
    })
  >
  tmdbDetails(int movieId, String apiKey) async {
    try {
      final results = await Future.wait([
        _dio.get<Map<String, dynamic>>(
          '$_tmdbBase/movie/$movieId',
          queryParameters: {'api_key': apiKey, 'language': 'es-ES'},
        ),
        _dio.get<Map<String, dynamic>>(
          '$_tmdbBase/movie/$movieId/credits',
          queryParameters: {'api_key': apiKey},
        ),
      ]);
      final movie = results[0].data ?? const {};
      final crew = (results[1].data?['crew'] as List?) ?? const [];
      final director =
          crew.cast<Map<String, dynamic>>().firstWhere(
                (c) => c['job'] == 'Director',
                orElse: () => const {},
              )['name']
              as String?;
      final poster = movie['poster_path'] as String?;
      return (
        synopsis: movie['overview'] as String?,
        year: (movie['release_date'] as String?)?.isNotEmpty == true
            ? int.tryParse((movie['release_date'] as String).split('-').first)
            : null,
        director: director,
        genres: [
          for (final g in (movie['genres'] as List?) ?? const [])
            (g['name'] ?? '') as String,
        ],
        posterUrl: poster == null
            ? null
            : 'https://image.tmdb.org/t/p/w500$poster',
      );
    } on DioException {
      throw const NetworkException('No se pudo cargar la ficha de TMDB');
    }
  }

  // ---------- Push ----------

  Future<({int sent, int inbox})> sendPush({
    required String title,
    required String body,
    String? route,
  }) async {
    try {
      final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      if (idToken == null) throw const PermissionException();
      final response = await _dio.post<Map<String, dynamic>>(
        '${AppConfig.apiBaseUrl}/push.php',
        data: {
          'title': title,
          'body': body,
          if (route != null && route.isNotEmpty) 'route': route,
          'audience': 'all',
        },
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );
      final data = response.data ?? const {};
      return (
        sent: (data['sent'] as num?)?.toInt() ?? 0,
        inbox: (data['inbox'] as num?)?.toInt() ?? 0,
      );
    } on DioException catch (e) {
      final message = (e.response?.data is Map)
          ? ((e.response!.data as Map)['error']?.toString() ??
                'Error del servidor')
          : 'No se pudo contactar con la API de Nicalia';
      throw NetworkException(message);
    }
  }

  AppException _translate(FirebaseException e) => switch (e.code) {
    'permission-denied' => const PermissionException(),
    'unavailable' => const NetworkException(),
    'not-found' => const NotFoundException(),
    _ => UnknownException(e.message ?? 'Error inesperado'),
  };
}
