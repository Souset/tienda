import '../../../../shared/models/app_user.dart';

/// Contrato de la capa de autenticación.
///
/// La presentación depende solo de esta abstracción; la implementación
/// concreta (Firebase) vive en la capa de datos.
abstract class AuthRepository {
  /// Emite el usuario de la sesión actual (o null si no hay sesión).
  ///
  /// Combina el estado de FirebaseAuth con el documento `users/{uid}`.
  Stream<AppUser?> watchSession();

  Future<void> signInWithEmail(String email, String password);

  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String password,
  });

  Future<void> signInWithGoogle();

  Future<void> signInWithApple();

  Future<void> sendPasswordReset(String email);

  Future<void> sendEmailVerification();

  /// Recarga el usuario de FirebaseAuth (para refrescar `emailVerified`).
  Future<void> reloadUser();

  Future<void> signOut();
}
