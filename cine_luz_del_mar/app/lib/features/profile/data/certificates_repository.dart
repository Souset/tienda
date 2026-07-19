import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/services/collections.dart';
import '../../../shared/models/models.dart';
import '../../auth/presentation/providers/auth_providers.dart';

/// Certificados emitidos al usuario (colección certificates, uid == mío).
class CertificatesRepository {
  CertificatesRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Stream<List<Certificate>> watchMine(String uid) => _firestore
      .collection(Col.certificates)
      .where('uid', isEqualTo: uid)
      .snapshots()
      .map(
        (snap) =>
            [
              for (final doc in snap.docs)
                Certificate.fromJson(doc.data()).copyWith(id: doc.id),
            ]..sort(
              (a, b) => (b.issuedAt ?? DateTime(2000)).compareTo(
                a.issuedAt ?? DateTime(2000),
              ),
            ),
      );
}

final certificatesRepositoryProvider = Provider<CertificatesRepository>(
  (ref) => CertificatesRepository(),
);

final myCertificatesProvider = StreamProvider<List<Certificate>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(const []);
  return ref.watch(certificatesRepositoryProvider).watchMine(user.id);
});
