import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/config/app_config.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/services/collections.dart';
import '../../../shared/models/membership_plan.dart';

/// Packs de socio y pago de cuotas con Stripe Checkout.
///
/// El cobro real lo hace el servidor de Nicalia: `crear_pago.php` crea la
/// sesión de Stripe leyendo el precio del pack en Firestore (el cliente
/// nunca envía importes) y `stripe_webhook.php` confirma el pago, da de
/// alta al socio y marca la cuota como pagada.
class MembershipService {
  MembershipService({FirebaseFirestore? firestore, Dio? dio})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _dio = dio ?? Dio();

  final FirebaseFirestore _firestore;
  final Dio _dio;

  /// Packs activos, ordenados como decidió la junta (campo `order`).
  ///
  /// El filtro `active == true` es obligatorio: las reglas solo permiten
  /// listar packs activos a quien no es junta.
  Stream<List<MembershipPlan>> watchActivePlans() {
    return _firestore
        .collection(Col.membershipPlans)
        .where('active', isEqualTo: true)
        .orderBy('order')
        .snapshots()
        .map(
          (snap) => [
            for (final doc in snap.docs)
              MembershipPlan.fromJson(doc.data()).copyWith(id: doc.id),
          ],
        );
  }

  /// Pide al servidor una sesión de Stripe Checkout para [planId] y
  /// devuelve la URL de pago a la que redirigir al usuario.
  Future<Uri> createCheckout(String planId) async {
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (idToken == null) {
      throw const AuthException('Inicia sesión para hacerte socio');
    }
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '${AppConfig.apiBaseUrl}/crear_pago.php',
        data: {'planId': planId},
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );
      final url = response.data?['url'] as String?;
      final uri = url == null ? null : Uri.tryParse(url);
      if (uri == null) {
        throw const NetworkException('El servidor no devolvió la URL de pago');
      }
      return uri;
    } on DioException catch (e) {
      final message = (e.response?.data is Map)
          ? ((e.response!.data as Map)['error']?.toString() ??
                'Error del servidor de pagos')
          : 'No se pudo contactar con el servidor de pagos';
      throw NetworkException(message);
    }
  }
}
