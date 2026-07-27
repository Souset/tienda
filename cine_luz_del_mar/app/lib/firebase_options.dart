import 'package:firebase_core/firebase_core.dart';

/// Opciones reales del proyecto Firebase de la asociación.
///
/// Proyecto: cine-luz-de-mar (plan Spark). Estos valores son identificadores
/// públicos de la app web (no son secretos). Cuando se registren las apps
/// Android/iOS se añadirán sus opciones específicas con flutterfire.
abstract final class DefaultFirebaseOptions {
  static const FirebaseOptions currentPlatform = FirebaseOptions(
    apiKey: 'AIzaSyBUGpbta0-ycbJyKAgjQa47IQWrjdsorLU',
    appId: '1:445893579526:web:a26c88524d35eaa4124487',
    messagingSenderId: '445893579526',
    projectId: 'cine-luz-de-mar',
    authDomain: 'cine-luz-de-mar.firebaseapp.com',
    storageBucket: 'cine-luz-de-mar.firebasestorage.app',
  );
}
