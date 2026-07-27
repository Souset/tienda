import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';

/// Sube el brillo de la pantalla al máximo mientras su hijo está visible
/// (carné y entradas con QR, para validar rápido en la puerta) y lo
/// restaura al salir. En web o si el sistema no lo permite, no hace nada.
class BrightnessBoost extends StatefulWidget {
  const BrightnessBoost({super.key, required this.child});

  final Widget child;

  @override
  State<BrightnessBoost> createState() => _BrightnessBoostState();
}

class _BrightnessBoostState extends State<BrightnessBoost> {
  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      ScreenBrightness.instance
          .setApplicationScreenBrightness(1)
          .catchError((Object e) => debugPrint('Brillo no disponible: $e'));
    }
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      ScreenBrightness.instance.resetApplicationScreenBrightness().catchError(
        (Object e) => debugPrint('Brillo no restaurado: $e'),
      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
