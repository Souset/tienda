// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'film.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Film {

@JsonKey(includeFromJson: false, includeToJson: false) String get id; String get title; int? get year; String? get director; String? get synopsis; String? get posterUrl; List<String> get genres; double get avgRating; int get ratingsCount; bool get featured; List<String> get searchTokens;@NullableTimestampConverter() DateTime? get createdAt;@NullableTimestampConverter() DateTime? get updatedAt;
/// Create a copy of Film
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FilmCopyWith<Film> get copyWith => _$FilmCopyWithImpl<Film>(this as Film, _$identity);

  /// Serializes this Film to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Film&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.year, year) || other.year == year)&&(identical(other.director, director) || other.director == director)&&(identical(other.synopsis, synopsis) || other.synopsis == synopsis)&&(identical(other.posterUrl, posterUrl) || other.posterUrl == posterUrl)&&const DeepCollectionEquality().equals(other.genres, genres)&&(identical(other.avgRating, avgRating) || other.avgRating == avgRating)&&(identical(other.ratingsCount, ratingsCount) || other.ratingsCount == ratingsCount)&&(identical(other.featured, featured) || other.featured == featured)&&const DeepCollectionEquality().equals(other.searchTokens, searchTokens)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,year,director,synopsis,posterUrl,const DeepCollectionEquality().hash(genres),avgRating,ratingsCount,featured,const DeepCollectionEquality().hash(searchTokens),createdAt,updatedAt);

