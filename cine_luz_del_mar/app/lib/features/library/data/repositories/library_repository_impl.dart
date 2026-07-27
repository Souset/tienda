import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/config/user_role.dart';
import '../../../../core/services/collections.dart';
import '../../../../shared/models/models.dart';
import '../../domain/repositories/library_repository.dart';
import '../../../../core/utils/firestore_streams.dart';

/// Implementación de [LibraryRepository] con Cloud Firestore.
///
/// Regla crítica de seguridad: `library/{id}` solo se puede leer si el rango
/// del usuario es mayor o igual que el `minRole` del documento. Como las
/// reglas filtran por documento (no pueden comparar rangos en una consulta),
/// el cliente debe restringir la consulta a los rangos de `minRole` que le
/// resulten legibles según su rol, o la query fallaría al chocar con un
/// documento no permitido:
/// - invitado (o sin sesión): solo `minRole == 'invitado'`.
/// - socio: `minRole in ['invitado', 'socio']`.
/// - coordinador o superior: sin filtro (ve todos los rangos).
class LibraryRepositoryImpl implements LibraryRepository {
  LibraryRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Stream<List<LibraryResource>> watchResources({
    required UserRole role,
    String? type,
    String? category,
  }) {
    Query<Map<String, dynamic>> query = _firestore.collection(Col.library);

    if (role == UserRole.socio) {
      query = query.where('minRole', whereIn: ['invitado', 'socio']);
    } else if (!role.atLeast(UserRole.coordinador)) {
      // Invitado (o cualquier rango por debajo de socio, incluida la
      // ausencia de sesión) solo ve el material público.
      query = query.where('minRole', isEqualTo: 'invitado');
    }
    // Coordinador o superior: sin filtro de minRole, ve todos los rangos.

    if (type != null && type.isNotEmpty) {
      query = query.where('type', isEqualTo: type);
    }
    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }

    query = query.orderBy('createdAt', descending: true).limit(100);

    return query.serverSnapshots().map(
      (snap) => snap.docs
          .map(
            (doc) => LibraryResource.fromJson(doc.data()).copyWith(id: doc.id),
          )
          .toList(),
    );
  }
}
