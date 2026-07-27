// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NewsItem {

@JsonKey(includeFromJson: false, includeToJson: false) String get id; String get title; String get body; String? get coverUrl; List<String> get tags; bool get featured; String get status;@NullableTimestampConverter() DateTime? get publishedAt; String get authorUid; List<String> get searchTokens;@NullableTimestampConverter() DateTime? get createdAt;@NullableTimestampConverter() DateTime? get updatedAt;
/// Create a copy of NewsItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewsItemCopyWith<NewsItem> get copyWith => _$NewsItemCopyWithImpl<NewsItem>(this as NewsItem, _$identity);

  /// Serializes this NewsItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewsItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.featured, featured) || other.featured == featured)&&(identical(other.status, status) || other.status == status)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.authorUid, authorUid) || other.authorUid == authorUid)&&const DeepCollectionEquality().equals(other.searchTokens, searchTokens)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,body,coverUrl,const DeepCollectionEquality().hash(tags),featured,status,publishedAt,authorUid,const DeepCollectionEquality().hash(searchTokens),createdAt,updatedAt);

@override
String toString() {
  return 'NewsItem(id: $id, title: $title, body: $body, coverUrl: $coverUrl, tags: $tags, featured: $featured, status: $status, publishedAt: $publishedAt, authorUid: $authorUid, searchTokens: $searchTokens, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $NewsItemCopyWith<$Res>  {
  factory $NewsItemCopyWith(NewsItem value, $Res Function(NewsItem) _then) = _$NewsItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String title, String body, String? coverUrl, List<String> tags, bool featured, String status,@NullableTimestampConverter() DateTime? publishedAt, String authorUid, List<String> searchTokens,@NullableTimestampConverter() DateTime? createdAt,@NullableTimestampConverter() DateTime? updatedAt
});




}
/// @nodoc
class _$NewsItemCopyWithImpl<$Res>
    implements $NewsItemCopyWith<$Res> {
  _$NewsItemCopyWithImpl(this._self, this._then);

  final NewsItem _self;
  final $Res Function(NewsItem) _then;

/// Create a copy of NewsItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? body = null,Object? coverUrl = freezed,Object? tags = null,Object? featured = null,Object? status = null,Object? publishedAt = freezed,Object? authorUid = null,Object? searchTokens = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,featured: null == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,authorUid: null == authorUid ? _self.authorUid : authorUid // ignore: cast_nullable_to_non_nullable
as String,searchTokens: null == searchTokens ? _self.searchTokens : searchTokens // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [NewsItem].
extension NewsItemPatterns on NewsItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NewsItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NewsItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NewsItem value)  $default,){
final _that = this;
switch (_that) {
case _NewsItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NewsItem value)?  $default,){
final _that = this;
switch (_that) {
case _NewsItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String title,  String body,  String? coverUrl,  List<String> tags,  bool featured,  String status, @NullableTimestampConverter()  DateTime? publishedAt,  String authorUid,  List<String> searchTokens, @NullableTimestampConverter()  DateTime? createdAt, @NullableTimestampConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NewsItem() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.coverUrl,_that.tags,_that.featured,_that.status,_that.publishedAt,_that.authorUid,_that.searchTokens,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String title,  String body,  String? coverUrl,  List<String> tags,  bool featured,  String status, @NullableTimestampConverter()  DateTime? publishedAt,  String authorUid,  List<String> searchTokens, @NullableTimestampConverter()  DateTime? createdAt, @NullableTimestampConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _NewsItem():
return $default(_that.id,_that.title,_that.body,_that.coverUrl,_that.tags,_that.featured,_that.status,_that.publishedAt,_that.authorUid,_that.searchTokens,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String title,  String body,  String? coverUrl,  List<String> tags,  bool featured,  String status, @NullableTimestampConverter()  DateTime? publishedAt,  String authorUid,  List<String> searchTokens, @NullableTimestampConverter()  DateTime? createdAt, @NullableTimestampConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _NewsItem() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.coverUrl,_that.tags,_that.featured,_that.status,_that.publishedAt,_that.authorUid,_that.searchTokens,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NewsItem extends NewsItem {
  const _NewsItem({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', this.title = '', this.body = '', this.coverUrl, final  List<String> tags = const <String>[], this.featured = false, this.status = 'draft', @NullableTimestampConverter() this.publishedAt, this.authorUid = '', final  List<String> searchTokens = const <String>[], @NullableTimestampConverter() this.createdAt, @NullableTimestampConverter() this.updatedAt}): _tags = tags,_searchTokens = searchTokens,super._();
  factory _NewsItem.fromJson(Map<String, dynamic> json) => _$NewsItemFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
@override@JsonKey() final  String title;
@override@JsonKey() final  String body;
@override final  String? coverUrl;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override@JsonKey() final  bool featured;
@override@JsonKey() final  String status;
@override@NullableTimestampConverter() final  DateTime? publishedAt;
@override@JsonKey() final  String authorUid;
 final  List<String> _searchTokens;
@override@JsonKey() List<String> get searchTokens {
  if (_searchTokens is EqualUnmodifiableListView) return _searchTokens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_searchTokens);
}

@override@NullableTimestampConverter() final  DateTime? createdAt;
@override@NullableTimestampConverter() final  DateTime? updatedAt;

/// Create a copy of NewsItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewsItemCopyWith<_NewsItem> get copyWith => __$NewsItemCopyWithImpl<_NewsItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NewsItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewsItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.featured, featured) || other.featured == featured)&&(identical(other.status, status) || other.status == status)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.authorUid, authorUid) || other.authorUid == authorUid)&&const DeepCollectionEquality().equals(other._searchTokens, _searchTokens)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,body,coverUrl,const DeepCollectionEquality().hash(_tags),featured,status,publishedAt,authorUid,const DeepCollectionEquality().hash(_searchTokens),createdAt,updatedAt);

@override
String toString() {
  return 'NewsItem(id: $id, title: $title, body: $body, coverUrl: $coverUrl, tags: $tags, featured: $featured, status: $status, publishedAt: $publishedAt, authorUid: $authorUid, searchTokens: $searchTokens, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$NewsItemCopyWith<$Res> implements $NewsItemCopyWith<$Res> {
  factory _$NewsItemCopyWith(_NewsItem value, $Res Function(_NewsItem) _then) = __$NewsItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String title, String body, String? coverUrl, List<String> tags, bool featured, String status,@NullableTimestampConverter() DateTime? publishedAt, String authorUid, List<String> searchTokens,@NullableTimestampConverter() DateTime? createdAt,@NullableTimestampConverter() DateTime? updatedAt
});




}
/// @nodoc
class __$NewsItemCopyWithImpl<$Res>
    implements _$NewsItemCopyWith<$Res> {
  __$NewsItemCopyWithImpl(this._self, this._then);

  final _NewsItem _self;
  final $Res Function(_NewsItem) _then;

/// Create a copy of NewsItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? body = null,Object? coverUrl = freezed,Object? tags = null,Object? featured = null,Object? status = null,Object? publishedAt = freezed,Object? authorUid = null,Object? searchTokens = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_NewsItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,featured: null == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,authorUid: null == authorUid ? _self.authorUid : authorUid // ignore: cast_nullable_to_non_nullable
as String,searchTokens: null == searchTokens ? _self._searchTokens : searchTokens // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
