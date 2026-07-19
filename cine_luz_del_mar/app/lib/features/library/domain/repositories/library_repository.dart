import '../../../../core/config/user_role.dart';
import '../../../../shared/models/models.dart';

/// Contrato de acceso a los recursos de la biblioteca de la asociación.
///
/// La presentación depende solo de esta abstracción; la implementación
/// concreta (Firestore) vive en la capa de datos.
abstract class LibraryRepository {
  /// Recursos visibles para [role], más recientes primero (máx. 100).
  ///
  /// [type] y [category] son filtros opcionales adicionales. El filtro por
  /// `minRole` se resuelve en la implementación según el rango de [role],
  /// ya que las reglas de seguridad filtran por documento (ver
  /// implementación para el detalle de cada rango).
  Stream<List<LibraryResource>> watchResources({
    required UserRole role,
    String? type,
    String? category,
  });
}
