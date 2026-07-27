import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters.dart';

part 'membership_plan.freezed.dart';
part 'membership_plan.g.dart';

/// Documento `membership_plans/{id}`: pack de socio configurable desde el
/// panel de administración (precio, periodicidad, ventajas y orden).
///
/// El precio que se cobra lo lee SIEMPRE el servidor de este documento
/// (crear_pago.php); la app solo lo muestra.
@freezed
abstract class MembershipPlan with _$MembershipPlan {
  const MembershipPlan._();

  const factory MembershipPlan({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    @Default('') String name,
    @Default('') String description,
    @Default(0) double price,

    /// Periodicidad de la cuota: `anual` | `mensual` | `unica`.
    @Default('anual') String period,
    @Default(<String>[]) List<String> benefits,
    @Default(true) bool active,

    /// Pack destacado (se resalta en la pantalla "Hazte socio").
    @Default(false) bool highlight,
    @Default(0) int order,
    @NullableTimestampConverter() DateTime? createdAt,
    @NullableTimestampConverter() DateTime? updatedAt,
  }) = _MembershipPlan;

  factory MembershipPlan.fromJson(Map<String, dynamic> json) =>
      _$MembershipPlanFromJson(json);

  /// Etiqueta del periodo para mostrar junto al precio.
  String get periodLabel => switch (period) {
    'mensual' => 'al mes',
    'unica' => 'pago único',
    _ => 'al año',
  };
}
