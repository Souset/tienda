import 'package:flutter/material.dart';

import '../../../../shared/widgets/empty_state.dart';

/// Pantalla de Asistente. Implementación completa en su fase del plan maestro.
class AssistantScreen extends StatelessWidget {
  const AssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asistente')),
      body: const EmptyState(
        icon: Icons.auto_awesome_outlined,
        title: 'Asistente',
        message: 'Esta sección estará disponible muy pronto.',
      ),
    );
  }
}
