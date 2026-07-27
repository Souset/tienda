// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MembershipPlan _$MembershipPlanFromJson(Map<String, dynamic> json) =>
    _MembershipPlan(
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      period: json['period'] as String? ?? 'anual',
      benefits:
          (json['benefits'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      active: json['active'] as bool? ?? true,
      highlight: json['highlight'] as bool? ?? false,
      order: (json['order'] as num?)?.toInt() ?? 0,
      createdAt: const NullableTimestampConverter().fromJson(json['createdAt']),
      updatedAt: const NullableTimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$MembershipPlanToJson(
  _MembershipPlan instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'price': instance.price,
  'period': instance.period,
  'benefits': instance.benefits,
  'active': instance.active,
  'highlight': instance.highlight,
  'order': instance.order,
  'createdAt': const NullableTimestampConverter().toJson(instance.createdAt),
  'updatedAt': const NullableTimestampConverter().toJson(instance.updatedAt),
};
