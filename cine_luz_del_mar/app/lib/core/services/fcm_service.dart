import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'collections.dart';

/// Servicio de notificaciones push (Firebase Cloud Messaging).
///
/// Todas las operaciones son tolerantes a fallos: si FCM no está disponible
/// (sin configuración, emulador, web sin vapidKey...) la app NO debe romperse.
/// Los tokens se guardan en `users/{uid}.fcmTokens` para que la Cloud Function
/// de envío sepa a qué dispositivos notificar.
class FcmService {
  FcmService(this._messaging, this._firestore);

  final FirebaseMessaging _messaging;
  final FirebaseFirestore _firestore;

  /// Mensajes recibidos con la app en primer plano.
  Stream<RemoteMessage> get foregroundMessages => FirebaseMessaging.onMessage;

  /// Solicita permiso, obtiene el token y lo asocia al usuario [uid].
  Future<void> syncToken(String uid) async {
    try {
      await _messaging.requestPermission();

      String? token;
      try {
        // En web se necesita un vapidKey; si no está configurado, getToken
        // lanza y lo capturamos sin propagar el error.
        token = await _messaging.getToken();
      } catch (error) {
        debugPrint('FCM getToken falló: $error');
        return;
      }

      if (token == null || token.isEmpty) return;

      await _firestore.collection(Col.users).doc(uid).set({
        'fcmTokens': FieldValue.arrayUnion([token]),
      }, SetOptions(merge: true));
    } catch (error) {
      debugPrint('FCM syncToken falló: $error');
    }
  }

  /// Elimina el token actual del usuario [uid] (p. ej. al cerrar sesión).
  Future<void> removeToken(String uid) async {
    try {
      final token = await _messaging.getToken();
      if (token == null || token.isEmpty) return;

      await _firestore.collection(Col.users).doc(uid).set({
        'fcmTokens': FieldValue.arrayRemove([token]),
      }, SetOptions(merge: true));
    } catch (error) {
      debugPrint('FCM removeToken falló: $error');
    }
  }
}

/// Proveedor del servicio FCM. Usa las instancias por defecto de Firebase.
final fcmServiceProvider = Provider<FcmService>((ref) {
  return FcmService(FirebaseMessaging.instance, FirebaseFirestore.instance);
});
