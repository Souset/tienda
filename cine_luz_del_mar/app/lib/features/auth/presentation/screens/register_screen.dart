import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/brand_wordmark.dart';
import '../providers/auth_providers.dart';
import 'auth_scaffold.dart';

/// Registro de una cuenta nueva con correo y contraseña.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    await ref
        .read(authControllerProvider.notifier)
        .register(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );
    if (!mounted) return;
    if (!ref.read(authControllerProvider).hasError) {
      context.go('/acceso/verificar');
    }
  }

  @override
  Widget build(BuildContext context) {
    listenAuthErrors(context, ref);
    final loading = ref.watch(authControllerProvider).isLoading;

    return AuthScaffold(
      showBack: true,
      children: [
        const BrandWordmark(fontSize: 40),
        const SizedBox(height: 20),
        Text(
          'Crea tu cuenta',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Únete a la comunidad de Cine Luz del Mar',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 28),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                decoration: const InputDecoration(
                  labelText: 'Nombre y apellidos',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                validator: (v) => validateRequired(v, 'El nombre'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
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
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.newPassword],
                onFieldSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  helperText: 'Mínimo 8 caracteres, con letras y números',
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
                validator: validatePassword,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        AuthPrimaryButton(
          label: 'Crear cuenta',
          loading: loading,
          onPressed: _submit,
        ),
        const SizedBox(height: 20),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              '¿Ya tienes cuenta?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            TextButton(
              onPressed: loading ? null : () => context.pop(),
              child: const Text('Inicia sesión'),
            ),
          ],
        ),
      ],
    );
  }
}
