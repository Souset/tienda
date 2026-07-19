import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/services/collections.dart';
import '../../../shared/models/models.dart';

/// Chat interno de la asociación (directos y grupos) sobre Firestore.
class ChatRepository {
  ChatRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  final Map<String, AppUser> _userCache = {};

  Stream<List<Chat>> watchMyChats(String uid) {
    return _firestore
        .collection(Col.chats)
        .where('memberUids', arrayContains: uid)
        .orderBy('lastMessageAt', descending: true)
        .limit(50)
        .snapshots()
        .map(
          (snap) => [
            for (final doc in snap.docs)
              Chat.fromJson(doc.data()).copyWith(id: doc.id),
          ],
        );
  }

  Stream<List<ChatMessage>> watchMessages(String chatId, {int limit = 30}) {
    return _firestore
        .collection(Col.chats)
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snap) => [
            for (final doc in snap.docs)
              ChatMessage.fromJson(doc.data()).copyWith(id: doc.id),
          ],
        );
  }

  /// Chat directo con id determinista para evitar duplicados.
  Future<String> openDirectChat({
    required String myUid,
    required String otherUid,
  }) async {
    final uids = [myUid, otherUid]..sort();
    final chatId = '${uids[0]}_${uids[1]}';
    try {
      final ref = _firestore.collection(Col.chats).doc(chatId);
      final snap = await ref.get();
      if (!snap.exists) {
        await ref.set({
          'type': 'direct',
          'memberUids': uids,
          'name': null,
          'lastMessageText': null,
          'lastMessageSenderUid': null,
          'lastMessageAt': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return chatId;
    } on FirebaseException catch (e) {
      throw _translate(e);
    }
  }

  Future<void> sendMessage({
    required String chatId,
    required String myUid,
    required String text,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    try {
      final batch = _firestore.batch();
      final chatRef = _firestore.collection(Col.chats).doc(chatId);
      batch.set(chatRef.collection('messages').doc(), {
        'senderUid': myUid,
        'text': trimmed,
        'imageUrl': null,
        'readBy': [myUid],
        'createdAt': FieldValue.serverTimestamp(),
      });
      batch.update(chatRef, {
        'lastMessageText': trimmed,
        'lastMessageSenderUid': myUid,
        'lastMessageAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await batch.commit();
    } on FirebaseException catch (e) {
      throw _translate(e);
    }
  }

  /// Marca como leídos los mensajes ajenos que aún no me incluyen.
  Future<void> markRead({
    required String chatId,
    required String myUid,
    required List<ChatMessage> messages,
  }) async {
    final unread = messages
        .where((m) => m.senderUid != myUid && !m.readBy.contains(myUid))
        .toList();
    if (unread.isEmpty) return;
    try {
      final batch = _firestore.batch();
      for (final message in unread) {
        batch.update(
          _firestore
              .collection(Col.chats)
              .doc(chatId)
              .collection('messages')
              .doc(message.id),
          {
            'readBy': FieldValue.arrayUnion([myUid]),
          },
        );
      }
      await batch.commit();
    } on FirebaseException {
      // Marcar leído es cosmético: no interrumpe la conversación.
    }
  }

  Future<void> deleteMessage(String chatId, String messageId) async {
    try {
      await _firestore
          .collection(Col.chats)
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .delete();
    } on FirebaseException catch (e) {
      throw _translate(e);
    }
  }

  Future<AppUser?> getUser(String uid) async {
    final cached = _userCache[uid];
    if (cached != null) return cached;
    try {
      final snap = await _firestore.collection(Col.users).doc(uid).get();
      final data = snap.data();
      if (data == null) return null;
      final user = AppUser.fromJson(data).copyWith(id: uid);
      _userCache[uid] = user;
      return user;
    } on FirebaseException {
      return null;
    }
  }

  Future<List<AppUser>> listUsers({int limit = 30}) async {
    try {
      final snap = await _firestore
          .collection(Col.users)
          .orderBy('displayName')
          .limit(limit)
          .get();
      return [
        for (final doc in snap.docs)
          AppUser.fromJson(doc.data()).copyWith(id: doc.id),
      ];
    } on FirebaseException catch (e) {
      throw _translate(e);
    }
  }

  AppException _translate(FirebaseException e) => switch (e.code) {
    'permission-denied' => const PermissionException(),
    'unavailable' => const NetworkException(),
    _ => UnknownException(e.message ?? 'Error de chat'),
  };
}
