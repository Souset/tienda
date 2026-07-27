import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../providers/auth_providers.dart';

/// Contenedor común de las pantallas de autenticación.
///
/// Fondo monocromo, contenido centrado con anchura máxima de 420 px,
/// desplazable en pantallas pequeñas y con entrada animada escalonada.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.children,
    this.showBack = false,
  });

  final List<Widget> children;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showBack
          ? AppBar(backgroundColor: Colors.transparent, elevation: 0)
          : null,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children
                    .animate(interval: 55.ms)
                    .fadeIn(duration: 340.ms)
                    .moveY(begin: 14, end: 0, curve: Curves.easeOutCubic),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Botón primario a ancho completo con estado de carga integrado.
class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.loading,
    required this.onPressed,
  });

  final String label;
  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: loading ? null : onPressed,
      child: loading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.4),
            )
          : Text(label),
    );
  }
}

/// Separador "o continúa con" entre el formulario y el acceso social.
class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'o continúa con',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

/// Botón de acceso con Google (icono "G" estilizado, sin asset externo).
class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key, required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.g_mobiledata_rounded, size: 28),
      label: const Text('Continuar con Google'),
    );
  }
}

/// Botón de acceso con Apple. Solo se muestra si la feature está activa.
class AppleButton extends StatelessWidget {
  const AppleButton({super.key, required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.apple, size: 24),
      label: const Text('Continuar con Apple'),
    );
  }
}

/// Conecta el estado del [authControllerProvider] con SnackBars de error.
///
/// Debe invocarse dentro del `build` de una pantalla de auth.
void listenAuthErrors(BuildContext context, WidgetRef ref) {
  ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
    if (next is AsyncError) {
      final error = next.error;
      final message = error is AppException
          ? error.message
          : 'Ha ocurrido un error inesperado';
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    }
  });
}
