import 'package:flutter/material.dart';

import '../../../../shared/widgets/empty_state.dart';

/// Pantalla de Noticias. Implementación completa en su fase del plan maestro.
class NewsListScreen extends StatelessWidget {
  const NewsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noticias')),
      body: const EmptyState(
        icon: Icons.newspaper,
        title: 'Noticias',
        message: 'Esta sección estará disponible muy pronto.',
      ),
    );
  }
}
