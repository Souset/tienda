import 'package:flutter/material.dart';

/// Fila de estrellas de solo lectura (monocroma: usa onSurface, nunca amarillo).
///
/// Muestra media estrella cuando corresponde a partir de [value] (0..5).
class StarRatingDisplay extends StatelessWidget {
  const StarRatingDisplay({
    super.key,
    required this.value,
    this.size = 18,
    this.color,
  });

  final double value;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tint = color ?? Theme.of(context).colorScheme.onSurface;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final position = i + 1;
        final IconData icon;
        if (value >= position) {
          icon = Icons.star;
        } else if (value >= position - 0.5) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }
        return Icon(icon, size: size, color: tint);
      }),
    );
  }
}

/// Selector interactivo de valoración de 0.5 a 5 estrellas en pasos de 0.5.
///
/// Un toque en la mitad izquierda de una estrella marca media; en la derecha,
/// entera. Monocromo, coherente con el resto de la app.
class StarRatingInput extends StatelessWidget {
  const StarRatingInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 40,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    final tint = Theme.of(context).colorScheme.onSurface;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final position = i + 1;
        final IconData icon;
        if (value >= position) {
          icon = Icons.star;
        } else if (value >= position - 0.5) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) {
            // Mitad izquierda -> media estrella; mitad derecha -> entera.
            final isLeftHalf = details.localPosition.dx < size / 2;
            onChanged(isLeftHalf ? position - 0.5 : position.toDouble());
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Icon(icon, size: size, color: tint),
          ),
        );
      }),
    );
  }
}
