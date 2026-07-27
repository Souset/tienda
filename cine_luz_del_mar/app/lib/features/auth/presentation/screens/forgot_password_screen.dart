import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/utils/validators.dart';
import '../providers/auth_providers.dart';
import 'auth_scaffold.dart';

/// Recuperación de contraseña por correo electrónico.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    await ref
        .read(authControllerProvider.notifier)
        .reset(_emailController.text);
    if (!mounted) return;
    if (!ref.read(authControllerProvider).hasError) {
      setState(() => _sent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    listenAuthErrors(context, ref);
    final loading = ref.watch(authControllerProvider).isLoading;
    final scheme = Theme.of(context).colorScheme;

    return AuthScaffold(
      showBack: true,
      children: [
        Icon(Icons.lock_reset_rounded, size: 56, color: scheme.onSurface),
        const SizedBox(height: 20),
        Text(
          'Recuperar contraseña',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          _sent
              ? 'Te hemos enviado un correo con las instrucciones para restablecer tu contraseña.'
              : 'Introduce tu correo y te enviaremos un enlace para restablecer tu contraseña.',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: 28),
        if (!_sent) ...[
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.email],
              onFieldSubmitted: (_) => _submit(),
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                prefixIcon: Icon(Icons.alternate_email_rounded),
              ),
              validator: validateEmail,
            ),
          ),
          const SizedBox(height: 24),
          AuthPrimaryButton(
            label: 'Enviar enlace',
            loading: loading,
            onPressed: _submit,
          ),
        ] else
          FilledButton(
            onPressed: () => context.go('/acceso'),
            child: const Text('Volver a iniciar sesión'),
          ),
      ],
    );
  }
}
