import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/services/collections.dart';
import '../../../../shared/models/models.dart';
import '../../domain/repositories/home_repository.dart';

/// Implementación de [HomeRepository] con Cloud Firestore.
///
/// Regla crítica de seguridad: los usuarios solo pueden leer noticias y
/// eventos con `status == 'published'`, así que toda consulta sobre esas
/// colecciones filtra por ese campo. `app_config` y `films` son de lectura
/// pública.
class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Stream<HomeConfig?> watchConfig() {
    return _firestore.collection(Col.appConfig).doc('home').snapshots().map((
      snap,
    ) {
      final data = snap.data();
      if (!snap.exists || data == null) return null;
      return HomeConfig.fromJson(data);
    });
  }

  @override
  Stream<List<EventItem>> watchUpcoming({int limit = 10}) {
    return _firestore
        .collection(Col.events)
        .where('status', isEqualTo: 'published')
        .where('start', isGreaterThanOrEqualTo: Timestamp.now())
        .orderBy('start')
        .limit(limit)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => EventItem.fromJson(doc.data()).copyWith(id: doc.id))
              .toList(),
        );
  }

  @override
  Stream<List<Film>> watchFeaturedFilms({int limit = 12}) {
    return _firestore
        .collection(Col.films)
        .where('featured', isEqualTo: true)
        .limit(limit)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => Film.fromJson(doc.data()).copyWith(id: doc.id))
              .toList(),
        );
  }

  @override
  Stream<List<NewsItem>> watchLatestNews({int limit = 6}) {
    return _firestore
        .collection(Col.news)
        .where('status', isEqualTo: 'published')
        .orderBy('publishedAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => NewsItem.fromJson(doc.data()).copyWith(id: doc.id))
              .toList(),
        );
  }
}
