import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_config.freezed.dart';
part 'home_config.g.dart';

/// Documento `app_config/home`: configuración editable de la pantalla de
/// inicio (banner y destacados).
@freezed
abstract class HomeConfig with _$HomeConfig {
  const HomeConfig._();

  const factory HomeConfig({
    String? bannerTitle,
    String? bannerSubtitle,
    String? bannerImageUrl,
    String? bannerRoute,
    @Default(<String>[]) List<String> featuredFilmIds,
    @Default(<String>[]) List<String> featuredEventIds,
    @Default(<String>[]) List<String> featuredNewsIds,
  }) = _HomeConfig;

  factory HomeConfig.fromJson(Map<String, dynamic> json) =>
      _$HomeConfigFromJson(json);
}
