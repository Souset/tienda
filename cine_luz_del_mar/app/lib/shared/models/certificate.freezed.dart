// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'certificate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Certificate {

@JsonKey(includeFromJson: false, includeToJson: false) String get id; String get uid; String? get eventId; String get title; String? get pdfUrl;@NullableTimestampConverter() DateTime? get issuedAt; String? get issuedBy;
/// Create a copy of Certificate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CertificateCopyWith<Certificate> get copyWith => _$CertificateCopyWithImpl<Certificate>(this as Certificate, _$identity);

  /// Serializes this Certificate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Certificate&&(identical(other.id, id) || other.id == id)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.title, title) || other.title == title)&&(identical(other.pdfUrl, pdfUrl) || other.pdfUrl == pdfUrl)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt)&&(identical(other.issuedBy, issuedBy) || other.issuedBy == issuedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,uid,eventId,title,pdfUrl,issuedAt,issuedBy);

@override
String toString() {
  return 'Certificate(id: $id, uid: $uid, eventId: $eventId, title: $title, pdfUrl: $pdfUrl, issuedAt: $issuedAt, issuedBy: $issuedBy)';
}


}

/// @nodoc
abstract mixin class $CertificateCopyWith<$Res>  {
  factory $CertificateCopyWith(Certificate value, $Res Function(Certificate) _then) = _$CertificateCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String uid, String? eventId, String title, String? pdfUrl,@NullableTimestampConverter() DateTime? issuedAt, String? issuedBy
});




}
/// @nodoc
class _$CertificateCopyWithImpl<$Res>
    implements $CertificateCopyWith<$Res> {
  _$CertificateCopyWithImpl(this._self, this._then);

  final Certificate _self;
  final $Res Function(Certificate) _then;

/// Create a copy of Certificate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? uid = null,Object? eventId = freezed,Object? title = null,Object? pdfUrl = freezed,Object? issuedAt = freezed,Object? issuedBy = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,eventId: freezed == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,pdfUrl: freezed == pdfUrl ? _self.pdfUrl : pdfUrl // ignore: cast_nullable_to_non_nullable
as String?,issuedAt: freezed == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,issuedBy: freezed == issuedBy ? _self.issuedBy : issuedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Certificate].
extension CertificatePatterns on Certificate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Certificate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Certificate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Certificate value)  $default,){
final _that = this;
switch (_that) {
case _Certificate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Certificate value)?  $default,){
final _that = this;
switch (_that) {
case _Certificate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String uid,  String? eventId,  String title,  String? pdfUrl, @NullableTimestampConverter()  DateTime? issuedAt,  String? issuedBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Certificate() when $default != null:
return $default(_that.id,_that.uid,_that.eventId,_that.title,_that.pdfUrl,_that.issuedAt,_that.issuedBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String uid,  String? eventId,  String title,  String? pdfUrl, @NullableTimestampConverter()  DateTime? issuedAt,  String? issuedBy)  $default,) {final _that = this;
switch (_that) {
case _Certificate():
return $default(_that.id,_that.uid,_that.eventId,_that.title,_that.pdfUrl,_that.issuedAt,_that.issuedBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  String uid,  String? eventId,  String title,  String? pdfUrl, @NullableTimestampConverter()  DateTime? issuedAt,  String? issuedBy)?  $default,) {final _that = this;
switch (_that) {
case _Certificate() when $default != null:
return $default(_that.id,_that.uid,_that.eventId,_that.title,_that.pdfUrl,_that.issuedAt,_that.issuedBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Certificate extends Certificate {
  const _Certificate({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', this.uid = '', this.eventId, this.title = '', this.pdfUrl, @NullableTimestampConverter() this.issuedAt, this.issuedBy}): super._();
  factory _Certificate.fromJson(Map<String, dynamic> json) => _$CertificateFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
@override@JsonKey() final  String uid;
@override final  String? eventId;
@override@JsonKey() final  String title;
@override final  String? pdfUrl;
@override@NullableTimestampConverter() final  DateTime? issuedAt;
@override final  String? issuedBy;

/// Create a copy of Certificate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CertificateCopyWith<_Certificate> get copyWith => __$CertificateCopyWithImpl<_Certificate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CertificateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Certificate&&(identical(other.id, id) || other.id == id)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.title, title) || other.title == title)&&(identical(other.pdfUrl, pdfUrl) || other.pdfUrl == pdfUrl)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt)&&(identical(other.issuedBy, issuedBy) || other.issuedBy == issuedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,uid,eventId,title,pdfUrl,issuedAt,issuedBy);

@override
String toString() {
  return 'Certificate(id: $id, uid: $uid, eventId: $eventId, title: $title, pdfUrl: $pdfUrl, issuedAt: $issuedAt, issuedBy: $issuedBy)';
}


}

/// @nodoc
abstract mixin class _$CertificateCopyWith<$Res> implements $CertificateCopyWith<$Res> {
  factory _$CertificateCopyWith(_Certificate value, $Res Function(_Certificate) _then) = __$CertificateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, String uid, String? eventId, String title, String? pdfUrl,@NullableTimestampConverter() DateTime? issuedAt, String? issuedBy
});




}
/// @nodoc
class __$CertificateCopyWithImpl<$Res>
    implements _$CertificateCopyWith<$Res> {
  __$CertificateCopyWithImpl(this._self, this._then);

  final _Certificate _self;
  final $Res Function(_Certificate) _then;

/// Create a copy of Certificate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? uid = null,Object? eventId = freezed,Object? title = null,Object? pdfUrl = freezed,Object? issuedAt = freezed,Object? issuedBy = freezed,}) {
  return _then(_Certificate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,eventId: freezed == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,pdfUrl: freezed == pdfUrl ? _self.pdfUrl : pdfUrl // ignore: cast_nullable_to_non_nullable
as String?,issuedAt: freezed == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,issuedBy: freezed == issuedBy ? _self.issuedBy : issuedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
