import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters.dart';

part 'member.freezed.dart';
part 'member.g.dart';

/// Documento `members/{uid}`: datos de socio de la asociación cultural.
@freezed
abstract class Member with _$Member {
  const Member._();

  const factory Member({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    @Default(0) int memberNumber,

    /// Estado del socio: `active` | `suspended` | `left`.
    @Default('active') String status,

    /// Pack de socio elegido (referencia a `membership_plans`).
    String? planId,
    String? planName,

    /// Periodicidad del pack: `anual` | `mensual` | `unica`.
    String? planPeriod,
    @NullableTimestampConverter() DateTime? joinedAt,
    @Default(<String>[]) List<String> benefits,
    @NullableTimestampConverter() DateTime? createdAt,
    @NullableTimestampConverter() DateTime? updatedAt,
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}

/// Documento `members/{uid}/fees/{year}`: cuota anual de un socio.
@freezed
abstract class MemberFee with _$MemberFee {
  const MemberFee._();

  const factory MemberFee({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    @Default(0) double amount,

    /// Estado de la cuota: `paid` | `pending` | `exempt`.
    @Default('pending') String status,
    @NullableTimestampConverter() DateTime? paidAt,
    String? method,
    String? planName,
  }) = _MemberFee;

  factory MemberFee.fromJson(Map<String, dynamic> json) =>
      _$MemberFeeFromJson(json);
}
