import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/services/collections.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../shared/models/models.dart';
import '../../domain/repositories/community_repository.dart';

/// Implementación de [CommunityRepository] con Cloud Firestore y subida de
/// medios al hosting propio de la asociación.
///
/// Cada mutación respeta EXACTAMENTE las reglas de seguridad desplegadas:
/// - "Me gusta": un único batch con el doc `likes/{uid}` y `increment(±1)`
///   sobre `likesCount` (delta máximo 1).
/// - Comentar/borrar: un único batch con el doc del comentario y
///   `increment(±1)` sobre `commentsCount`.
/// - Crear post: `likesCount` y `commentsCount` a 0 y `authorUid == miUid`.
/// - Amistades: id determinista `uidMenor_uidMayor`, `uids` ordenados y de
///   tamaño 2, estado inicial `pending` con `requestedBy == miUid`.
class CommunityRepositoryImpl implements CommunityRepository {
  CommunityRepositoryImpl({
    required StorageService storageService,
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  }) : _storage = storageService,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance;

  final StorageService _storage;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _posts =>
      _firestore.collection(Col.posts);

  CollectionReference<Map<String, dynamic>> get _friendships =>
      _firestore.collection(Col.friendships);

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection(Col.users);

  CollectionReference<Map<String, dynamic>> _comments(String postId) =>
      _posts.doc(postId).collection('comments');

  DocumentReference<Map<String, dynamic>> _like(String postId, String uid) =>
      _posts.doc(postId).collection('likes').doc(uid);

  @override
  Stream<List<Post>> watchFeed({required bool memberView, int limit = 30}) {
    // Las reglas evalúan la visibilidad documento a documento. Un socio+
    // puede leer todo, así que no filtra por visibilidad; el resto solo puede
    // leer las públicas, por lo que hay que restringir la consulta o chocaría
    // con un documento no legible.
    Query<Map<String, dynamic>> query = _posts;
    if (!memberView) {
      query = query.where('visibility', isEqualTo: 'public');
    }
    query = query.orderBy('createdAt', descending: true).limit(limit);

    return query.snapshots().map(
      (snap) => snap.docs
          .map((doc) => Post.fromJson(doc.data()).copyWith(id: doc.id))
          .toList(),
    );
  }

