import 'package:flutter/material.dart';

import '../../core/errors/app_exception.dart';

/// Vista de error con mensaje amigable y reintento.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, this.error, this.onRetry});

  final Object? error;
  final VoidCallback? onRetry;

  String _message() {
    final e = error;
    if (e is AppException) return e.message;
    return 'Ha ocurrido un error inesperado';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              _message(),
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reintentar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