@override
String toString() {
  return 'Film(id: $id, title: $title, year: $year, director: $director, synopsis: $synopsis, posterUrl: $posterUrl, genres: $genres, avgRating: $avgRating, ratingsCount: $ratingsCount, featured: $featured, searchTokens: $searchTokens, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $FilmCopyWith<$Res>  {
  factory $FilmCopyWith(Film value, $Res Function(Film) _then) = _$FilmCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String title, int? year, String? director, String? synopsis, String? posterUrl, List<String> genres, double avgRating, int ratingsCount, bool featured, List<String> searchTokens,@NullableTimestampConverter() DateTime? createdAt,@NullableTimestampConverter() DateTime? updatedAt
});




}
/// @nodoc
class _$FilmCopyWithImpl<$Res>
    implements $FilmCopyWith<$Res> {
  _$FilmCopyWithImpl(this._self, this._then);

  final Film _self;
  final $Res Function(Film) _then;

/// Create a copy of Film
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? year = freezed,Object? director = freezed,Object? synopsis = freezed,Object? posterUrl = freezed,Object? genres = null,Object? avgRating = null,Object? ratingsCount = null,Object? featured = null,Object? searchTokens = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,director: freezed == director ? _self.director : director // ignore: cast_nullable_to_non_nullable
as String?,synopsis: freezed == synopsis ? _self.synopsis : synopsis // ignore: cast_nullable_to_non_nullable
as String?,posterUrl: freezed == posterUrl ? _self.posterUrl : posterUrl // ignore: cast_nullable_to_non_nullable
as String?,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,avgRating: null == avgRating ? _self.avgRating : avgRating // ignore: cast_nullable_to_non_nullable
as double,ratingsCount: null == ratingsCount ? _self.ratingsCount : ratingsCount // ignore: cast_nullable_to_non_nullable
as int,featured: null == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as bool,searchTokens: null == searchTokens ? _self.searchTokens : searchTokens // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Film].
extension FilmPatterns on Film {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Film value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Film() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Film value)  $default,){
final _that = this;
switch (_that) {
case _Film():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Film value)?  $default,){
final _that = this;
switch (_that) {
case _Film() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String title,  int? year,  String? director,  String? synopsis,  String? posterUrl,  List<String> genres,  double avgRating,  int ratingsCount,  bool featured,  List<String> searchTokens, @NullableTimestampConverter()  DateTime? createdAt, @NullableTimestampConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Film() when $default != null:
return $default(_that.id,_that.title,_that.year,_that.director,_that.synopsis,_that.posterUrl,_that.genres,_that.avgRating,_that.ratingsCount,_that.featured,_that.searchTokens,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String title,  int? year,  String? director,  String? synopsis,  String? posterUrl,  List<String> genres,  double avgRating,  int ratingsCount,  bool featured,  List<String> searchTokens, @NullableTimestampConverter()  DateTime? createdAt, @NullableTimestampConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Film():
return $default(_that.id,_that.title,_that.year,_that.director,_that.synopsis,_that.posterUrl,_that.genres,_that.avgRating,_that.ratingsCount,_that.featured,_that.searchTokens,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String title,  int? year,  String? director,  String? synopsis,  String? posterUrl,  List<String> genres,  double avgRating,  int ratingsCount,  bool featured,  List<String> searchTokens, @NullableTimestampConverter()  DateTime? createdAt, @NullableTimestampConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Film() when $default != null:
return $default(_that.id,_that.title,_that.year,_that.director,_that.synopsis,_that.posterUrl,_that.genres,_that.avgRating,_that.ratingsCount,_that.featured,_that.searchTokens,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Film extends Film {
  const _Film({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', this.title = '', this.year, this.director, this.synopsis, this.posterUrl, final  List<String> genres = const <String>[], this.avgRating = 0, this.ratingsCount = 0, this.featured = false, final  List<String> searchTokens = const <String>[], @NullableTimestampConverter() this.createdAt, @NullableTimestampConverter() this.updatedAt}): _genres = genres,_searchTokens = searchTokens,super._();
  factory _Film.fromJson(Map<String, dynamic> json) => _$FilmFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
@override@JsonKey() final  String title;
@override final  int? year;
@override final  String? director;
@override final  String? synopsis;
@override final  String? posterUrl;
 final  List<String> _genres;
@override@JsonKey() List<String> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}

@override@JsonKey() final  double avgRating;
@override@JsonKey() final  int ratingsCount;
@override@JsonKey() final  bool featured;
 final  List<String> _searchTokens;
@override@JsonKey() List<String> get searchTokens {
  if (_searchTokens is EqualUnmodifiableListView) return _searchTokens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_searchTokens);
}

@override@NullableTimestampConverter() final  DateTime? createdAt;
@override@NullableTimestampConverter() final  DateTime? updatedAt;

/// Create a copy of Film
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FilmCopyWith<_Film> get copyWith => __$FilmCopyWithImpl<_Film>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FilmToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Film&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.year, year) || other.year == year)&&(identical(other.director, director) || other.director == director)&&(identical(other.synopsis, synopsis) || other.synopsis == synopsis)&&(identical(other.posterUrl, posterUrl) || other.posterUrl == posterUrl)&&const DeepCollectionEquality().equals(other._genres, _genres)&&(identical(other.avgRating, avgRating) || other.avgRating == avgRating)&&(identical(other.ratingsCount, ratingsCount) || other.ratingsCount == ratingsCount)&&(identical(other.featured, featured) || other.featured == featured)&&const DeepCollectionEquality().equals(other._searchTokens, _searchTokens)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,year,director,synopsis,posterUrl,const DeepCollectionEquality().hash(_genres),avgRating,ratingsCount,featured,const DeepCollectionEquality().hash(_searchTokens),createdAt,updatedAt);

@override
String toString() {
  return 'Film(id: $id, title: $title, year: $year, director: $director, synopsis: $synopsis, posterUrl: $posterUrl, genres: $genres, avgRating: $avgRating, ratingsCount: $ratingsCount, featured: $featured, searchTokens: $searchTokens, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FilmCopyWith<$Res> implements $FilmCopyWith<$Res> {
  factory _$FilmCopyWith(_Film value, $Res Function(_Film) _then) = __$FilmCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String title, int? year, String? director, String? synopsis, String? posterUrl, List<String> genres, double avgRating, int ratingsCount, bool featured, List<String> searchTokens,@NullableTimestampConverter() DateTime? createdAt,@NullableTimestampConverter() DateTime? updatedAt
});




}
/// @nodoc
class __$FilmCopyWithImpl<$Res>
    implements _$FilmCopyWith<$Res> {
  __$FilmCopyWithImpl(this._self, this._then);

  final _Film _self;
  final $Res Function(_Film) _then;

/// Create a copy of Film
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? year = freezed,Object? director = freezed,Object? synopsis = freezed,Object? posterUrl = freezed,Object? genres = null,Object? avgRating = null,Object? ratingsCount = null,Object? featured = null,Object? searchTokens = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Film(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,director: freezed == director ? _self.director : director // ignore: cast_nullable_to_non_nullable
as String?,synopsis: freezed == synopsis ? _self.synopsis : synopsis // ignore: cast_nullable_to_non_nullable
as String?,posterUrl: freezed == posterUrl ? _self.posterUrl : posterUrl // ignore: cast_nullable_to_non_nullable
as String?,genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,avgRating: null == avgRating ? _self.avgRating : avgRating // ignore: cast_nullable_to_non_nullable
as double,ratingsCount: null == ratingsCount ? _self.ratingsCount : ratingsCount // ignore: cast_nullable_to_non_nullable
as int,featured: null == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as bool,searchTokens: null == searchTokens ? _self._searchTokens : searchTokens // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$FilmRating {

@JsonKey(includeFromJson: false, includeToJson: false) String get id; double get score; String? get review; String? get authorName;@NullableTimestampConverter() DateTime? get createdAt;
/// Create a copy of FilmRating
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FilmRatingCopyWith<FilmRating> get copyWith => _$FilmRatingCopyWithImpl<FilmRating>(this as FilmRating, _$identity);

  /// Serializes this FilmRating to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilmRating&&(identical(other.id, id) || other.id == id)&&(identical(other.score, score) || other.score == score)&&(identical(other.review, review) || other.review == review)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,score,review,authorName,createdAt);

@override
String toString() {
  return 'FilmRating(id: $id, score: $score, review: $review, authorName: $authorName, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $FilmRatingCopyWith<$Res>  {
  factory $FilmRatingCopyWith(FilmRating value, $Res Function(FilmRating) _then) = _$FilmRatingCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, double score, String? review, String? authorName,@NullableTimestampConverter() DateTime? createdAt
});




}
/// @nodoc
class _$FilmRatingCopyWithImpl<$Res>
    implements $FilmRatingCopyWith<$Res> {
  _$FilmRatingCopyWithImpl(this._self, this._then);

  final FilmRating _self;
  final $Res Function(FilmRating) _then;

/// Create a copy of FilmRating
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? score = null,Object? review = freezed,Object? authorName = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,review: freezed == review ? _self.review : review // ignore: cast_nullable_to_non_nullable
as String?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FilmRating].
extension FilmRatingPatterns on FilmRating {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FilmRating value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FilmRating() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FilmRating value)  $default,){
final _that = this;
switch (_that) {
case _FilmRating():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FilmRating value)?  $default,){
final _that = this;
switch (_that) {
case _FilmRating() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  double score,  String? review,  String? authorName, @NullableTimestampConverter()  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FilmRating() when $default != null:
return $default(_that.id,_that.score,_that.review,_that.authorName,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  double score,  String? review,  String? authorName, @NullableTimestampConverter()  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _FilmRating():
return $default(_that.id,_that.score,_that.review,_that.authorName,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  double score,  String? review,  String? authorName, @NullableTimestampConverter()  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _FilmRating() when $default != null:
return $default(_that.id,_that.score,_that.review,_that.authorName,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FilmRating extends FilmRating {
  const _FilmRating({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', this.score = 0, this.review, this.authorName, @NullableTimestampConverter() this.createdAt}): super._();
  factory _FilmRating.fromJson(Map<String, dynamic> json) => _$FilmRatingFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
@override@JsonKey() final  double score;
@override final  String? review;
@override final  String? authorName;
@override@NullableTimestampConverter() final  DateTime? createdAt;

/// Create a copy of FilmRating
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FilmRatingCopyWith<_FilmRating> get copyWith => __$FilmRatingCopyWithImpl<_FilmRating>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FilmRatingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FilmRating&&(identical(other.id, id) || other.id == id)&&(identical(other.score, score) || other.score == score)&&(identical(other.review, review) || other.review == review)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,score,review,authorName,createdAt);

@override
String toString() {
  return 'FilmRating(id: $id, score: $score, review: $review, authorName: $authorName, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$FilmRatingCopyWith<$Res> implements $FilmRatingCopyWith<$Res> {
  factory _$FilmRatingCopyWith(_FilmRating value, $Res Function(_FilmRating) _then) = __$FilmRatingCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, double score, String? review, String? authorName,@NullableTimestampConverter() DateTime? createdAt
});




}
/// @nodoc
class __$FilmRatingCopyWithImpl<$Res>
    implements _$FilmRatingCopyWith<$Res> {
  __$FilmRatingCopyWithImpl(this._self, this._then);

  final _FilmRating _self;
  final $Res Function(_FilmRating) _then;

/// Create a copy of FilmRating
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? score = null,Object? review = freezed,Object? authorName = freezed,Object? createdAt = freezed,}) {
  return _then(_FilmRating(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,review: freezed == review ? _self.review : review // ignore: cast_nullable_to_non_nullable
as String?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
