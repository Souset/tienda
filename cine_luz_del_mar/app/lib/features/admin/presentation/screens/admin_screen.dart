import 'package:flutter/material.dart';

import '../../../../shared/widgets/empty_state.dart';

/// Pantalla de Administración. Implementación completa en su fase del plan maestro.
class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administración')),
      body: const EmptyState(
        icon: Icons.admin_panel_settings_outlined,
        title: 'Administración',
        message: 'Esta sección estará disponible muy pronto.',
      ),
    );
  }
}
