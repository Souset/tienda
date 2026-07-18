import 'package:flutter/material.dart';

import '../../../../shared/widgets/empty_state.dart';

/// Pantalla de Notificaciones. Implementación completa en su fase del plan maestro.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: const EmptyState(
        icon: Icons.notifications_none,
        title: 'Notificaciones',
        message: 'Esta sección estará disponible muy pronto.',
      ),
    );
  }
}
