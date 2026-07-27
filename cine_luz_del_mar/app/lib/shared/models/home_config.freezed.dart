// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeConfig {

 String? get bannerTitle; String? get bannerSubtitle; String? get bannerImageUrl; String? get bannerRoute; List<String> get featuredFilmIds; List<String> get featuredEventIds; List<String> get featuredNewsIds;
/// Create a copy of HomeConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeConfigCopyWith<HomeConfig> get copyWith => _$HomeConfigCopyWithImpl<HomeConfig>(this as HomeConfig, _$identity);

  /// Serializes this HomeConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeConfig&&(identical(other.bannerTitle, bannerTitle) || other.bannerTitle == bannerTitle)&&(identical(other.bannerSubtitle, bannerSubtitle) || other.bannerSubtitle == bannerSubtitle)&&(identical(other.bannerImageUrl, bannerImageUrl) || other.bannerImageUrl == bannerImageUrl)&&(identical(other.bannerRoute, bannerRoute) || other.bannerRoute == bannerRoute)&&const DeepCollectionEquality().equals(other.featuredFilmIds, featuredFilmIds)&&const DeepCollectionEquality().equals(other.featuredEventIds, featuredEventIds)&&const DeepCollectionEquality().equals(other.featuredNewsIds, featuredNewsIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bannerTitle,bannerSubtitle,bannerImageUrl,bannerRoute,const DeepCollectionEquality().hash(featuredFilmIds),const DeepCollectionEquality().hash(featuredEventIds),const DeepCollectionEquality().hash(featuredNewsIds));

@override
String toString() {
  return 'HomeConfig(bannerTitle: $bannerTitle, bannerSubtitle: $bannerSubtitle, bannerImageUrl: $bannerImageUrl, bannerRoute: $bannerRoute, featuredFilmIds: $featuredFilmIds, featuredEventIds: $featuredEventIds, featuredNewsIds: $featuredNewsIds)';
}


}

