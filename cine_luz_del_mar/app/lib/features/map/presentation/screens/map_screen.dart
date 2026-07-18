import 'package:flutter/material.dart';

import '../../../../shared/widgets/empty_state.dart';

/// Pantalla de Mapa. Implementación completa en su fase del plan maestro.
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa')),
      body: const EmptyState(
        icon: Icons.map_outlined,
        title: 'Mapa',
        message: 'Esta sección estará disponible muy pronto.',
      ),
    );
  }
}
