import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/config/user_role.dart';
import 'converters.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

/// Documento `users/{uid}`: perfil público y preferencias del usuario.
///
/// El campo `role` solo lo modifican admin/presidente (reglas de Firestore).
@freezed
abstract class AppUser with _$AppUser {
  const AppUser._();

  const factory AppUser({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    @Default('') String displayName,
    @Default('') String email,
    String? photoUrl,
    @Default('invitado') String role,
    String? bio,
    @Default(<String>[]) List<String> favoriteGenres,
    @Default(<String>[]) List<String> fcmTokens,
    @Default(<String>[]) List<String> favoriteFilms,
    @Default(<String>[]) List<String> favoriteEvents,
    @Default(<String>[]) List<String> favoriteResources,
    @Default(<String>[]) List<String> searchTokens,
    @NullableTimestampConverter() DateTime? createdAt,
    @NullableTimestampConverter() DateTime? updatedAt,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  UserRole get userRole => UserRole.fromId(role);
}
