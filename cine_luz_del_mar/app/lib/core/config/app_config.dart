/// Configuración global y feature flags de Cine Luz del Mar.
///
/// Los valores se pueden sobrescribir en compilación con --dart-define,
/// p. ej.: flutter run --dart-define=USE_EMULATORS=true
abstract final class AppConfig {
  static const String appName = 'Cine Luz del Mar';

  /// URL base de la mini-API PHP desplegada en el hosting de Nicalia.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://cineluzdelmar.example/api',
  );

  /// Conectar contra la Firebase Emulator Suite local (desarrollo).
  static const bool useEmulators = bool.fromEnvironment('USE_EMULATORS');

  /// Pagos con Stripe: preparado pero desactivado hasta que la asociación
  /// active las suscripciones.
  static const bool stripeEnabled = bool.fromEnvironment('STRIPE_ENABLED');

  /// Sign in with Apple requiere cuenta Apple Developer; se activa cuando
  /// la asociación disponga de ella.
  static const bool appleSignInEnabled = bool.fromEnvironment(
    'APPLE_SIGNIN_ENABLED',
  );

  static const String emulatorHost = String.fromEnvironment(
    'EMULATOR_HOST',
    defaultValue: 'localhost',
  );
  static const int firestoreEmulatorPort = 8080;
  static const int authEmulatorPort = 9099;
}
