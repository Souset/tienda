// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppUser {

@JsonKey(includeFromJson: false, includeToJson: false) String get id; String get displayName; String get email; String? get photoUrl; String get role; String? get bio; List<String> get favoriteGenres; List<String> get fcmTokens; List<String> get favoriteFilms; List<String> get favoriteEvents; List<String> get favoriteResources; List<String> get searchTokens;@NullableTimestampConverter() DateTime? get createdAt;@NullableTimestampConverter() DateTime? get updatedAt;
/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUserCopyWith<AppUser> get copyWith => _$AppUserCopyWithImpl<AppUser>(this as AppUser, _$identity);

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUser&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.bio, bio) || other.bio == bio)&&const DeepCollectionEquality().equals(other.favoriteGenres, favoriteGenres)&&const DeepCollectionEquality().equals(other.fcmTokens, fcmTokens)&&const DeepCollectionEquality().equals(other.favoriteFilms, favoriteFilms)&&const DeepCollectionEquality().equals(other.favoriteEvents, favoriteEvents)&&const DeepCollectionEquality().equals(other.favoriteResources, favoriteResources)&&const DeepCollectionEquality().equals(other.searchTokens, searchTokens)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayName,email,photoUrl,role,bio,const DeepCollectionEquality().hash(favoriteGenres),const DeepCollectionEquality().hash(fcmTokens),const DeepCollectionEquality().hash(favoriteFilms),const DeepCollectionEquality().hash(favoriteEvents),const DeepCollectionEquality().hash(favoriteResources),const DeepCollectionEquality().hash(searchTokens),createdAt,updatedAt);

@override
String toString() {
  return 'AppUser(id: $id, displayName: $displayName, email: $email, photoUrl: $photoUrl, role: $role, bio: $bio, favoriteGenres: $favoriteGenres, fcmTokens: $fcmTokens, favoriteFilms: $favoriteFilms, favoriteEvents: $favoriteEvents, favoriteResources: $favoriteResources, searchTokens: $searchTokens, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AppUserCopyWith<$Res>  {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) _then) = _$AppUserCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String displayName, String email, String? photoUrl, String role, String? bio, List<String> favoriteGenres, List<String> fcmTokens, List<String> favoriteFilms, List<String> favoriteEvents, List<String> favoriteResources, List<String> searchTokens,@NullableTimestampConverter() DateTime? createdAt,@NullableTimestampConverter() DateTime? updatedAt
});




}
/// @nodoc
class _$AppUserCopyWithImpl<$Res>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._self, this._then);

  final AppUser _self;
  final $Res Function(AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = null,Object? email = null,Object? photoUrl = freezed,Object? role = null,Object? bio = freezed,Object? favoriteGenres = null,Object? fcmTokens = null,Object? favoriteFilms = null,Object? favoriteEvents = null,Object? favoriteResources = null,Object? searchTokens = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,favoriteGenres: null == favoriteGenres ? _self.favoriteGenres : favoriteGenres // ignore: cast_nullable_to_non_nullable
as List<String>,fcmTokens: null == fcmTokens ? _self.fcmTokens : fcmTokens // ignore: cast_nullable_to_non_nullable
as List<String>,favoriteFilms: null == favoriteFilms ? _self.favoriteFilms : favoriteFilms // ignore: cast_nullable_to_non_nullable
as List<String>,favoriteEvents: null == favoriteEvents ? _self.favoriteEvents : favoriteEvents // ignore: cast_nullable_to_non_nullable
as List<String>,favoriteResources: null == favoriteResources ? _self.favoriteResources : favoriteResources // ignore: cast_nullable_to_non_nullable
as List<String>,searchTokens: null == searchTokens ? _self.searchTokens : searchTokens // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppUser].
extension AppUserPatterns on AppUser {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppUser value)  $default,){
final _that = this;
switch (_that) {
case _AppUser():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppUser value)?  $default,){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String displayName,  String email,  String? photoUrl,  String role,  String? bio,  List<String> favoriteGenres,  List<String> fcmTokens,  List<String> favoriteFilms,  List<String> favoriteEvents,  List<String> favoriteResources,  List<String> searchTokens, @NullableTimestampConverter()  DateTime? createdAt, @NullableTimestampConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.id,_that.displayName,_that.email,_that.photoUrl,_that.role,_that.bio,_that.favoriteGenres,_that.fcmTokens,_that.favoriteFilms,_that.favoriteEvents,_that.favoriteResources,_that.searchTokens,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String displayName,  String email,  String? photoUrl,  String role,  String? bio,  List<String> favoriteGenres,  List<String> fcmTokens,  List<String> favoriteFilms,  List<String> favoriteEvents,  List<String> favoriteResources,  List<String> searchTokens, @NullableTimestampConverter()  DateTime? createdAt, @NullableTimestampConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AppUser():
return $default(_that.id,_that.displayName,_that.email,_that.photoUrl,_that.role,_that.bio,_that.favoriteGenres,_that.fcmTokens,_that.favoriteFilms,_that.favoriteEvents,_that.favoriteResources,_that.searchTokens,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String displayName,  String email,  String? photoUrl,  String role,  String? bio,  List<String> favoriteGenres,  List<String> fcmTokens,  List<String> favoriteFilms,  List<String> favoriteEvents,  List<String> favoriteResources,  List<String> searchTokens, @NullableTimestampConverter()  DateTime? createdAt, @NullableTimestampConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.id,_that.displayName,_that.email,_that.photoUrl,_that.role,_that.bio,_that.favoriteGenres,_that.fcmTokens,_that.favoriteFilms,_that.favoriteEvents,_that.favoriteResources,_that.searchTokens,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppUser extends AppUser {
  const _AppUser({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', this.displayName = '', this.email = '', this.photoUrl, this.role = 'invitado', this.bio, final  List<String> favoriteGenres = const <String>[], final  List<String> fcmTokens = const <String>[], final  List<String> favoriteFilms = const <String>[], final  List<String> favoriteEvents = const <String>[], final  List<String> favoriteResources = const <String>[], final  List<String> searchTokens = const <String>[], @NullableTimestampConverter() this.createdAt, @NullableTimestampConverter() this.updatedAt}): _favoriteGenres = favoriteGenres,_fcmTokens = fcmTokens,_favoriteFilms = favoriteFilms,_favoriteEvents = favoriteEvents,_favoriteResources = favoriteResources,_searchTokens = searchTokens,super._();
  factory _AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
@override@JsonKey() final  String displayName;
@override@JsonKey() final  String email;
@override final  String? photoUrl;
@override@JsonKey() final  String role;
@override final  String? bio;
 final  List<String> _favoriteGenres;
@override@JsonKey() List<String> get favoriteGenres {
  if (_favoriteGenres is EqualUnmodifiableListView) return _favoriteGenres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_favoriteGenres);
}

 final  List<String> _fcmTokens;
@override@JsonKey() List<String> get fcmTokens {
  if (_fcmTokens is EqualUnmodifiableListView) return _fcmTokens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fcmTokens);
}

 final  List<String> _favoriteFilms;
@override@JsonKey() List<String> get favoriteFilms {
  if (_favoriteFilms is EqualUnmodifiableListView) return _favoriteFilms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_favoriteFilms);
}

 final  List<String> _favoriteEvents;
@override@JsonKey() List<String> get favoriteEvents {
  if (_favoriteEvents is EqualUnmodifiableListView) return _favoriteEvents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_favoriteEvents);
}

 final  List<String> _favoriteResources;
@override@JsonKey() List<String> get favoriteResources {
  if (_favoriteResources is EqualUnmodifiableListView) return _favoriteResources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_favoriteResources);
}

 final  List<String> _searchTokens;
