import '../../../../shared/models/models.dart';

/// Contrato de acceso a las noticias publicadas por la asociación.
///
/// La presentación depende solo de esta abstracción; la implementación
/// concreta (Firestore) vive en la capa de datos.
abstract class NewsRepository {
  /// Noticias publicadas, más recientes primero.
  Stream<List<NewsItem>> watchPublished({int limit = 30});

  /// Una noticia concreta por id (null si no existe).
  Stream<NewsItem?> watchItem(String id);
}
