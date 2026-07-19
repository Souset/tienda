import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/models/models.dart';
import '../../data/repositories/news_repository_impl.dart';
import '../../domain/repositories/news_repository.dart';

/// Repositorio de noticias (implementación Firestore).
final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return NewsRepositoryImpl();
});

/// Noticias publicadas, más recientes primero.
final publishedNewsProvider = StreamProvider<List<NewsItem>>((ref) {
  return ref.watch(newsRepositoryProvider).watchPublished();
});

/// Una noticia concreta por id.
final newsItemProvider = StreamProvider.family<NewsItem?, String>((ref, id) {
  return ref.watch(newsRepositoryProvider).watchItem(id);
});
