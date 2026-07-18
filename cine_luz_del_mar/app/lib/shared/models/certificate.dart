import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters.dart';

part 'certificate.freezed.dart';
part 'certificate.g.dart';

/// Documento `certificates/{id}`: certificado emitido a un socio (p. ej. de
/// asistencia o colaboración).
@freezed
abstract class Certificate with _$Certificate {
  const Certificate._();

  const factory Certificate({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    @Default('') String uid,
    String? eventId,
    @Default('') String title,
    String? pdfUrl,
    @NullableTimestampConverter() DateTime? issuedAt,
    String? issuedBy,
  }) = _Certificate;

  factory Certificate.fromJson(Map<String, dynamic> json) =>
      _$CertificateFromJson(json);
}
