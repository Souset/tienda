import '../../../../shared/models/attendance_record.dart';
import '../../../../shared/models/member.dart';

/// Contrato de la capa de socios (carné, cuotas, asistencia y check-in).
///
/// La presentación depende solo de esta abstracción; la implementación
/// concreta (Firebase) vive en la capa de datos y respeta las reglas de
/// seguridad ya desplegadas.
abstract class MembersRepository {
  /// Documento de socio `members/{uid}` (null si el usuario no es socio).
  Stream<Member?> watchMember(String uid);

  /// Cuotas anuales del socio, ordenadas por año descendente.
  Stream<List<MemberFee>> watchFees(String uid);

  /// Últimos registros de asistencia del socio (máx. 50), más recientes antes.
  Stream<List<AttendanceRecord>> watchAttendance(String uid);

  /// Busca un socio por su número (`memberNumber`), para el check-in manual.
  ///
  /// Requiere permiso de lectura de la colección `members` (junta+). Lanza
  /// [PermissionException] si el rol no puede listar socios.
  Future<Member?> findByMemberNumber(int number);

  /// Valida la entrada de un socio a un evento (acción de coordinador+).
  ///
  /// En un único batch marca la reserva como `checkedIn` y crea el registro
  /// de asistencia. Lanza [AppException] traducida ante errores de plataforma.
  Future<void> checkIn({
    required String eventId,
    required String eventTitle,
    required String eventType,
    required String uid,
  });
}
