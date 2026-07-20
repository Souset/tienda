import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/services/collections.dart';
import '../../../../shared/models/attendance_record.dart';
import '../../../../shared/models/member.dart';
import '../../domain/repositories/members_repository.dart';

/// Implementación de [MembersRepository] con Cloud Firestore.
///
/// Respeta el contrato de las reglas de seguridad:
/// - `members/{uid}`: lee el propio socio o coordinador+ (check-in manual);
///   `members/{uid}/fees`: lee el propio socio o junta+.
/// - `attendance/{uid}/records`: lee el propio socio o coordinador+.
/// - El check-in (update de la reserva + set del registro de asistencia) lo
///   ejecuta un coordinador+ en un único batch atómico.
class MembersRepositoryImpl implements MembersRepository {
  MembersRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _members =>
      _firestore.collection(Col.members);

  CollectionReference<Map<String, dynamic>> get _events =>
      _firestore.collection(Col.events);

  CollectionReference<Map<String, dynamic>> get _attendance =>
      _firestore.collection(Col.attendance);

  @override
  Stream<Member?> watchMember(String uid) {
    return _members.doc(uid).snapshots().map((doc) {
      final data = doc.data();
      if (!doc.exists || data == null) return null;
      return Member.fromJson(data).copyWith(id: doc.id);
    });
  }

  @override
  Stream<List<MemberFee>> watchFees(String uid) {
    // El id del documento es el año; ordenar por id descendente deja las
    // cuotas más recientes arriba sin necesitar un campo adicional.
    return _members
        .doc(uid)
        .collection('fees')
        .orderBy(FieldPath.documentId, descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => MemberFee.fromJson(doc.data()).copyWith(id: doc.id))
              .toList(),
        );
  }

  @override
  Stream<List<AttendanceRecord>> watchAttendance(String uid) {
    return _attendance
        .doc(uid)
        .collection('records')
        .orderBy('checkedInAt', descending: true)
        .limit(50)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (doc) =>
                    AttendanceRecord.fromJson(doc.data()).copyWith(id: doc.id),
              )
              .toList(),
        );
  }

  @override
  Future<Member?> findByMemberNumber(int number) async {
    try {
      final snap = await _members
          .where('memberNumber', isEqualTo: number)
          .limit(1)
          .get();
      if (snap.docs.isEmpty) return null;
      final doc = snap.docs.first;
      return Member.fromJson(doc.data()).copyWith(id: doc.id);
    } on FirebaseException catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<void> checkIn({
    required String eventId,
    required String eventTitle,
    required String eventType,
    required String uid,
  }) async {
    final reservationRef = _events
        .doc(eventId)
        .collection('reservations')
        .doc(uid);
    final recordRef = _attendance.doc(uid).collection('records').doc(eventId);

    final batch = _firestore.batch();
    batch.update(reservationRef, {
      'status': 'checkedIn',
      'checkedInAt': FieldValue.serverTimestamp(),
    });
    batch.set(recordRef, {
      'eventTitle': eventTitle,
      'eventType': eventType,
      'checkedInAt': FieldValue.serverTimestamp(),
    });

    try {
      await batch.commit();
    } on FirebaseException catch (error) {
      throw _mapError(error);
    }
  }

  /// Traduce errores de Firestore a excepciones tipadas de la app.
  AppException _mapError(FirebaseException error) {
    return switch (error.code) {
      'permission-denied' => const PermissionException(
        'No tienes permisos para validar esta entrada',
      ),
      'not-found' => const NotFoundException(
        'No existe reserva de este socio para el evento',
      ),
      'unavailable' || 'network-request-failed' => const NetworkException(),
      _ => const UnknownException(),
    };
  }
}
