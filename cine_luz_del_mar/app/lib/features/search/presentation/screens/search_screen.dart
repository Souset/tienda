import 'package:flutter/material.dart';

import '../../../../shared/widgets/empty_state.dart';

/// Pantalla de Buscar. Implementación completa en su fase del plan maestro.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar')),
      body: const EmptyState(
        icon: Icons.search,
        title: 'Buscar',
        message: 'Esta sección estará disponible muy pronto.',
      ),
    );
  }
}