@override@JsonKey() List<String> get searchTokens {
  if (_searchTokens is EqualUnmodifiableListView) return _searchTokens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_searchTokens);
}

@override@NullableTimestampConverter() final  DateTime? createdAt;
@override@NullableTimestampConverter() final  DateTime? updatedAt;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppUserCopyWith<_AppUser> get copyWith => __$AppUserCopyWithImpl<_AppUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppUser&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.bio, bio) || other.bio == bio)&&const DeepCollectionEquality().equals(other._favoriteGenres, _favoriteGenres)&&const DeepCollectionEquality().equals(other._fcmTokens, _fcmTokens)&&const DeepCollectionEquality().equals(other._favoriteFilms, _favoriteFilms)&&const DeepCollectionEquality().equals(other._favoriteEvents, _favoriteEvents)&&const DeepCollectionEquality().equals(other._favoriteResources, _favoriteResources)&&const DeepCollectionEquality().equals(other._searchTokens, _searchTokens)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayName,email,photoUrl,role,bio,const DeepCollectionEquality().hash(_favoriteGenres),const DeepCollectionEquality().hash(_fcmTokens),const DeepCollectionEquality().hash(_favoriteFilms),const DeepCollectionEquality().hash(_favoriteEvents),const DeepCollectionEquality().hash(_favoriteResources),const DeepCollectionEquality().hash(_searchTokens),createdAt,updatedAt);

@override
String toString() {
  return 'AppUser(id: $id, displayName: $displayName, email: $email, photoUrl: $photoUrl, role: $role, bio: $bio, favoriteGenres: $favoriteGenres, fcmTokens: $fcmTokens, favoriteFilms: $favoriteFilms, favoriteEvents: $favoriteEvents, favoriteResources: $favoriteResources, searchTokens: $searchTokens, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AppUserCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$AppUserCopyWith(_AppUser value, $Res Function(_AppUser) _then) = __$AppUserCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String displayName, String email, String? photoUrl, String role, String? bio, List<String> favoriteGenres, List<String> fcmTokens, List<String> favoriteFilms, List<String> favoriteEvents, List<String> favoriteResources, List<String> searchTokens,@NullableTimestampConverter() DateTime? createdAt,@NullableTimestampConverter() DateTime? updatedAt
});




}
/// @nodoc
class __$AppUserCopyWithImpl<$Res>
    implements _$AppUserCopyWith<$Res> {
  __$AppUserCopyWithImpl(this._self, this._then);

  final _AppUser _self;
  final $Res Function(_AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = null,Object? email = null,Object? photoUrl = freezed,Object? role = null,Object? bio = freezed,Object? favoriteGenres = null,Object? fcmTokens = null,Object? favoriteFilms = null,Object? favoriteEvents = null,Object? favoriteResources = null,Object? searchTokens = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_AppUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,favoriteGenres: null == favoriteGenres ? _self._favoriteGenres : favoriteGenres // ignore: cast_nullable_to_non_nullable
as List<String>,fcmTokens: null == fcmTokens ? _self._fcmTokens : fcmTokens // ignore: cast_nullable_to_non_nullable
as List<String>,favoriteFilms: null == favoriteFilms ? _self._favoriteFilms : favoriteFilms // ignore: cast_nullable_to_non_nullable
as List<String>,favoriteEvents: null == favoriteEvents ? _self._favoriteEvents : favoriteEvents // ignore: cast_nullable_to_non_nullable
as List<String>,favoriteResources: null == favoriteResources ? _self._favoriteResources : favoriteResources // ignore: cast_nullable_to_non_nullable
as List<String>,searchTokens: null == searchTokens ? _self._searchTokens : searchTokens // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
