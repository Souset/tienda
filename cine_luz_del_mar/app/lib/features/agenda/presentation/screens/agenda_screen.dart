import 'package:flutter/material.dart';

import '../../../../shared/widgets/empty_state.dart';

/// Pantalla de Agenda. Implementación completa en su fase del plan maestro.
class AgendaScreen extends StatelessWidget {
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agenda')),
      body: const EmptyState(
        icon: Icons.calendar_month_outlined,
        title: 'Agenda',
        message: 'Esta sección estará disponible muy pronto.',
      ),
    );
  }
}
