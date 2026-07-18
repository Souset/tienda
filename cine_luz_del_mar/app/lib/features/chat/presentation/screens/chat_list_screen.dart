import 'package:flutter/material.dart';

import '../../../../shared/widgets/empty_state.dart';

/// Pantalla de Chat. Implementación completa en su fase del plan maestro.
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: const EmptyState(
        icon: Icons.chat_bubble_outline,
        title: 'Chat',
        message: 'Esta sección estará disponible muy pronto.',
      ),
    );
  }
}
