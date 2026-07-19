import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/config/app_config.dart';
import 'firebase_options.dart';

/// Inicializa dependencias globales y lanza la app dentro de un ProviderScope.
Future<void> bootstrap(Widget Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es');

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('FlutterError: ${details.exceptionAsString()}');
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Uncaught error: $error');
    return true;
  };

  await _initFirebase();

  runApp(ProviderScope(child: builder()));
}

Future<void> _initFirebase() async {
  try {
    // En web el SDK JS se descarga dinámicamente: si la red lo impide, la
    // app arranca igualmente en vez de quedarse en blanco.
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(const Duration(seconds: 12));
    if (AppConfig.useEmulators) {
      await FirebaseAuth.instance.useAuthEmulator(
        AppConfig.emulatorHost,
        AppConfig.authEmulatorPort,
      );
      FirebaseFirestore.instance.useFirestoreEmulator(
        AppConfig.emulatorHost,
        AppConfig.firestoreEmulatorPort,
      );
    }
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
    );
  } catch (error) {
    // Sin configuración de Firebase (p. ej. previsualización de UI) la app
    // arranca igualmente; las features que requieren backend mostrarán error.
    debugPrint('Firebase no inicializado: $error');
  }
}
