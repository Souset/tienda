// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Member _$MemberFromJson(Map<String, dynamic> json) => _Member(
  memberNumber: (json['memberNumber'] as num?)?.toInt() ?? 0,
  status: json['status'] as String? ?? 'active',
  planId: json['planId'] as String?,
  planName: json['planName'] as String?,
  planPeriod: json['planPeriod'] as String?,
  joinedAt: const NullableTimestampConverter().fromJson(json['joinedAt']),
  benefits:
      (json['benefits'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  createdAt: const NullableTimestampConverter().fromJson(json['createdAt']),
  updatedAt: const NullableTimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$MemberToJson(_Member instance) => <String, dynamic>{
  'memberNumber': instance.memberNumber,
  'status': instance.status,
  'planId': instance.planId,
  'planName': instance.planName,
  'planPeriod': instance.planPeriod,
  'joinedAt': const NullableTimestampConverter().toJson(instance.joinedAt),
  'benefits': instance.benefits,
  'createdAt': const NullableTimestampConverter().toJson(instance.createdAt),
  'updatedAt': const NullableTimestampConverter().toJson(instance.updatedAt),
};

_MemberFee _$MemberFeeFromJson(Map<String, dynamic> json) => _MemberFee(
  amount: (json['amount'] as num?)?.toDouble() ?? 0,
  status: json['status'] as String? ?? 'pending',
  paidAt: const NullableTimestampConverter().fromJson(json['paidAt']),
  method: json['method'] as String?,
  planName: json['planName'] as String?,
);

Map<String, dynamic> _$MemberFeeToJson(_MemberFee instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'status': instance.status,
      'paidAt': const NullableTimestampConverter().toJson(instance.paidAt),
      'method': instance.method,
      'planName': instance.planName,
    };
