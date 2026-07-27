// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Post {

@JsonKey(includeFromJson: false, includeToJson: false) String get id; String get authorUid; String? get authorName; String? get authorPhotoUrl; String get text; List<String> get imageUrls; int get likesCount; int get commentsCount; String get visibility;@NullableTimestampConverter() DateTime? get createdAt;@NullableTimestampConverter() DateTime? get updatedAt;
/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostCopyWith<Post> get copyWith => _$PostCopyWithImpl<Post>(this as Post, _$identity);

  /// Serializes this Post to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Post&&(identical(other.id, id) || other.id == id)&&(identical(other.authorUid, authorUid) || other.authorUid == authorUid)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorPhotoUrl, authorPhotoUrl) || other.authorPhotoUrl == authorPhotoUrl)&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.commentsCount, commentsCount) || other.commentsCount == commentsCount)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,authorUid,authorName,authorPhotoUrl,text,const DeepCollectionEquality().hash(imageUrls),likesCount,commentsCount,visibility,createdAt,updatedAt);

@override
String toString() {
  return 'Post(id: $id, authorUid: $authorUid, authorName: $authorName, authorPhotoUrl: $authorPhotoUrl, text: $text, imageUrls: $imageUrls, likesCount: $likesCount, commentsCount: $commentsCount, visibility: $visibility, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PostCopyWith<$Res>  {
  factory $PostCopyWith(Post value, $Res Function(Post) _then) = _$PostCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String authorUid, String? authorName, String? authorPhotoUrl, String text, List<String> imageUrls, int likesCount, int commentsCount, String visibility,@NullableTimestampConverter() DateTime? createdAt,@NullableTimestampConverter() DateTime? updatedAt
});




}
/// @nodoc
class _$PostCopyWithImpl<$Res>
    implements $PostCopyWith<$Res> {
  _$PostCopyWithImpl(this._self, this._then);

  final Post _self;
  final $Res Function(Post) _then;

/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? authorUid = null,Object? authorName = freezed,Object? authorPhotoUrl = freezed,Object? text = null,Object? imageUrls = null,Object? likesCount = null,Object? commentsCount = null,Object? visibility = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorUid: null == authorUid ? _self.authorUid : authorUid // ignore: cast_nullable_to_non_nullable
as String,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,authorPhotoUrl: freezed == authorPhotoUrl ? _self.authorPhotoUrl : authorPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,commentsCount: null == commentsCount ? _self.commentsCount : commentsCount // ignore: cast_nullable_to_non_nullable
as int,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Post].
extension PostPatterns on Post {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Post value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Post() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Post value)  $default,){
final _that = this;
switch (_that) {
case _Post():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Post value)?  $default,){
final _that = this;
switch (_that) {
case _Post() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String authorUid,  String? authorName,  String? authorPhotoUrl,  String text,  List<String> imageUrls,  int likesCount,  int commentsCount,  String visibility, @NullableTimestampConverter()  DateTime? createdAt, @NullableTimestampConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Post() when $default != null:
return $default(_that.id,_that.authorUid,_that.authorName,_that.authorPhotoUrl,_that.text,_that.imageUrls,_that.likesCount,_that.commentsCount,_that.visibility,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String authorUid,  String? authorName,  String? authorPhotoUrl,  String text,  List<String> imageUrls,  int likesCount,  int commentsCount,  String visibility, @NullableTimestampConverter()  DateTime? createdAt, @NullableTimestampConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Post():
return $default(_that.id,_that.authorUid,_that.authorName,_that.authorPhotoUrl,_that.text,_that.imageUrls,_that.likesCount,_that.commentsCount,_that.visibility,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String authorUid,  String? authorName,  String? authorPhotoUrl,  String text,  List<String> imageUrls,  int likesCount,  int commentsCount,  String visibility, @NullableTimestampConverter()  DateTime? createdAt, @NullableTimestampConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Post() when $default != null:
return $default(_that.id,_that.authorUid,_that.authorName,_that.authorPhotoUrl,_that.text,_that.imageUrls,_that.likesCount,_that.commentsCount,_that.visibility,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Post extends Post {
  const _Post({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', this.authorUid = '', this.authorName, this.authorPhotoUrl, this.text = '', final  List<String> imageUrls = const <String>[], this.likesCount = 0, this.commentsCount = 0, this.visibility = 'members', @NullableTimestampConverter() this.createdAt, @NullableTimestampConverter() this.updatedAt}): _imageUrls = imageUrls,super._();
  factory _Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
@override@JsonKey() final  String authorUid;
@override final  String? authorName;
@override final  String? authorPhotoUrl;
@override@JsonKey() final  String text;
 final  List<String> _imageUrls;
@override@JsonKey() List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}

@override@JsonKey() final  int likesCount;
@override@JsonKey() final  int commentsCount;
@override@JsonKey() final  String visibility;
@override@NullableTimestampConverter() final  DateTime? createdAt;
@override@NullableTimestampConverter() final  DateTime? updatedAt;

/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostCopyWith<_Post> get copyWith => __$PostCopyWithImpl<_Post>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Post&&(identical(other.id, id) || other.id == id)&&(identical(other.authorUid, authorUid) || other.authorUid == authorUid)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorPhotoUrl, authorPhotoUrl) || other.authorPhotoUrl == authorPhotoUrl)&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.commentsCount, commentsCount) || other.commentsCount == commentsCount)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,authorUid,authorName,authorPhotoUrl,text,const DeepCollectionEquality().hash(_imageUrls),likesCount,commentsCount,visibility,createdAt,updatedAt);

@override
String toString() {
  return 'Post(id: $id, authorUid: $authorUid, authorName: $authorName, authorPhotoUrl: $authorPhotoUrl, text: $text, imageUrls: $imageUrls, likesCount: $likesCount, commentsCount: $commentsCount, visibility: $visibility, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PostCopyWith<$Res> implements $PostCopyWith<$Res> {
  factory _$PostCopyWith(_Post value, $Res Function(_Post) _then) = __$PostCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String authorUid, String? authorName, String? authorPhotoUrl, String text, List<String> imageUrls, int likesCount, int commentsCount, String visibility,@NullableTimestampConverter() DateTime? createdAt,@NullableTimestampConverter() DateTime? updatedAt
});




}
/// @nodoc
class __$PostCopyWithImpl<$Res>
    implements _$PostCopyWith<$Res> {
  __$PostCopyWithImpl(this._self, this._then);

  final _Post _self;
  final $Res Function(_Post) _then;

/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? authorUid = null,Object? authorName = freezed,Object? authorPhotoUrl = freezed,Object? text = null,Object? imageUrls = null,Object? likesCount = null,Object? commentsCount = null,Object? visibility = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Post(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorUid: null == authorUid ? _self.authorUid : authorUid // ignore: cast_nullable_to_non_nullable
as String,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,authorPhotoUrl: freezed == authorPhotoUrl ? _self.authorPhotoUrl : authorPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,commentsCount: null == commentsCount ? _self.commentsCount : commentsCount // ignore: cast_nullable_to_non_nullable
as int,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$PostComment {

@JsonKey(includeFromJson: false, includeToJson: false) String get id; String get authorUid; String? get authorName; String? get authorPhotoUrl; String get text;@NullableTimestampConverter() DateTime? get createdAt;
/// Create a copy of PostComment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostCommentCopyWith<PostComment> get copyWith => _$PostCommentCopyWithImpl<PostComment>(this as PostComment, _$identity);

  /// Serializes this PostComment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostComment&&(identical(other.id, id) || other.id == id)&&(identical(other.authorUid, authorUid) || other.authorUid == authorUid)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorPhotoUrl, authorPhotoUrl) || other.authorPhotoUrl == authorPhotoUrl)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,authorUid,authorName,authorPhotoUrl,text,createdAt);

@override
String toString() {
  return 'PostComment(id: $id, authorUid: $authorUid, authorName: $authorName, authorPhotoUrl: $authorPhotoUrl, text: $text, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PostCommentCopyWith<$Res>  {
  factory $PostCommentCopyWith(PostComment value, $Res Function(PostComment) _then) = _$PostCommentCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String authorUid, String? authorName, String? authorPhotoUrl, String text,@NullableTimestampConverter() DateTime? createdAt
});




}
/// @nodoc
class _$PostCommentCopyWithImpl<$Res>
    implements $PostCommentCopyWith<$Res> {
  _$PostCommentCopyWithImpl(this._self, this._then);

  final PostComment _self;
  final $Res Function(PostComment) _then;

/// Create a copy of PostComment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? authorUid = null,Object? authorName = freezed,Object? authorPhotoUrl = freezed,Object? text = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorUid: null == authorUid ? _self.authorUid : authorUid // ignore: cast_nullable_to_non_nullable
as String,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,authorPhotoUrl: freezed == authorPhotoUrl ? _self.authorPhotoUrl : authorPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PostComment].
extension PostCommentPatterns on PostComment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostComment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostComment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostComment value)  $default,){
final _that = this;
switch (_that) {
case _PostComment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostComment value)?  $default,){
final _that = this;
switch (_that) {
case _PostComment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String authorUid,  String? authorName,  String? authorPhotoUrl,  String text, @NullableTimestampConverter()  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostComment() when $default != null:
return $default(_that.id,_that.authorUid,_that.authorName,_that.authorPhotoUrl,_that.text,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String authorUid,  String? authorName,  String? authorPhotoUrl,  String text, @NullableTimestampConverter()  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _PostComment():
return $default(_that.id,_that.authorUid,_that.authorName,_that.authorPhotoUrl,_that.text,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String authorUid,  String? authorName,  String? authorPhotoUrl,  String text, @NullableTimestampConverter()  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PostComment() when $default != null:
return $default(_that.id,_that.authorUid,_that.authorName,_that.authorPhotoUrl,_that.text,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostComment extends PostComment {
  const _PostComment({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', this.authorUid = '', this.authorName, this.authorPhotoUrl, this.text = '', @NullableTimestampConverter() this.createdAt}): super._();
  factory _PostComment.fromJson(Map<String, dynamic> json) => _$PostCommentFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
@override@JsonKey() final  String authorUid;
@override final  String? authorName;
@override final  String? authorPhotoUrl;
@override@JsonKey() final  String text;
@override@NullableTimestampConverter() final  DateTime? createdAt;

/// Create a copy of PostComment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostCommentCopyWith<_PostComment> get copyWith => __$PostCommentCopyWithImpl<_PostComment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostCommentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostComment&&(identical(other.id, id) || other.id == id)&&(identical(other.authorUid, authorUid) || other.authorUid == authorUid)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorPhotoUrl, authorPhotoUrl) || other.authorPhotoUrl == authorPhotoUrl)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,authorUid,authorName,authorPhotoUrl,text,createdAt);

@override
String toString() {
  return 'PostComment(id: $id, authorUid: $authorUid, authorName: $authorName, authorPhotoUrl: $authorPhotoUrl, text: $text, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PostCommentCopyWith<$Res> implements $PostCommentCopyWith<$Res> {
  factory _$PostCommentCopyWith(_PostComment value, $Res Function(_PostComment) _then) = __$PostCommentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String authorUid, String? authorName, String? authorPhotoUrl, String text,@NullableTimestampConverter() DateTime? createdAt
});




}
/// @nodoc
class __$PostCommentCopyWithImpl<$Res>
    implements _$PostCommentCopyWith<$Res> {
  __$PostCommentCopyWithImpl(this._self, this._then);

  final _PostComment _self;
  final $Res Function(_PostComment) _then;

/// Create a copy of PostComment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? authorUid = null,Object? authorName = freezed,Object? authorPhotoUrl = freezed,Object? text = null,Object? createdAt = freezed,}) {
  return _then(_PostComment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorUid: null == authorUid ? _self.authorUid : authorUid // ignore: cast_nullable_to_non_nullable
as String,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,authorPhotoUrl: freezed == authorPhotoUrl ? _self.authorPhotoUrl : authorPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
