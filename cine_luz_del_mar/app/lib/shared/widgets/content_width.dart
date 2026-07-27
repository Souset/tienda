import 'package:flutter/material.dart';

/// Anchos máximos de contenido según el tipo de pantalla.
///
/// En escritorio, el contenido de lectura (listas, feeds, formularios) no
/// debe estirarse a todo el ancho: se centra en una columna cómoda.
abstract final class ContentWidth {
  /// Listas y feeds de lectura (noticias, comunidad, notificaciones, chat).
  static const double list = 760;

  /// Rejillas de tarjetas (packs, biblioteca, películas).
  static const double grid = 1240;

  /// Formularios y fichas (perfil, carné).
  static const double form = 560;
}

/// Centra su hijo y limita su ancho máximo; en móvil no cambia nada.
class ContentColumn extends StatelessWidget {
  const ContentColumn({
    super.key,
    required this.child,
    this.maxWidth = ContentWidth.list,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
