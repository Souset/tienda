import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Notifica a GoRouter cada vez que cambia el estado de sesión.
///
/// Escucha `authStateChanges` de FirebaseAuth y notifica a sus oyentes para
/// que el `redirect` global se reevalúe. Tolera que Firebase no esté
/// inicializado (previsualización de UI sin backend).
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream() {
    notifyListeners();
    try {
      _subscription = FirebaseAuth.instance.authStateChanges().listen(
        (_) => notifyListeners(),
      );
    } catch (error) {
      debugPrint('GoRouterRefreshStream sin FirebaseAuth: $error');
    }
  }

  StreamSubscription<User?>? _subscription;

  /// Fuerza una reevaluación del redirect (p. ej. al emitir sessionProvider).
  void notify() => notifyListeners();

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
