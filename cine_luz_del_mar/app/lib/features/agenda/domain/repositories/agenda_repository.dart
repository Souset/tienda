import '../../../../shared/models/app_user.dart';
import '../../../../shared/models/event_item.dart';

/// Contrato de la capa de agenda (eventos y reservas).
///
/// La presentación depende solo de esta abstracción; la implementación
/// concreta (Firebase) vive en la capa de datos.
abstract class AgendaRepository {
  /// Próximos eventos publicados (desde [from] o ayer), ordenados por fecha.
  Stream<List<EventItem>> watchUpcoming({DateTime? from});

  /// Eventos publicados dentro del mes indicado, ordenados por fecha.
  Stream<List<EventItem>> watchByMonth(DateTime month);

  /// Detalle reactivo de un evento concreto (null si no existe).
  Stream<EventItem?> watchEvent(String id);

  /// Reserva del usuario [uid] para el evento [eventId] (null si no tiene).
  Stream<Reservation?> watchMyReservation(String eventId, String uid);

  /// Reserva una plaza para [user] en [event].
  ///
  /// Lanza [CapacityException] si el aforo ya está completo.
  Future<void> reserve(EventItem event, AppUser user);

  /// Cancela la reserva del usuario [uid] en el evento [eventId].
  Future<void> cancelReservation(String eventId, String uid);

  /// Valora un evento ya celebrado (1-5) actualizando los agregados
  /// feedbackAvg/feedbackCount en la misma transacción.
  Future<void> rateEvent({
    required String eventId,
    required String uid,
    required double score,
    String? comment,
  });

  /// Valoración propia de un evento (null si aún no se valoró).
  Stream<double?> watchMyEventScore(String eventId, String uid);
}
