import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/config/user_role.dart';
import '../../../../shared/models/app_user.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

/// Repositorio de autenticación (implementación Firebase).
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

/// Sesión reactiva: perfil del usuario autenticado o null.
final sessionProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).watchSession();
});

/// Usuario actual ya resuelto (null mientras carga o sin sesión).
final currentUserProvider = Provider<AppUser?>((ref) {
  return ref.watch(sessionProvider).value;
});

/// Rol del usuario actual (invitado por defecto).
final currentRoleProvider = Provider<UserRole>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.userRole ?? UserRole.invitado;
});

/// Indica si el correo del usuario está verificado.
///
/// Se lee directamente de FirebaseAuth (no del documento) y se recalcula
/// cuando cambia la sesión. Tolera que Firebase no esté inicializado.
final emailVerifiedProvider = Provider<bool>((ref) {
  ref.watch(sessionProvider);
  try {
    return FirebaseAuth.instance.currentUser?.emailVerified ?? false;
  } catch (_) {
    return false;
  }
});

/// Controlador de las acciones de autenticación.
///
/// Expone un [AsyncValue] de estado (cargando/error) que la UI observa para
/// mostrar spinners y traducir errores a SnackBars.
class AuthController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<void> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(action);
  }

  Future<void> login(String email, String password) =>
      _run(() => _repo.signInWithEmail(email, password));

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) => _run(
    () => _repo.registerWithEmail(name: name, email: email, password: password),
  );

  Future<void> google() => _run(_repo.signInWithGoogle);

  Future<void> apple() => _run(_repo.signInWithApple);

  Future<void> reset(String email) =>
      _run(() => _repo.sendPasswordReset(email));

  Future<void> resendVerification() => _run(_repo.sendEmailVerification);

  Future<void> reloadUser() async {
    await _repo.reloadUser();
    ref.invalidate(sessionProvider);
  }

  Future<void> logout() => _run(_repo.signOut);
}

final authControllerProvider =
    NotifierProvider<AuthController, AsyncValue<void>>(AuthController.new);
