import 'package:flutter/material.dart';

/// Utilidades de presentación del tipo de evento (proyeccion|taller|charla|
/// festival). Centraliza etiquetas e iconos para tarjetas y detalle.
abstract final class EventTypeLabels {
  static String label(String type) => switch (type) {
    'proyeccion' => 'Proyección',
    'taller' => 'Taller',
    'charla' => 'Charla',
    'festival' => 'Festival',
    _ => 'Evento',
  };

  static IconData icon(String type) => switch (type) {
    'proyeccion' => Icons.movie_outlined,
    'taller' => Icons.build_outlined,
    'charla' => Icons.record_voice_over_outlined,
    'festival' => Icons.celebration_outlined,
    _ => Icons.event_outlined,
  };
}
