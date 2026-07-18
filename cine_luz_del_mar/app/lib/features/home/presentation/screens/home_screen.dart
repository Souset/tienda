import 'package:flutter/material.dart';

import '../../../../shared/widgets/empty_state.dart';

/// Pantalla de Inicio. Implementación completa en su fase del plan maestro.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: const EmptyState(
        icon: Icons.movie_filter_outlined,
        title: 'Inicio',
        message: 'Esta sección estará disponible muy pronto.',
      ),
    );
  }
}
