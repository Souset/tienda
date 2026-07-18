import 'package:firebase_core/firebase_core.dart';

/// Opciones de Firebase de DESARROLLO (proyecto demo para la Emulator Suite).
///
/// IMPORTANTE: para producción, ejecuta en tu máquina:
///   dart pub global activate flutterfire_cli
///   flutterfire configure
/// y sustituye este archivo por el generado (docs/SETUP.md, paso 2).
/// Los ids "demo-*" son reconocidos por los emuladores de Firebase y no
/// corresponden a ningún proyecto real.
abstract final class DefaultFirebaseOptions {
  static const FirebaseOptions currentPlatform = FirebaseOptions(
    apiKey: 'demo-api-key',
    appId: '1:000000000000:web:demo',
    messagingSenderId: '000000000000',
    projectId: 'demo-cine-luz-del-mar',
    authDomain: 'demo-cine-luz-del-mar.firebaseapp.com',
  );
}
