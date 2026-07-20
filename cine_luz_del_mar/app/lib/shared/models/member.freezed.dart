// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Member {

@JsonKey(includeFromJson: false, includeToJson: false) String get id; int get memberNumber;/// Estado del socio: `active` | `suspended` | `left`.
 String get status;/// Pack de socio elegido (referencia a `membership_plans`).
 String? get planId; String? get planName;/// Periodicidad del pack: `anual` | `mensual` | `unica`.
 String? get planPeriod;@NullableTimestampConverter() DateTime? get joinedAt; List<String> get benefits;@NullableTimestampConverter() DateTime? get createdAt;@NullableTimestampConverter() DateTime? get updatedAt;
/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberCopyWith<Member> get copyWith => _$MemberCopyWithImpl<Member>(this as Member, _$identity);

  /// Serializes this Member to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Member&&(identical(other.id, id) || other.id == id)&&(identical(other.memberNumber, memberNumber) || other.memberNumber == memberNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.planId, planId) || other.planId == planId)&&(identical(other.planName, planName) || other.planName == planName)&&(identical(other.planPeriod, planPeriod) || other.planPeriod == planPeriod)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&const DeepCollectionEquality().equals(other.benefits, benefits)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,memberNumber,status,planId,planName,planPeriod,joinedAt,const DeepCollectionEquality().hash(benefits),createdAt,updatedAt);

