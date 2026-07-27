import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/brand_wordmark.dart';
import '../providers/auth_providers.dart';
import 'auth_scaffold.dart';

/// Pantalla de inicio de sesión con correo, Google y (opcional) Apple.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    await ref
        .read(authControllerProvider.notifier)
        .login(_emailController.text, _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    listenAuthErrors(context, ref);
    final state = ref.watch(authControllerProvider);
    final loading = state.isLoading;

    return AuthScaffold(
      children: [
        const BrandWordmark(fontSize: 46),
        const SizedBox(height: 8),
        Text(
          'Bienvenido de nuevo',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 32),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  prefixIcon: Icon(Icons.alternate_email_rounded),
                ),
                validator: validateEmail,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscure,
                autofillHints: const [AutofillHints.password],
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Introduce tu contraseña' : null,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: loading
                      ? null
                      : () => context.push('/acceso/recuperar'),
                  child: const Text('¿Olvidaste tu contraseña?'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        AuthPrimaryButton(
          label: 'Entrar',
          loading: loading,
          onPressed: _submit,
        ),
        const SizedBox(height: 24),
        const AuthDivider(),
        const SizedBox(height: 24),
        GoogleButton(
          onPressed: loading
              ? null
              : () => ref.read(authControllerProvider.notifier).google(),
        ),
        if (AppConfig.appleSignInEnabled) ...[
          const SizedBox(height: 12),
          AppleButton(
            onPressed: loading
                ? null
                : () => ref.read(authControllerProvider.notifier).apple(),
          ),
        ],
        const SizedBox(height: 28),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              '¿Aún no tienes cuenta?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            TextButton(
              onPressed: loading
                  ? null
                  : () => context.push('/acceso/registro'),
              child: const Text('Regístrate'),
            ),
          ],
        ),
      ],
    );
  }
}
