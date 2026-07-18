import 'package:flutter/material.dart';

import '../../../../shared/widgets/empty_state.dart';

/// Pantalla de Biblioteca. Implementación completa en su fase del plan maestro.
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biblioteca')),
      body: const EmptyState(
        icon: Icons.video_library_outlined,
        title: 'Biblioteca',
        message: 'Esta sección estará disponible muy pronto.',
      ),
    );
  }
}
