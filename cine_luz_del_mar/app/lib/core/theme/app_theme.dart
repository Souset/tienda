import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'palette.dart';

/// Tema global Material 3 de Cine Luz del Mar.
///
/// Dos variantes monocromas: oscura (por defecto, estilo sala de cine) y
/// clara (inversión de la escala). Tipografía: Playfair Display para
/// titulares, Inter para cuerpo y Great Vibes reservada a momentos de marca.
abstract final class AppTheme {
  static const double radiusS = 8;
  static const double radiusM = 12;
  static const double radiusL = 20;

  static ThemeData get dark => _build(_darkScheme);

  static ThemeData get light => _build(_lightScheme);

  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Palette.white,
    onPrimary: Palette.black,
    primaryContainer: Palette.slate,
    onPrimaryContainer: Palette.mist,
    secondary: Palette.silver,
    onSecondary: Palette.ink,
    secondaryContainer: Palette.graphite,
    onSecondaryContainer: Palette.silver,
    tertiary: Palette.ash,
    onTertiary: Palette.ink,
    error: Palette.errorDark,
    onError: Palette.black,
    surface: Palette.ink,
    onSurface: Palette.mist,
    surfaceDim: Palette.black,
    surfaceBright: Palette.slate,
    surfaceContainerLowest: Palette.black,
    surfaceContainerLow: Palette.charcoal,
    surfaceContainer: Palette.graphite,
    surfaceContainerHigh: Palette.slate,
    surfaceContainerHighest: Palette.steel,
    onSurfaceVariant: Palette.ash,
    outline: Palette.steel,
    outlineVariant: Palette.slate,
    inverseSurface: Palette.mist,
    onInverseSurface: Palette.ink,
    inversePrimary: Palette.black,
    shadow: Palette.black,
    scrim: Palette.black,
  );

  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Palette.black,
    onPrimary: Palette.white,
    primaryContainer: Palette.silver,
    onPrimaryContainer: Palette.ink,
    secondary: Palette.steel,
    onSecondary: Palette.white,
    secondaryContainer: Palette.mist,
    onSecondaryContainer: Palette.graphite,
    tertiary: Palette.steel,
    onTertiary: Palette.white,
    error: Palette.errorLight,
    onError: Palette.white,
    surface: Palette.white,
    onSurface: Palette.ink,
    surfaceDim: Palette.fog,
    surfaceBright: Palette.white,
    surfaceContainerLowest: Palette.white,
    surfaceContainerLow: Palette.paper,
    surfaceContainer: Palette.mist,
    surfaceContainerHigh: Palette.fog,
    surfaceContainerHighest: Palette.silver,
    onSurfaceVariant: Palette.steel,
    outline: Palette.ash,
    outlineVariant: Palette.silver,
    inverseSurface: Palette.ink,
    onInverseSurface: Palette.mist,
    inversePrimary: Palette.white,
    shadow: Palette.black,
    scrim: Palette.black,
  );

  static ThemeData _build(ColorScheme scheme) {
    final TextTheme base = scheme.brightness == Brightness.dark
        ? Typography.material2021().white
        : Typography.material2021().black;

    final TextTheme text = base
        .copyWith(
          displayLarge: GoogleFonts.playfairDisplay(
            textStyle: base.displayLarge,
            fontWeight: FontWeight.w600,
          ),
          displayMedium: GoogleFonts.playfairDisplay(
            textStyle: base.displayMedium,
            fontWeight: FontWeight.w600,
          ),
          displaySmall: GoogleFonts.playfairDisplay(
            textStyle: base.displaySmall,
            fontWeight: FontWeight.w600,
          ),
          headlineLarge: GoogleFonts.playfairDisplay(
            textStyle: base.headlineLarge,
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: GoogleFonts.playfairDisplay(
            textStyle: base.headlineMedium,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: GoogleFonts.playfairDisplay(
            textStyle: base.headlineSmall,
            fontWeight: FontWeight.w600,
          ),
        )
        .apply(
          bodyColor: scheme.onSurface,
          displayColor: scheme.onSurface,
          fontFamily: GoogleFonts.inter().fontFamily,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: text,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLow,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusM),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusM),
          ),
          textStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 48),
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: scheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusM),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          foregroundColor: scheme.onSurface,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide(color: scheme.onSurface, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide(color: scheme.error),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        indicatorColor: scheme.primaryContainer,
        labelTextStyle: WidgetStatePropertyAll(text.labelMedium),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? scheme.onSurface
                : scheme.onSurfaceVariant,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        indicatorColor: scheme.primaryContainer,
        selectedIconTheme: IconThemeData(color: scheme.onSurface),
        unselectedIconTheme: IconThemeData(color: scheme.onSurfaceVariant),
        selectedLabelTextStyle: text.labelMedium!,
        unselectedLabelTextStyle: text.labelMedium!,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainer,
        selectedColor: scheme.primaryContainer,
        side: BorderSide(color: scheme.outlineVariant),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusS),
        ),
        labelStyle: text.labelMedium,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: text.bodyMedium?.copyWith(
          color: scheme.onInverseSurface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusM),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusL),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radiusL)),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        titleTextStyle: text.bodyLarge,
        subtitleTextStyle: text.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.onSurface,
        linearTrackColor: scheme.surfaceContainerHigh,
        circularTrackColor: scheme.surfaceContainerHigh,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: scheme.onSurface,
        unselectedLabelColor: scheme.onSurfaceVariant,
        indicatorColor: scheme.onSurface,
        dividerColor: scheme.outlineVariant,
      ),
    );
  }

  /// Estilo caligráfico de marca (logo "Cine Luz del Mar").
  static TextStyle brandScript(BuildContext context, {double? fontSize}) {
    return GoogleFonts.pinyonScript(
      fontSize: fontSize ?? 40,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }
}
