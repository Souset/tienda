import 'package:flutter/material.dart';

import '../../../../shared/widgets/empty_state.dart';

/// Pantalla de Carné de socio. Implementación completa en su fase del plan maestro.
class MemberCardScreen extends StatelessWidget {
  const MemberCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carné de socio')),
      body: const EmptyState(
        icon: Icons.badge_outlined,
        title: 'Carné de socio',
        message: 'Esta sección estará disponible muy pronto.',
      ),
    );
  }
}
