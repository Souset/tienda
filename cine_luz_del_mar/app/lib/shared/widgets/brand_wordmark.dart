import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Logotipo "Cine Luz del Mar" en caligrafía, fiel al logo original de la
/// asociación (script blanco sobre negro). Se adapta al tema activo.
class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key, this.fontSize = 36, this.color});

  final double fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Cine Luz del Mar',
      textAlign: TextAlign.center,
      style: GoogleFonts.greatVibes(
        fontSize: fontSize,
        color: color ?? Theme.of(context).colorScheme.onSurface,
        height: 1.1,
      ),
      semanticsLabel: 'Cine Luz del Mar',
    );
  }
}
