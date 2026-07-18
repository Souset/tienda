import 'package:flutter/material.dart';

import '../../../../shared/widgets/empty_state.dart';

/// Pantalla de Comunidad. Implementación completa en su fase del plan maestro.
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comunidad')),
      body: const EmptyState(
        icon: Icons.forum_outlined,
        title: 'Comunidad',
        message: 'Esta sección estará disponible muy pronto.',
      ),
    );
  }
}
