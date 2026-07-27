import 'package:cloud_firestore/cloud_firestore.dart';

/// Streams de Firestore que no confunden "sin conexión" con "sin datos".
///
/// Cuando el cliente no puede alcanzar el servidor, el SDK emite una
/// instantánea DE CACHÉ que puede estar vacía; sin este filtro, las
/// pantallas mostrarían un estado vacío engañoso ("no hay noticias") en
/// lugar de seguir cargando. Las instantáneas de caché CON datos sí se
/// emiten (arranque instantáneo offline).
extension QueryServerSnapshots on Query<Map<String, dynamic>> {
  Stream<QuerySnapshot<Map<String, dynamic>>> serverSnapshots() => snapshots()
      .where((snap) => !(snap.metadata.isFromCache && snap.docs.isEmpty));
}

extension DocServerSnapshots on DocumentReference<Map<String, dynamic>> {
  Stream<DocumentSnapshot<Map<String, dynamic>>> serverSnapshots() =>
      snapshots().where((snap) => !(snap.metadata.isFromCache && !snap.exists));
}
