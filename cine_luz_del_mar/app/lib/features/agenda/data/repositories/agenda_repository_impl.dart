import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/services/collections.dart';
import '../../../../shared/models/app_user.dart';
import '../../../../shared/models/event_item.dart';
import '../../../films/domain/rating_math.dart';
import '../../domain/repositories/agenda_repository.dart';
import '../../../../core/utils/firestore_streams.dart';

/// Implementación de [AgendaRepository] con Cloud Firestore.
///
/// Respeta el contrato de las reglas de seguridad ya desplegadas:
/// los usuarios normales solo pueden leer eventos con `status == 'published'`,
/// y las reservas se escriben en un único batch que ajusta `reservedCount`
/// con un delta exacto de +1 (reserva) o -1 (cancelación).
class AgendaRepositoryImpl implements AgendaRepository {
  AgendaRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _events =>
      _firestore.collection(Col.events);

  /// Convierte un documento de evento en [EventItem] preservando su id.
  EventItem _toEvent(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return EventItem.fromJson(data).copyWith(id: doc.id);
  }

  @override
  Stream<List<EventItem>> watchUpcoming({DateTime? from}) {
    // Por defecto incluye lo de ayer para no ocultar eventos del mismo día.
    final since = from ?? DateTime.now().subtract(const Duration(days: 1));
    return _events
        .where('status', isEqualTo: 'published')
        .where('start', isGreaterThanOrEqualTo: Timestamp.fromDate(since))
        .orderBy('start')
        .limit(50)
        .serverSnapshots()
        .map((snap) => snap.docs.map(_toEvent).toList());
  }

  @override
  Stream<List<EventItem>> watchByMonth(DateTime month) {
    final start = DateTime(month.year, month.month, 1);
    // Primer instante del mes siguiente (exclusivo).
    final end = DateTime(month.year, month.month + 1, 1);
    return _events
        .where('status', isEqualTo: 'published')
        .where('start', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('start', isLessThan: Timestamp.fromDate(end))
        .orderBy('start')
        .serverSnapshots()
        .map((snap) => snap.docs.map(_toEvent).toList());
  }

  @override
  Stream<EventItem?> watchEvent(String id) {
    return _events.doc(id).serverSnapshots().map((doc) {
      if (!doc.exists) return null;
      return _toEvent(doc);
    });
  }

  @override
  Stream<Reservation?> watchMyReservation(String eventId, String uid) {
    return _events
        .doc(eventId)
        .collection('reservations')
        .doc(uid)
        .serverSnapshots()
        .map((doc) {
          final data = doc.data();
          if (!doc.exists || data == null) return null;
          return Reservation.fromJson(data).copyWith(id: doc.id);
        });
  }

  @override
  Future<void> reserve(EventItem event, AppUser user) async {
    // Comprobación optimista antes de tocar Firestore: si el aforo está lleno
    // evitamos un batch que las reglas rechazarían de todos modos.
    if (event.capacity > 0 && event.reservedCount >= event.capacity) {
      throw const CapacityException();
    }

    final eventRef = _events.doc(event.id);
    final reservationRef = eventRef.collection('reservations').doc(user.id);

    final batch = _firestore.batch();
    batch.set(reservationRef, {
      'status': 'active',
      'userName': user.displayName,
      'createdAt': FieldValue.serverTimestamp(),
    });
    batch.update(eventRef, {'reservedCount': FieldValue.increment(1)});

    try {
      await batch.commit();
    } on FirebaseException catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<void> cancelReservation(String eventId, String uid) async {
    final eventRef = _events.doc(eventId);
    final reservationRef = eventRef.collection('reservations').doc(uid);

    final batch = _firestore.batch();
    batch.update(reservationRef, {'status': 'cancelled'});
    batch.update(eventRef, {'reservedCount': FieldValue.increment(-1)});

    try {
      await batch.commit();
    } on FirebaseException catch (error) {
      throw _mapError(error);
    }
  }

  /// Traduce errores de Firestore a excepciones tipadas de la app.
  AppException _mapError(FirebaseException error) {
    return switch (error.code) {
      'permission-denied' => const CapacityException(
        'No se pudo reservar: el evento está completo o no disponible',
      ),
      'not-found' => const NotFoundException('El evento ya no existe'),
      'unavailable' || 'network-request-failed' => const NetworkException(),
      _ => const UnknownException(),
    };
  }

  @override
  Future<void> rateEvent({
    required String eventId,
    required String uid,
    required double score,
    String? comment,
  }) async {
    try {
      final eventRef = _firestore.collection(Col.events).doc(eventId);
      final feedbackRef = eventRef.collection('feedback').doc(uid);
      await _firestore.runTransaction((tx) async {
        final eventSnap = await tx.get(eventRef);
        final previousSnap = await tx.get(feedbackRef);
        final data = eventSnap.data() ?? const {};
        final result = recalcRating(
          previous: previousSnap.exists
              ? ((previousSnap.data()?['score'] as num?)?.toDouble())
              : null,
          newScore: score,
          currentAvg: ((data['feedbackAvg'] as num?) ?? 0).toDouble(),
          currentCount: ((data['feedbackCount'] as num?) ?? 0).toInt(),
        );
        tx.set(feedbackRef, {
          'score': score,
          'comment': comment,
          'createdAt': FieldValue.serverTimestamp(),
        });
        tx.update(eventRef, {
          'feedbackAvg': result.avg,
          'feedbackCount': result.count,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
    } on FirebaseException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Stream<double?> watchMyEventScore(String eventId, String uid) => _firestore
      .collection(Col.events)
      .doc(eventId)
      .collection('feedback')
      .doc(uid)
      .serverSnapshots()
      .map((snap) => (snap.data()?['score'] as num?)?.toDouble());
}
