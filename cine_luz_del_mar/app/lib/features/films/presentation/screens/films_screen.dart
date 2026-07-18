import 'package:flutter/material.dart';

import '../../../../shared/widgets/empty_state.dart';

/// Pantalla de Películas. Implementación completa en su fase del plan maestro.
class FilmsScreen extends StatelessWidget {
  const FilmsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Películas')),
      body: const EmptyState(
        icon: Icons.theaters_outlined,
        title: 'Películas',
        message: 'Esta sección estará disponible muy pronto.',
      ),
    );
  }
}
