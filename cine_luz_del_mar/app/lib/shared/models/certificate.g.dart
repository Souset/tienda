// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Certificate _$CertificateFromJson(Map<String, dynamic> json) => _Certificate(
  uid: json['uid'] as String? ?? '',
  eventId: json['eventId'] as String?,
  title: json['title'] as String? ?? '',
  pdfUrl: json['pdfUrl'] as String?,
  issuedAt: const NullableTimestampConverter().fromJson(json['issuedAt']),
  issuedBy: json['issuedBy'] as String?,
);

Map<String, dynamic> _$CertificateToJson(_Certificate instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'eventId': instance.eventId,
      'title': instance.title,
      'pdfUrl': instance.pdfUrl,
      'issuedAt': const NullableTimestampConverter().toJson(instance.issuedAt),
      'issuedBy': instance.issuedBy,
    };
