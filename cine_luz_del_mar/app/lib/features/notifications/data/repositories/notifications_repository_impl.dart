import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/services/collections.dart';
import '../../../../shared/models/models.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../../../../core/utils/firestore_streams.dart';

/// Implementación de [NotificationsRepository] con Cloud Firestore.
///
/// Reglas críticas de seguridad: `notifications/{uid}/items` solo lo puede
/// leer y borrar su propietario, y las actualizaciones solo pueden tocar el
/// campo `read`.
class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _items(String uid) =>
      _firestore.collection(Col.notifications).doc(uid).collection('items');

  @override
  Stream<List<AppNotification>> watchInbox(String uid) {
    return _items(uid)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .serverSnapshots()
        .map(
          (snap) => snap.docs
              .map(
                (doc) =>
                    AppNotification.fromJson(doc.data()).copyWith(id: doc.id),
              )
              .toList(),
        );
  }

  @override
  Future<void> markRead(String uid, String id) {
    return _items(uid).doc(id).update({'read': true});
  }

  @override
  Future<void> markAllRead(String uid) async {
    // Solo actualiza las no leídas dentro del alcance de la bandeja (máx. 50).
    final snap = await _items(
      uid,
    ).where('read', isEqualTo: false).limit(50).get();
    if (snap.docs.isEmpty) return;
    final batch = _firestore.batch();
    for (final doc in snap.docs) {
      batch.update(doc.reference, {'read': true});
    }
    await batch.commit();
  }

  @override
  Future<void> delete(String uid, String id) {
    return _items(uid).doc(id).delete();
  }

  @override
  Stream<int> watchUnreadCount(String uid) {
    return _items(uid)
        .where('read', isEqualTo: false)
        .limit(99)
        .serverSnapshots()
        .map((snap) => snap.docs.length);
  }
}
