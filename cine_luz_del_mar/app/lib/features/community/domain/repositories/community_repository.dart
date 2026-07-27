import '../../../../shared/models/models.dart';

/// Contrato de acceso al muro social de la asociación (publicaciones,
/// comentarios, "me gusta" y amistades entre socios).
///
/// La presentación depende solo de esta abstracción; la implementación
/// concreta (Firestore + subida de medios al hosting) vive en la capa de datos.
abstract class CommunityRepository {
  /// Feed de publicaciones, más recientes primero.
  ///
  /// [memberView] indica si el usuario puede ver publicaciones de socios
  /// (rol socio o superior): si es `true` no se filtra por visibilidad; si es
  /// `false` (invitados o sin sesión) solo se listan las públicas.
  Stream<List<Post>> watchFeed({required bool memberView, int limit = 30});

  /// Comentarios de una publicación, más antiguos primero (máx. 100).
  Stream<List<PostComment>> watchComments(String postId);

  /// Indica si [uid] ha dado "me gusta" a la publicación [postId].
  Stream<bool> watchMyLike(String postId, String uid);

  /// Crea una nueva publicación firmada por [author].
  Future<void> createPost({
    required AppUser author,
    required String text,
    required List<String> imageUrls,
    required String visibility,
  });

  /// Alterna el "me gusta" de [uid] sobre la publicación [postId] de forma
  /// atómica (documento de like + contador).
  Future<void> toggleLike({
    required String postId,
    required String uid,
    required bool currentlyLiked,
  });

  /// Añade un comentario firmado por [author] a la publicación [postId].
  Future<void> addComment({
    required String postId,
    required AppUser author,
    required String text,
  });

  /// Borra un comentario y decrementa el contador de la publicación.
  Future<void> deleteComment(String postId, String commentId);

  /// Edita el texto y las imágenes de una publicación (solo su autor).
  Future<void> updatePost(
    String postId, {
    required String text,
    required List<String> imageUrls,
  });

  /// Borra una publicación completa.
  Future<void> deletePost(String postId);

  /// Amistades en las que participa [uid] (aceptadas y pendientes).
  Stream<List<Friendship>> watchFriendships(String uid);

  /// Envía una solicitud de amistad de [myUid] a [otherUid].
  Future<void> requestFriendship(String myUid, String otherUid);

  /// Acepta una solicitud de amistad pendiente (solo el receptor).
  Future<void> acceptFriendship(String id);

  /// Elimina una amistad o solicitud (cualquiera de los dos implicados).
  Future<void> removeFriendship(String id);

  /// Lee el perfil público de un usuario por su uid (null si no existe).
  Future<AppUser?> fetchUser(String uid);

  /// Comprime y sube las imágenes seleccionadas y devuelve sus URLs públicas.
  Future<List<String>> uploadImages(
    List<({List<int> bytes, String name})> files,
  );
}
