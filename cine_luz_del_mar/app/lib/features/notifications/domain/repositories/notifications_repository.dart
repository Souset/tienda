import '../../../../shared/models/models.dart';

/// Contrato de acceso a las notificaciones personales del usuario.
///
/// La presentación depende solo de esta abstracción; la implementación
/// concreta (Firestore) vive en la capa de datos.
abstract class NotificationsRepository {
  /// Bandeja de notificaciones del usuario, más recientes primero (máx. 50).
  Stream<List<AppNotification>> watchInbox(String uid);

  /// Marca una notificación como leída (única modificación permitida por
  /// las reglas de seguridad: el campo `read`).
  Future<void> markRead(String uid, String id);

  /// Marca como leídas todas las notificaciones no leídas del usuario.
  Future<void> markAllRead(String uid);

  /// Elimina una notificación (solo el propietario puede hacerlo).
  Future<void> delete(String uid, String id);

  /// Número de notificaciones no leídas (limitado a 99 para el badge).
  Stream<int> watchUnreadCount(String uid);
}
