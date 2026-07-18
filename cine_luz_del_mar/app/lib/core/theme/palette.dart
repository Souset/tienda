import 'package:flutter/material.dart';

/// Paleta monocroma de Cine Luz del Mar.
///
/// La identidad visual es estrictamente blanco y negro: la jerarquía se
/// construye con luminosidad y peso tipográfico, nunca con color. La única
/// excepción es el rojo de error en formularios, mantenido por accesibilidad.
abstract final class Palette {
  // Escala de oscuros (fondos en modo oscuro, textos en modo claro).
  static const Color black = Color(0xFF000000);
  static const Color ink = Color(0xFF0A0A0A);
  static const Color charcoal = Color(0xFF141414);
  static const Color graphite = Color(0xFF1E1E1E);
  static const Color slate = Color(0xFF2A2A2A);
  static const Color steel = Color(0xFF4D4D4D);

  // Escala de claros (textos en modo oscuro, fondos en modo claro).
  static const Color white = Color(0xFFFFFFFF);
  static const Color paper = Color(0xFFFAFAFA);
  static const Color mist = Color(0xFFF2F2F2);
  static const Color fog = Color(0xFFF0F0F0);
  static const Color silver = Color(0xFFD9D9D9);
  static const Color ash = Color(0xFFA6A6A6);

  // Excepción de accesibilidad: errores de formulario.
  static const Color errorDark = Color(0xFFFF6B6B);
  static const Color errorLight = Color(0xFFB3261E);
}
