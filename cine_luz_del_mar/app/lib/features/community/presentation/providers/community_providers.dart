import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/config/user_role.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../shared/models/models.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/community_repository_impl.dart';
import '../../domain/repositories/community_repository.dart';

/// Repositorio de comunidad (implementación Firestore + hosting).
final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepositoryImpl(
    storageService: ref.watch(storageServiceProvider),
  );
});

/// Feed de publicaciones visible para el rol actual. Un socio+ ve también las
/// publicaciones de socios; el resto solo las públicas.
final feedProvider = StreamProvider<List<Post>>((ref) {
  final memberView = ref.watch(currentRoleProvider).atLeast(UserRole.socio);
  return ref
      .watch(communityRepositoryProvider)
      .watchFeed(memberView: memberView);
});

/// Comentarios de una publicación concreta.
final commentsProvider = StreamProvider.family<List<PostComment>, String>((
  ref,
  postId,
) {
  return ref.watch(communityRepositoryProvider).watchComments(postId);
});

/// Indica si el usuario actual ha dado "me gusta" a la publicación (false sin
/// sesión iniciada).
final myLikeProvider = StreamProvider.family<bool, String>((ref, postId) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(false);
  return ref.watch(communityRepositoryProvider).watchMyLike(postId, user.id);
});

/// Amistades del usuario actual (vacío sin sesión iniciada).
final friendshipsProvider = StreamProvider<List<Friendship>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(const []);
  return ref.watch(communityRepositoryProvider).watchFriendships(user.id);
});

/// Perfil público de un usuario por uid (lectura puntual cacheada por Riverpod)
/// para resolver el nombre/avatar del "otro" en una amistad.
final userProfileProvider = FutureProvider.family<AppUser?, String>((ref, uid) {
  return ref.watch(communityRepositoryProvider).fetchUser(uid);
});

/// Controlador de las acciones de la comunidad (publicar, comentar, "me
/// gusta", editar/borrar y amistades). Expone un [AsyncValue] de estado que la
/// UI observa para spinners y traducción de errores a SnackBars.
class CommunityController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  CommunityRepository get _repo => ref.read(communityRepositoryProvider);

  Future<void> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(action);
  }

  /// Sube las imágenes seleccionadas y devuelve sus URLs (fuera del estado de
  /// carga del controlador, para poder encadenar con la creación del post).
  Future<List<String>> uploadImages(
    List<({List<int> bytes, String name})> files,
  ) {
    return _repo.uploadImages(files);
  }

  Future<void> createPost({
    required AppUser author,
    required String text,
    required List<String> imageUrls,
    required String visibility,
  }) => _run(
    () => _repo.createPost(
      author: author,
      text: text,
      imageUrls: imageUrls,
      visibility: visibility,
    ),
  );

  Future<void> toggleLike({
    required String postId,
    required String uid,
    required bool currentlyLiked,
  }) => _run(
    () => _repo.toggleLike(
      postId: postId,
      uid: uid,
      currentlyLiked: currentlyLiked,
    ),
  );

  Future<void> addComment({
    required String postId,
    required AppUser author,
    required String text,
  }) =>
      _run(() => _repo.addComment(postId: postId, author: author, text: text));

  Future<void> deleteComment(String postId, String commentId) =>
      _run(() => _repo.deleteComment(postId, commentId));

  Future<void> updatePost(
    String postId, {
    required String text,
    required List<String> imageUrls,
  }) => _run(() => _repo.updatePost(postId, text: text, imageUrls: imageUrls));

  Future<void> deletePost(String postId) =>
      _run(() => _repo.deletePost(postId));

  Future<void> requestFriendship(String myUid, String otherUid) =>
      _run(() => _repo.requestFriendship(myUid, otherUid));

  Future<void> acceptFriendship(String id) =>
      _run(() => _repo.acceptFriendship(id));

  Future<void> removeFriendship(String id) =>
      _run(() => _repo.removeFriendship(id));
}

final communityControllerProvider =
    NotifierProvider<CommunityController, AsyncValue<void>>(
      CommunityController.new,
    );