  @override
  Stream<List<PostComment>> watchComments(String postId) {
    return _comments(postId)
        .orderBy('createdAt')
        .limit(100)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (doc) => PostComment.fromJson(doc.data()).copyWith(id: doc.id),
              )
              .toList(),
        );
  }

  @override
  Stream<bool> watchMyLike(String postId, String uid) {
    return _like(postId, uid).snapshots().map((doc) => doc.exists);
  }

  @override
  Future<void> createPost({
    required AppUser author,
    required String text,
    required List<String> imageUrls,
    required String visibility,
  }) async {
    try {
      await _posts.add({
        'authorUid': author.id,
        'authorName': author.displayName,
        'authorPhotoUrl': author.photoUrl,
        'text': text,
        'imageUrls': imageUrls,
        'likesCount': 0,
        'commentsCount': 0,
        'visibility': visibility,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<void> toggleLike({
    required String postId,
    required String uid,
    required bool currentlyLiked,
  }) async {
    final batch = _firestore.batch();
    final likeRef = _like(postId, uid);
    final postRef = _posts.doc(postId);

    if (currentlyLiked) {
      batch.delete(likeRef);
      batch.update(postRef, {'likesCount': FieldValue.increment(-1)});
    } else {
      batch.set(likeRef, {'at': FieldValue.serverTimestamp()});
      batch.update(postRef, {'likesCount': FieldValue.increment(1)});
    }

    try {
      await batch.commit();
    } on FirebaseException catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<void> addComment({
    required String postId,
    required AppUser author,
    required String text,
  }) async {
    final batch = _firestore.batch();
    final commentRef = _comments(postId).doc();
    final postRef = _posts.doc(postId);

    batch.set(commentRef, {
      'authorUid': author.id,
      'authorName': author.displayName,
      'authorPhotoUrl': author.photoUrl,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });
    batch.update(postRef, {'commentsCount': FieldValue.increment(1)});

    try {
      await batch.commit();
    } on FirebaseException catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<void> deleteComment(String postId, String commentId) async {
    final batch = _firestore.batch();
    batch.delete(_comments(postId).doc(commentId));
    batch.update(_posts.doc(postId), {
      'commentsCount': FieldValue.increment(-1),
    });

    try {
      await batch.commit();
    } on FirebaseException catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<void> updatePost(
    String postId, {
    required String text,
    required List<String> imageUrls,
  }) async {
    try {
      // El autor solo puede tocar text/imageUrls/updatedAt (no los contadores).
      await _posts.doc(postId).update({
        'text': text,
        'imageUrls': imageUrls,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await _posts.doc(postId).delete();
    } on FirebaseException catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Stream<List<Friendship>> watchFriendships(String uid) {
    return _friendships
        .where('uids', arrayContains: uid)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (doc) => Friendship.fromJson(doc.data()).copyWith(id: doc.id),
              )
              .toList(),
        );
  }

  @override
  Future<void> requestFriendship(String myUid, String otherUid) async {
    // Ordena los uids alfabéticamente y usa un id determinista para evitar
    // solicitudes duplicadas entre el mismo par de usuarios.
    final ordered = [myUid, otherUid]..sort();
    final id = '${ordered.first}_${ordered.last}';
    try {
      await _friendships.doc(id).set({
        'uids': ordered,
        'status': 'pending',
        'requestedBy': myUid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<void> acceptFriendship(String id) async {
    try {
      // Solo se permiten los campos status/updatedAt en la aceptación.
      await _friendships.doc(id).update({
        'status': 'accepted',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<void> removeFriendship(String id) async {
    try {
      await _friendships.doc(id).delete();
    } on FirebaseException catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<AppUser?> fetchUser(String uid) async {
    try {
      final doc = await _users.doc(uid).get();
      final data = doc.data();
      if (!doc.exists || data == null) return null;
      return AppUser.fromJson(data).copyWith(id: doc.id);
    } on FirebaseException catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<List<String>> uploadImages(
    List<({List<int> bytes, String name})> files,
  ) async {
    if (files.isEmpty) return const [];
    try {
      final idToken = await _auth.currentUser?.getIdToken();
      if (idToken == null || idToken.isEmpty) {
        throw const AuthException('Debes iniciar sesión para subir imágenes');
      }

      final urls = <String>[];
      for (final file in files) {
        final bytes = await _compress(file.bytes);
        final url = await _storage.uploadFile(
          bytes: bytes,
          filename: file.name,
          folder: 'posts',
          idToken: idToken,
        );
        urls.add(url);
      }
      return urls;
    } on AppException {
      rethrow;
    } catch (_) {
      throw const StorageException();
    }
  }

  /// Comprime la imagen antes de subirla; si la compresión falla (o no hay
  /// soporte de plataforma) devuelve los bytes originales.
  Future<List<int>> _compress(List<int> bytes) async {
    try {
      final source = bytes is Uint8List ? bytes : Uint8List.fromList(bytes);
      final result = await FlutterImageCompress.compressWithList(
        source,
        quality: 80,
        minWidth: 1600,
        minHeight: 1600,
      );
      if (result.isEmpty) return bytes;
      return result;
    } catch (_) {
      return bytes;
    }
  }

  /// Traduce errores de Firestore a excepciones tipadas de la app.
  AppException _mapError(FirebaseException error) {
    return switch (error.code) {
      'permission-denied' => const PermissionException(
        'No tienes permiso para esta acción en la comunidad',
      ),
      'not-found' => const NotFoundException('El contenido ya no existe'),
      'unavailable' || 'network-request-failed' => const NetworkException(),
      _ => const UnknownException(),
    };
  }
}
