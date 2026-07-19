import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../config/app_config.dart';
import '../errors/app_exception.dart';

/// Capa de pagos PREPARADA para las futuras suscripciones de socios.
///
/// Mientras `AppConfig.stripeEnabled` sea false la app funciona sin pagos
/// (las cuotas se gestionan a mano por la junta). Al activar Stripe:
///   1. Seguir docs/SETUP.md §9 (cuenta, webhook en Nicalia, secretos).
///   2. Implementar la creación del Checkout en la mini-API PHP
///      (endpoint create_checkout.php) y consumirla desde aquí.
///   3. Compilar con --dart-define=STRIPE_ENABLED=true.
abstract class PaymentService {
  bool get enabled;

  /// Devuelve la URL de pago de la cuota del año indicado para abrirla
  /// en el navegador (Stripe Checkout).
  Future<Uri> createFeeCheckout({required int year, required double amount});
}

/// Implementación inactiva: deja el recorrido de UI preparado sin cobrar.
class DisabledPaymentService implements PaymentService {
  const DisabledPaymentService();

  @override
  bool get enabled => false;

  @override
  Future<Uri> createFeeCheckout({
    required int year,
    required double amount,
  }) async {
    throw const ValidationException(
      'Los pagos en línea todavía no están activados. Puedes pagar la '
      'cuota por transferencia o en cualquier actividad.',
    );
  }
}

/// Esqueleto de la implementación real (se completa al activar Stripe).
class StripePaymentService implements PaymentService {
  const StripePaymentService();

  @override
  bool get enabled => true;

  @override
  Future<Uri> createFeeCheckout({
    required int year,
    required double amount,
  }) async {
    // Al activar Stripe: POST a '${AppConfig.apiBaseUrl}/create_checkout.php'
    // con el ID token y {year, amount}; la API crea la sesión de Checkout
    // con la clave secreta (nunca en la app) y devuelve {url}.
    throw const ValidationException(
      'Falta implementar create_checkout.php en la mini-API (SETUP.md §9).',
    );
  }
}

final paymentServiceProvider = Provider<PaymentService>(
  (ref) => AppConfig.stripeEnabled
      ? const StripePaymentService()
      : const DisabledPaymentService(),
);
