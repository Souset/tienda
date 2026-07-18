import 'package:flutter/material.dart';

import '../../../../shared/widgets/empty_state.dart';

/// Pantalla de Perfil. Implementación completa en su fase del plan maestro.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: const EmptyState(
        icon: Icons.person_outline,
        title: 'Perfil',
        message: 'Esta sección estará disponible muy pronto.',
      ),
    );
  }
}
