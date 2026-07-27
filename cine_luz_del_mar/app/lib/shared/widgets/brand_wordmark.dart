import 'package:flutter/material.dart';

/// Logotipo "Cine Luz del Mar": calco vectorizado del logo original de la
/// asociación (assets/brand), tintado según el tema activo.
///
/// `fontSize` se mantiene por compatibilidad con los puntos de uso: define
/// la altura visual equivalente del logotipo.
class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key, this.fontSize = 36, this.color});

  final double fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Cine Luz del Mar',
      image: true,
      child: Image.asset(
        'assets/brand/logo_wordmark_white.png',
        height: fontSize * 1.15,
        color: color ?? Theme.of(context).colorScheme.onSurface,
        colorBlendMode: BlendMode.srcIn,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
      ),
    );
  }
}
