import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/services/collections.dart';
import '../../../../shared/models/models.dart';
import '../../domain/repositories/news_repository.dart';

/// Implementación de [NewsRepository] con Cloud Firestore.
///
/// Regla crítica de seguridad: los usuarios solo pueden leer noticias con
/// `status == 'published'`, así que toda consulta filtra por ese campo.
class NewsRepositoryImpl implements NewsRepository {
  NewsRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Stream<List<NewsItem>> watchPublished({int limit = 30}) {
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

  @override
  Stream<NewsItem?> watchItem(String id) {
    return _firestore.collection(Col.news).doc(id).snapshots().map((snap) {
      final data = snap.data();
      if (!snap.exists || data == null) return null;
      return NewsItem.fromJson(data).copyWith(id: snap.id);
    });
  }
}
