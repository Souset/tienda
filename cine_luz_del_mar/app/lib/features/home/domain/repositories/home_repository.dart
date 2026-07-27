import '../../../../shared/models/models.dart';

/// Contrato de acceso a los datos que alimentan la pantalla de Inicio.
///
/// La presentación depende solo de esta abstracción; la implementación
/// concreta (Firestore) vive en la capa de datos.
abstract class HomeRepository {
  /// Configuración editable del banner y destacados (`app_config/home`).
  Stream<HomeConfig?> watchConfig();

  /// Próximas actividades publicadas, ordenadas por fecha de inicio.
  Stream<List<EventItem>> watchUpcoming({int limit = 10});

  /// Películas destacadas del catálogo.
  Stream<List<Film>> watchFeaturedFilms({int limit = 12});

  /// Últimas noticias publicadas.
  Stream<List<NewsItem>> watchLatestNews({int limit = 6});
}
