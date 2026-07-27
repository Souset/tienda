import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/services/collections.dart';
import '../../../shared/models/models.dart';
import '../../../core/utils/firestore_streams.dart';

/// Actividades publicadas con localización para pintar en el mapa.
class MapRepository {
  MapRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Stream<List<EventItem>> watchLocatedEvents() {
    final from = DateTime.now().subtract(const Duration(days: 1));
    return _firestore
        .collection(Col.events)
        .where('status', isEqualTo: 'published')
        .where('start', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
        .orderBy('start')
        .limit(100)
        .serverSnapshots()
        .map(
          (snap) =>
              [
                    for (final doc in snap.docs)
                      EventItem.fromJson(doc.data()).copyWith(id: doc.id),
                  ]
                  .where(
                    (e) =>
                        e.venue != null &&
                        (e.venue!.lat != 0 || e.venue!.lng != 0),
                  )
                  .toList(),
        );
  }
}
