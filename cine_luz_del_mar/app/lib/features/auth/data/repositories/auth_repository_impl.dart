import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/services/collections.dart';
import '../../../../core/utils/search_tokens.dart';
import '../../../../shared/models/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Implementación de [AuthRepository] con Firebase Auth + Cloud Firestore.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final Dio _dio = Dio();

  /// Pide al servidor de la asociación el envío de un correo premium
  /// (plantilla propia, desde el dominio). Devuelve false si no se pudo,
  /// para que el llamante recurra al envío estándar de Firebase.
  Future<bool> _sendBrandedEmail({
    required String tipo,
    String? email,
  }) async {
    try {
      final headers = <String, String>{};
      if (tipo == 'verificacion') {
        final idToken = await _auth.currentUser?.getIdToken();
        if (idToken == null) return false;
        headers['Authorization'] = 'Bearer $idToken';
      }
      await _dio.post<Map<String, dynamic>>(
        '${AppConfig.apiBaseUrl}/enviar_correo.php',
        data: {'tipo': tipo, 'email': ?email},
        options: Options(
          headers: headers,
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );
      return true;
    } on DioException catch (error) {
      // 409 = ya verificado: no hay nada que reenviar (no es un fallo).
      if (error.response?.statusCode == 409) return true;
      debugPrint('Correo premium no disponible: ${error.message}');
      return false;
    } catch (error) {
      debugPrint('Correo premium no disponible: $error');
      return false;
    }
  }

  // google_sign_in v7 exige inicializar la instancia una única vez.
  bool _googleInitialized = false;

  @override
  Stream<AppUser?> watchSession() {
    late final StreamController<AppUser?> controller;
    StreamSubscription<User?>? authSub;
    StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? docSub;

    Future<void> onAuthChanged(User? user) async {
      await docSub?.cancel();
      docSub = null;

      if (user == null) {
        if (!controller.isClosed) controller.add(null);
        return;
      }

      // Garantiza que exista el documento de perfil antes de escucharlo.
      await _ensureUserDoc(user);

      docSub = _firestore
          .collection(Col.users)
          .doc(user.uid)
          .snapshots()
          .listen(
            (snap) {
              if (controller.isClosed) return;
              final data = snap.data();
              if (snap.exists && data != null) {
                controller.add(AppUser.fromJson(data).copyWith(id: user.uid));
              } else {
                controller.add(
                  AppUser(
                    id: user.uid,
                    displayName: user.displayName ?? '',
                    email: user.email ?? '',
                    photoUrl: user.photoURL,
                  ),
                );
              }
            },
            onError: (Object error) {
              debugPrint('watchSession snapshot error: $error');
              if (!controller.isClosed) {
                controller.add(
                  AppUser(
                    id: user.uid,
                    displayName: user.displayName ?? '',
                    email: user.email ?? '',
                    photoUrl: user.photoURL,
                  ),
                );
              }
            },
          );
    }

    controller = StreamController<AppUser?>(
      onListen: () {
        authSub = _auth.authStateChanges().listen(onAuthChanged);
      },
      onCancel: () async {
        await authSub?.cancel();
        await docSub?.cancel();
      },
    );

    return controller.stream;
  }

  /// Crea `users/{uid}` con rol invitado si aún no existe.
  Future<void> _ensureUserDoc(User user) async {
    try {
      final ref = _firestore.collection(Col.users).doc(user.uid);
      final snap = await ref.get();
      if (snap.exists) return;

      final displayName = user.displayName ?? '';
      final email = user.email ?? '';
      await ref.set({
        'displayName': displayName,
        'email': email,
        'photoUrl': user.photoURL,
        'role': 'invitado',
        'searchTokens': buildSearchTokens([displayName, email]),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (error) {
      debugPrint('No se pudo crear el perfil de usuario: $error');
    }
  }

  @override
  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      throw _mapFirebaseError(error);
    }
  }

  @override
  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) throw const AuthException('No se pudo crear la cuenta');

      await user.updateDisplayName(name.trim());
      await _ensureUserDoc(user);
      // El envío del correo de verificación no debe frustrar el registro:
      // la pantalla de verificación permite reenviarlo en cualquier momento.
      // Primero el correo premium del dominio propio; Firebase de respaldo.
      try {
        if (!await _sendBrandedEmail(tipo: 'verificacion')) {
          await user.sendEmailVerification();
        }
      } catch (error) {
        debugPrint('Verificación no enviada (se podrá reenviar): $error');
      }
    } on FirebaseAuthException catch (error) {
      throw _mapFirebaseError(error);
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // google_sign_in v7 en web no soporta authenticate(); se usa el flujo
        // de popup nativo de firebase_auth.
        await _auth.signInWithPopup(GoogleAuthProvider());
        return;
      }

      if (!_googleInitialized) {
        await GoogleSignIn.instance.initialize();
        _googleInitialized = true;
      }

      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw const AuthException('No se obtuvo el token de Google');
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      await _auth.signInWithCredential(credential);
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthException('Inicio de sesión cancelado');
      }
      throw const AuthException('No se pudo iniciar sesión con Google');
    } on FirebaseAuthException catch (error) {
      throw _mapFirebaseError(error);
    }
  }

  @override
  Future<void> signInWithApple() async {
    if (!AppConfig.appleSignInEnabled) {
      throw const AuthException('No disponible todavía');
    }
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );
      await _auth.signInWithCredential(oauthCredential);
    } on SignInWithAppleAuthorizationException {
      throw const AuthException('Inicio de sesión con Apple cancelado');
    } on FirebaseAuthException catch (error) {
      throw _mapFirebaseError(error);
    }
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    if (await _sendBrandedEmail(tipo: 'recuperar', email: email.trim())) {
      return;
    }
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (error) {
      throw _mapFirebaseError(error);
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    if (await _sendBrandedEmail(tipo: 'verificacion')) return;
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (error) {
      throw _mapFirebaseError(error);
    }
  }

  @override
  Future<void> reloadUser() async {
    try {
      await _auth.currentUser?.reload();
    } on FirebaseAuthException catch (error) {
      throw _mapFirebaseError(error);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      if (!kIsWeb && _googleInitialized) {
        await GoogleSignIn.instance.signOut();
      }
    } catch (error) {
      debugPrint('Error al cerrar sesión de Google: $error');
    }
    await _auth.signOut();
  }

  /// Traduce los códigos de FirebaseAuth a mensajes en español.
  AuthException _mapFirebaseError(FirebaseAuthException error) {
    final message = switch (error.code) {
      'user-not-found' => 'No existe ninguna cuenta con ese correo',
      'wrong-password' => 'La contraseña es incorrecta',
      'invalid-credential' => 'Credenciales incorrectas o caducadas',
      'invalid-email' => 'El correo no es válido',
      'user-disabled' => 'Esta cuenta está deshabilitada',
      'email-already-in-use' => 'Ya existe una cuenta con ese correo',
      'weak-password' => 'La contraseña es demasiado débil',
      'operation-not-allowed' => 'Método de acceso no habilitado',
      'too-many-requests' =>
        'Demasiados intentos. Inténtalo de nuevo más tarde',
      'network-request-failed' => 'Sin conexión con el servidor',
      'account-exists-with-different-credential' =>
        'Ya existe una cuenta con otro método de acceso',
      _ => 'No se pudo completar la operación',
    };
    return AuthException(message, code: error.code);
  }
}
