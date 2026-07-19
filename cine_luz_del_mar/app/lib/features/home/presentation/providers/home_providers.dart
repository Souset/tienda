import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/models/models.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';

/// Repositorio de la pantalla de Inicio (implementación Firestore).
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl();
});

/// Configuración editable del banner y destacados de Inicio.
final homeConfigProvider = StreamProvider<HomeConfig?>((ref) {
  return ref.watch(homeRepositoryProvider).watchConfig();
});

/// Próximas actividades publicadas.
final upcomingEventsProvider = StreamProvider<List<EventItem>>((ref) {
  return ref.watch(homeRepositoryProvider).watchUpcoming();
});

/// Películas destacadas del catálogo.
final featuredFilmsProvider = StreamProvider<List<Film>>((ref) {
  return ref.watch(homeRepositoryProvider).watchFeaturedFilms();
});

/// Últimas noticias publicadas (versión reducida para Inicio).
final latestNewsProvider = StreamProvider<List<NewsItem>>((ref) {
  return ref.watch(homeRepositoryProvider).watchLatestNews();
});