/// @nodoc
abstract mixin class $HomeConfigCopyWith<$Res>  {
  factory $HomeConfigCopyWith(HomeConfig value, $Res Function(HomeConfig) _then) = _$HomeConfigCopyWithImpl;
@useResult
$Res call({
 String? bannerTitle, String? bannerSubtitle, String? bannerImageUrl, String? bannerRoute, List<String> featuredFilmIds, List<String> featuredEventIds, List<String> featuredNewsIds
});




}
/// @nodoc
class _$HomeConfigCopyWithImpl<$Res>
    implements $HomeConfigCopyWith<$Res> {
  _$HomeConfigCopyWithImpl(this._self, this._then);

  final HomeConfig _self;
  final $Res Function(HomeConfig) _then;

/// Create a copy of HomeConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bannerTitle = freezed,Object? bannerSubtitle = freezed,Object? bannerImageUrl = freezed,Object? bannerRoute = freezed,Object? featuredFilmIds = null,Object? featuredEventIds = null,Object? featuredNewsIds = null,}) {
  return _then(_self.copyWith(
bannerTitle: freezed == bannerTitle ? _self.bannerTitle : bannerTitle // ignore: cast_nullable_to_non_nullable
as String?,bannerSubtitle: freezed == bannerSubtitle ? _self.bannerSubtitle : bannerSubtitle // ignore: cast_nullable_to_non_nullable
as String?,bannerImageUrl: freezed == bannerImageUrl ? _self.bannerImageUrl : bannerImageUrl // ignore: cast_nullable_to_non_nullable
as String?,bannerRoute: freezed == bannerRoute ? _self.bannerRoute : bannerRoute // ignore: cast_nullable_to_non_nullable
as String?,featuredFilmIds: null == featuredFilmIds ? _self.featuredFilmIds : featuredFilmIds // ignore: cast_nullable_to_non_nullable
as List<String>,featuredEventIds: null == featuredEventIds ? _self.featuredEventIds : featuredEventIds // ignore: cast_nullable_to_non_nullable
as List<String>,featuredNewsIds: null == featuredNewsIds ? _self.featuredNewsIds : featuredNewsIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeConfig].
extension HomeConfigPatterns on HomeConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeConfig value)  $default,){
final _that = this;
switch (_that) {
case _HomeConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeConfig value)?  $default,){
final _that = this;
switch (_that) {
case _HomeConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? bannerTitle,  String? bannerSubtitle,  String? bannerImageUrl,  String? bannerRoute,  List<String> featuredFilmIds,  List<String> featuredEventIds,  List<String> featuredNewsIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeConfig() when $default != null:
return $default(_that.bannerTitle,_that.bannerSubtitle,_that.bannerImageUrl,_that.bannerRoute,_that.featuredFilmIds,_that.featuredEventIds,_that.featuredNewsIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? bannerTitle,  String? bannerSubtitle,  String? bannerImageUrl,  String? bannerRoute,  List<String> featuredFilmIds,  List<String> featuredEventIds,  List<String> featuredNewsIds)  $default,) {final _that = this;
switch (_that) {
case _HomeConfig():
return $default(_that.bannerTitle,_that.bannerSubtitle,_that.bannerImageUrl,_that.bannerRoute,_that.featuredFilmIds,_that.featuredEventIds,_that.featuredNewsIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? bannerTitle,  String? bannerSubtitle,  String? bannerImageUrl,  String? bannerRoute,  List<String> featuredFilmIds,  List<String> featuredEventIds,  List<String> featuredNewsIds)?  $default,) {final _that = this;
switch (_that) {
case _HomeConfig() when $default != null:
return $default(_that.bannerTitle,_that.bannerSubtitle,_that.bannerImageUrl,_that.bannerRoute,_that.featuredFilmIds,_that.featuredEventIds,_that.featuredNewsIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HomeConfig extends HomeConfig {
  const _HomeConfig({this.bannerTitle, this.bannerSubtitle, this.bannerImageUrl, this.bannerRoute, final  List<String> featuredFilmIds = const <String>[], final  List<String> featuredEventIds = const <String>[], final  List<String> featuredNewsIds = const <String>[]}): _featuredFilmIds = featuredFilmIds,_featuredEventIds = featuredEventIds,_featuredNewsIds = featuredNewsIds,super._();
  factory _HomeConfig.fromJson(Map<String, dynamic> json) => _$HomeConfigFromJson(json);

@override final  String? bannerTitle;
@override final  String? bannerSubtitle;
@override final  String? bannerImageUrl;
@override final  String? bannerRoute;
 final  List<String> _featuredFilmIds;
@override@JsonKey() List<String> get featuredFilmIds {
  if (_featuredFilmIds is EqualUnmodifiableListView) return _featuredFilmIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_featuredFilmIds);
}

 final  List<String> _featuredEventIds;
@override@JsonKey() List<String> get featuredEventIds {
  if (_featuredEventIds is EqualUnmodifiableListView) return _featuredEventIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_featuredEventIds);
}

 final  List<String> _featuredNewsIds;
@override@JsonKey() List<String> get featuredNewsIds {
  if (_featuredNewsIds is EqualUnmodifiableListView) return _featuredNewsIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_featuredNewsIds);
}


/// Create a copy of HomeConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeConfigCopyWith<_HomeConfig> get copyWith => __$HomeConfigCopyWithImpl<_HomeConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HomeConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeConfig&&(identical(other.bannerTitle, bannerTitle) || other.bannerTitle == bannerTitle)&&(identical(other.bannerSubtitle, bannerSubtitle) || other.bannerSubtitle == bannerSubtitle)&&(identical(other.bannerImageUrl, bannerImageUrl) || other.bannerImageUrl == bannerImageUrl)&&(identical(other.bannerRoute, bannerRoute) || other.bannerRoute == bannerRoute)&&const DeepCollectionEquality().equals(other._featuredFilmIds, _featuredFilmIds)&&const DeepCollectionEquality().equals(other._featuredEventIds, _featuredEventIds)&&const DeepCollectionEquality().equals(other._featuredNewsIds, _featuredNewsIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bannerTitle,bannerSubtitle,bannerImageUrl,bannerRoute,const DeepCollectionEquality().hash(_featuredFilmIds),const DeepCollectionEquality().hash(_featuredEventIds),const DeepCollectionEquality().hash(_featuredNewsIds));

@override
String toString() {
  return 'HomeConfig(bannerTitle: $bannerTitle, bannerSubtitle: $bannerSubtitle, bannerImageUrl: $bannerImageUrl, bannerRoute: $bannerRoute, featuredFilmIds: $featuredFilmIds, featuredEventIds: $featuredEventIds, featuredNewsIds: $featuredNewsIds)';
}


}

/// @nodoc
abstract mixin class _$HomeConfigCopyWith<$Res> implements $HomeConfigCopyWith<$Res> {
  factory _$HomeConfigCopyWith(_HomeConfig value, $Res Function(_HomeConfig) _then) = __$HomeConfigCopyWithImpl;
@override @useResult
$Res call({
 String? bannerTitle, String? bannerSubtitle, String? bannerImageUrl, String? bannerRoute, List<String> featuredFilmIds, List<String> featuredEventIds, List<String> featuredNewsIds
});




}
/// @nodoc
class __$HomeConfigCopyWithImpl<$Res>
    implements _$HomeConfigCopyWith<$Res> {
  __$HomeConfigCopyWithImpl(this._self, this._then);

  final _HomeConfig _self;
  final $Res Function(_HomeConfig) _then;

/// Create a copy of HomeConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bannerTitle = freezed,Object? bannerSubtitle = freezed,Object? bannerImageUrl = freezed,Object? bannerRoute = freezed,Object? featuredFilmIds = null,Object? featuredEventIds = null,Object? featuredNewsIds = null,}) {
  return _then(_HomeConfig(
bannerTitle: freezed == bannerTitle ? _self.bannerTitle : bannerTitle // ignore: cast_nullable_to_non_nullable
as String?,bannerSubtitle: freezed == bannerSubtitle ? _self.bannerSubtitle : bannerSubtitle // ignore: cast_nullable_to_non_nullable
as String?,bannerImageUrl: freezed == bannerImageUrl ? _self.bannerImageUrl : bannerImageUrl // ignore: cast_nullable_to_non_nullable
as String?,bannerRoute: freezed == bannerRoute ? _self.bannerRoute : bannerRoute // ignore: cast_nullable_to_non_nullable
as String?,featuredFilmIds: null == featuredFilmIds ? _self._featuredFilmIds : featuredFilmIds // ignore: cast_nullable_to_non_nullable
as List<String>,featuredEventIds: null == featuredEventIds ? _self._featuredEventIds : featuredEventIds // ignore: cast_nullable_to_non_nullable
as List<String>,featuredNewsIds: null == featuredNewsIds ? _self._featuredNewsIds : featuredNewsIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