@override
String toString() {
  return 'Member(id: $id, memberNumber: $memberNumber, status: $status, planId: $planId, planName: $planName, planPeriod: $planPeriod, joinedAt: $joinedAt, benefits: $benefits, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $MemberCopyWith<$Res>  {
  factory $MemberCopyWith(Member value, $Res Function(Member) _then) = _$MemberCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, int memberNumber, String status, String? planId, String? planName, String? planPeriod,@NullableTimestampConverter() DateTime? joinedAt, List<String> benefits,@NullableTimestampConverter() DateTime? createdAt,@NullableTimestampConverter() DateTime? updatedAt
});




}
/// @nodoc
class _$MemberCopyWithImpl<$Res>
    implements $MemberCopyWith<$Res> {
  _$MemberCopyWithImpl(this._self, this._then);

  final Member _self;
  final $Res Function(Member) _then;

/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? memberNumber = null,Object? status = null,Object? planId = freezed,Object? planName = freezed,Object? planPeriod = freezed,Object? joinedAt = freezed,Object? benefits = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memberNumber: null == memberNumber ? _self.memberNumber : memberNumber // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,planId: freezed == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String?,planName: freezed == planName ? _self.planName : planName // ignore: cast_nullable_to_non_nullable
as String?,planPeriod: freezed == planPeriod ? _self.planPeriod : planPeriod // ignore: cast_nullable_to_non_nullable
as String?,joinedAt: freezed == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,benefits: null == benefits ? _self.benefits : benefits // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Member].
extension MemberPatterns on Member {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Member value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Member() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Member value)  $default,){
final _that = this;
switch (_that) {
case _Member():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Member value)?  $default,){
final _that = this;
switch (_that) {
case _Member() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  int memberNumber,  String status,  String? planId,  String? planName,  String? planPeriod, @NullableTimestampConverter()  DateTime? joinedAt,  List<String> benefits, @NullableTimestampConverter()  DateTime? createdAt, @NullableTimestampConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Member() when $default != null:
return $default(_that.id,_that.memberNumber,_that.status,_that.planId,_that.planName,_that.planPeriod,_that.joinedAt,_that.benefits,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  int memberNumber,  String status,  String? planId,  String? planName,  String? planPeriod, @NullableTimestampConverter()  DateTime? joinedAt,  List<String> benefits, @NullableTimestampConverter()  DateTime? createdAt, @NullableTimestampConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Member():
return $default(_that.id,_that.memberNumber,_that.status,_that.planId,_that.planName,_that.planPeriod,_that.joinedAt,_that.benefits,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  int memberNumber,  String status,  String? planId,  String? planName,  String? planPeriod, @NullableTimestampConverter()  DateTime? joinedAt,  List<String> benefits, @NullableTimestampConverter()  DateTime? createdAt, @NullableTimestampConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Member() when $default != null:
return $default(_that.id,_that.memberNumber,_that.status,_that.planId,_that.planName,_that.planPeriod,_that.joinedAt,_that.benefits,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Member extends Member {
  const _Member({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', this.memberNumber = 0, this.status = 'active', this.planId, this.planName, this.planPeriod, @NullableTimestampConverter() this.joinedAt, final  List<String> benefits = const <String>[], @NullableTimestampConverter() this.createdAt, @NullableTimestampConverter() this.updatedAt}): _benefits = benefits,super._();
  factory _Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
@override@JsonKey() final  int memberNumber;
/// Estado del socio: `active` | `suspended` | `left`.
@override@JsonKey() final  String status;
/// Pack de socio elegido (referencia a `membership_plans`).
@override final  String? planId;
@override final  String? planName;
/// Periodicidad del pack: `anual` | `mensual` | `unica`.
@override final  String? planPeriod;
@override@NullableTimestampConverter() final  DateTime? joinedAt;
 final  List<String> _benefits;
@override@JsonKey() List<String> get benefits {
  if (_benefits is EqualUnmodifiableListView) return _benefits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_benefits);
}

@override@NullableTimestampConverter() final  DateTime? createdAt;
@override@NullableTimestampConverter() final  DateTime? updatedAt;

/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberCopyWith<_Member> get copyWith => __$MemberCopyWithImpl<_Member>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemberToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Member&&(identical(other.id, id) || other.id == id)&&(identical(other.memberNumber, memberNumber) || other.memberNumber == memberNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.planId, planId) || other.planId == planId)&&(identical(other.planName, planName) || other.planName == planName)&&(identical(other.planPeriod, planPeriod) || other.planPeriod == planPeriod)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&const DeepCollectionEquality().equals(other._benefits, _benefits)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,memberNumber,status,planId,planName,planPeriod,joinedAt,const DeepCollectionEquality().hash(_benefits),createdAt,updatedAt);

@override
String toString() {
  return 'Member(id: $id, memberNumber: $memberNumber, status: $status, planId: $planId, planName: $planName, planPeriod: $planPeriod, joinedAt: $joinedAt, benefits: $benefits, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MemberCopyWith<$Res> implements $MemberCopyWith<$Res> {
  factory _$MemberCopyWith(_Member value, $Res Function(_Member) _then) = __$MemberCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, int memberNumber, String status, String? planId, String? planName, String? planPeriod,@NullableTimestampConverter() DateTime? joinedAt, List<String> benefits,@NullableTimestampConverter() DateTime? createdAt,@NullableTimestampConverter() DateTime? updatedAt
});




}
/// @nodoc
class __$MemberCopyWithImpl<$Res>
    implements _$MemberCopyWith<$Res> {
  __$MemberCopyWithImpl(this._self, this._then);

  final _Member _self;
  final $Res Function(_Member) _then;

/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? memberNumber = null,Object? status = null,Object? planId = freezed,Object? planName = freezed,Object? planPeriod = freezed,Object? joinedAt = freezed,Object? benefits = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Member(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,memberNumber: null == memberNumber ? _self.memberNumber : memberNumber // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,planId: freezed == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String?,planName: freezed == planName ? _self.planName : planName // ignore: cast_nullable_to_non_nullable
as String?,planPeriod: freezed == planPeriod ? _self.planPeriod : planPeriod // ignore: cast_nullable_to_non_nullable
as String?,joinedAt: freezed == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,benefits: null == benefits ? _self._benefits : benefits // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$MemberFee {

@JsonKey(includeFromJson: false, includeToJson: false) String get id; double get amount;/// Estado de la cuota: `paid` | `pending` | `exempt`.
 String get status;@NullableTimestampConverter() DateTime? get paidAt; String? get method; String? get planName;
/// Create a copy of MemberFee
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberFeeCopyWith<MemberFee> get copyWith => _$MemberFeeCopyWithImpl<MemberFee>(this as MemberFee, _$identity);

  /// Serializes this MemberFee to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberFee&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.status, status) || other.status == status)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.method, method) || other.method == method)&&(identical(other.planName, planName) || other.planName == planName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,amount,status,paidAt,method,planName);

@override
String toString() {
  return 'MemberFee(id: $id, amount: $amount, status: $status, paidAt: $paidAt, method: $method, planName: $planName)';
}


}

/// @nodoc
abstract mixin class $MemberFeeCopyWith<$Res>  {
  factory $MemberFeeCopyWith(MemberFee value, $Res Function(MemberFee) _then) = _$MemberFeeCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, double amount, String status,@NullableTimestampConverter() DateTime? paidAt, String? method, String? planName
});




}
/// @nodoc
class _$MemberFeeCopyWithImpl<$Res>
    implements $MemberFeeCopyWith<$Res> {
  _$MemberFeeCopyWithImpl(this._self, this._then);

  final MemberFee _self;
  final $Res Function(MemberFee) _then;

/// Create a copy of MemberFee
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? amount = null,Object? status = null,Object? paidAt = freezed,Object? method = freezed,Object? planName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,planName: freezed == planName ? _self.planName : planName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MemberFee].
extension MemberFeePatterns on MemberFee {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemberFee value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemberFee() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemberFee value)  $default,){
final _that = this;
switch (_that) {
case _MemberFee():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemberFee value)?  $default,){
final _that = this;
switch (_that) {
case _MemberFee() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  double amount,  String status, @NullableTimestampConverter()  DateTime? paidAt,  String? method,  String? planName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemberFee() when $default != null:
return $default(_that.id,_that.amount,_that.status,_that.paidAt,_that.method,_that.planName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  double amount,  String status, @NullableTimestampConverter()  DateTime? paidAt,  String? method,  String? planName)  $default,) {final _that = this;
switch (_that) {
case _MemberFee():
return $default(_that.id,_that.amount,_that.status,_that.paidAt,_that.method,_that.planName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String id,  double amount,  String status, @NullableTimestampConverter()  DateTime? paidAt,  String? method,  String? planName)?  $default,) {final _that = this;
switch (_that) {
case _MemberFee() when $default != null:
return $default(_that.id,_that.amount,_that.status,_that.paidAt,_that.method,_that.planName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemberFee extends MemberFee {
  const _MemberFee({@JsonKey(includeFromJson: false, includeToJson: false) this.id = '', this.amount = 0, this.status = 'pending', @NullableTimestampConverter() this.paidAt, this.method, this.planName}): super._();
  factory _MemberFee.fromJson(Map<String, dynamic> json) => _$MemberFeeFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String id;
@override@JsonKey() final  double amount;
/// Estado de la cuota: `paid` | `pending` | `exempt`.
@override@JsonKey() final  String status;
@override@NullableTimestampConverter() final  DateTime? paidAt;
@override final  String? method;
@override final  String? planName;

/// Create a copy of MemberFee
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberFeeCopyWith<_MemberFee> get copyWith => __$MemberFeeCopyWithImpl<_MemberFee>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemberFeeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberFee&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.status, status) || other.status == status)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.method, method) || other.method == method)&&(identical(other.planName, planName) || other.planName == planName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,amount,status,paidAt,method,planName);

@override
String toString() {
  return 'MemberFee(id: $id, amount: $amount, status: $status, paidAt: $paidAt, method: $method, planName: $planName)';
}


}

/// @nodoc
abstract mixin class _$MemberFeeCopyWith<$Res> implements $MemberFeeCopyWith<$Res> {
  factory _$MemberFeeCopyWith(_MemberFee value, $Res Function(_MemberFee) _then) = __$MemberFeeCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String id, double amount, String status,@NullableTimestampConverter() DateTime? paidAt, String? method, String? planName
});




}
/// @nodoc
class __$MemberFeeCopyWithImpl<$Res>
    implements _$MemberFeeCopyWith<$Res> {
  __$MemberFeeCopyWithImpl(this._self, this._then);

  final _MemberFee _self;
  final $Res Function(_MemberFee) _then;

/// Create a copy of MemberFee
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? amount = null,Object? status = null,Object? paidAt = freezed,Object? method = freezed,Object? planName = freezed,}) {
  return _then(_MemberFee(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,planName: freezed == planName ? _self.planName : planName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
