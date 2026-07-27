// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_resource.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryResource {

@JsonKey(includeFromJson: false, includeToJson: false) String get id;/// Tipo de recurso: `document` | `podcast` | `video` | `link`.
 String get type; String get title; String? get description; String get url; String? get category; String? get coverUrl; String get minRole; List<String> get searchTokens;@NullableTimestampConverter() DateTime? get createdAt;@NullableTimestampConverter() DateTime? get updatedAt;
/// Create a copy of LibraryResource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryResourceCopyWith<LibraryResource> get copyWith => _$LibraryResourceCopyWithImpl<LibraryResource>(this as LibraryResource, _$identity);

  /// Serializes this LibraryResource to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryResource&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.url, url) || other.url == url)&&(identical(other.category, category) || other.category == category)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.minRole, minRole) || other.minRole == minRole)&&const DeepCollectionEquality().equals(other.searchTokens, searchTokens)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,description,url,category,coverUrl,minRole,const DeepCollectionEquality().hash(searchTokens),createdAt,updatedAt);

@override
String toString() {
  return 'LibraryResource(id: $id, type: $type, title: $title, description: $description, url: $url, category: $category, coverUrl: $coverUrl, minRole: $minRole, searchTokens: $searchTokens, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $LibraryResourceCopyWith<$Res>  {
  factory $LibraryResourceCopyWith(LibraryResource value, $Res Function(LibraryResource) _then) = _$LibraryResourceCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String type, String title, String? description, String url, String? category, String? coverUrl, String minRole, List<String> searchTokens,@NullableTimestampConverter() DateTime? createdAt,@NullableTimestampConverter() DateTime? updatedAt
});




}
/// @nodoc
class _$LibraryResourceCopyWithImpl<$Res>
    implements $LibraryResourceCopyWith<$Res> {
  _$LibraryResourceCopyWithImpl(this._self, this._then);

  final LibraryResource _self;
  final $Res Function(LibraryResource) _then;

/// Create a copy of LibraryResource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? title = null,Object? description = freezed,Object? url = null,Object? category = freezed,Object? coverUrl = freezed,Object? minRole = null,Object? searchTokens = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,minRole: null == minRole ? _self.minRole : minRole // ignore: cast_nullable_to_non_nullable
as String,searchTokens: null == searchTokens ? _self.searchTokens : searchTokens // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [LibraryResource].
extension LibraryResourcePatterns on LibraryResource {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LibraryResource value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LibraryResource() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LibraryResource value)  $default,){
final _that = this;
switch (_that) {
case _LibraryResource():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LibraryResource value)?  $default,){
final _that = this;
switch (_that) {
case _LibraryResource() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String type,  String title,  String? description,  String url,  String? category,  String? coverUrl,  String minRole,  List<String> searchTokens, @NullableTimestampConverter()  DateTime? createdAt, @NullableTimestampConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LibraryResource() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.description,_that.url,_that.category,_that.coverUrl,_that.minRole,_that.searchTokens,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String type,  String title,  String? description,  String url,  String? category,  String? coverUrl,  String minRole,  List<String> searchTokens, @NullableTimestampConverter()  DateTime? createdAt, @NullableTimestampConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _LibraryResource():
return $default(_that.id,_that.type,_that.title,_that.description,_that.url,_that.category,_that.coverUrl,_that.minRole,_that.searchTokens,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String type,  String title,  String? description,  String url,  String? category,  String? coverUrl,  String minRole,  List<String> searchTokens, @NullableTimestampConverter()  DateTime? createdAt, @NullableTimestampConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _LibraryResource() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.description,_that.url,_that.category,_that.coverUrl,_that.minRole,_that.searchTokens,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LibraryResource extends LibraryResource {
  const _LibraryResource({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', this.type = 'document', this.title = '', this.description, this.url = '', this.category, this.coverUrl, this.minRole = 'invitado', final  List<String> searchTokens = const <String>[], @NullableTimestampConverter() this.createdAt, @NullableTimestampConverter() this.updatedAt}): _searchTokens = searchTokens,super._();
  factory _LibraryResource.fromJson(Map<String, dynamic> json) => _$LibraryResourceFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
/// Tipo de recurso: `document` | `podcast` | `video` | `link`.
@override@JsonKey() final  String type;
@override@JsonKey() final  String title;
@override final  String? description;
@override@JsonKey() final  String url;
@override final  String? category;
@override final  String? coverUrl;
@override@JsonKey() final  String minRole;
 final  List<String> _searchTokens;
@override@JsonKey() List<String> get searchTokens {
  if (_searchTokens is EqualUnmodifiableListView) return _searchTokens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_searchTokens);
}

@override@NullableTimestampConverter() final  DateTime? createdAt;
@override@NullableTimestampConverter() final  DateTime? updatedAt;

/// Create a copy of LibraryResource
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryResourceCopyWith<_LibraryResource> get copyWith => __$LibraryResourceCopyWithImpl<_LibraryResource>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LibraryResourceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryResource&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.url, url) || other.url == url)&&(identical(other.category, category) || other.category == category)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.minRole, minRole) || other.minRole == minRole)&&const DeepCollectionEquality().equals(other._searchTokens, _searchTokens)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,description,url,category,coverUrl,minRole,const DeepCollectionEquality().hash(_searchTokens),createdAt,updatedAt);

@override
String toString() {
  return 'LibraryResource(id: $id, type: $type, title: $title, description: $description, url: $url, category: $category, coverUrl: $coverUrl, minRole: $minRole, searchTokens: $searchTokens, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$LibraryResourceCopyWith<$Res> implements $LibraryResourceCopyWith<$Res> {
  factory _$LibraryResourceCopyWith(_LibraryResource value, $Res Function(_LibraryResource) _then) = __$LibraryResourceCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String type, String title, String? description, String url, String? category, String? coverUrl, String minRole, List<String> searchTokens,@NullableTimestampConverter() DateTime? createdAt,@NullableTimestampConverter() DateTime? updatedAt
});




}
/// @nodoc
class __$LibraryResourceCopyWithImpl<$Res>
    implements _$LibraryResourceCopyWith<$Res> {
  __$LibraryResourceCopyWithImpl(this._self, this._then);

  final _LibraryResource _self;
  final $Res Function(_LibraryResource) _then;

/// Create a copy of LibraryResource
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? title = null,Object? description = freezed,Object? url = null,Object? category = freezed,Object? coverUrl = freezed,Object? minRole = null,Object? searchTokens = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_LibraryResource(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,minRole: null == minRole ? _self.minRole : minRole // ignore: cast_nullable_to_non_nullable
as String,searchTokens: null == searchTokens ? _self._searchTokens : searchTokens // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
