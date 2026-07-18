import 'package:flutter/material.dart';

import '../../../../shared/widgets/empty_state.dart';

/// Pantalla de Iniciar sesión. Implementación completa en su fase del plan maestro.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: const EmptyState(
        icon: Icons.login,
        title: 'Iniciar sesión',
        message: 'Esta sección estará disponible muy pronto.',
      ),
    );
  }
}
