import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/auth_providers.dart';
import 'auth_scaffold.dart';

/// Pantalla de verificación de correo tras el registro.
///
/// Recuerda al usuario que revise su bandeja, permite reenviar el correo con
/// un enfriamiento de 60 s y comprobar si ya se ha verificado.
class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  static const _cooldownSeconds = 60;

  Timer? _timer;
  int _cooldown = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    _timer?.cancel();
    setState(() => _cooldown = _cooldownSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _cooldown--);
      if (_cooldown <= 0) timer.cancel();
    });
  }

  Future<void> _resend() async {
    await ref.read(authControllerProvider.notifier).resendVerification();
    if (!mounted) return;
    if (!ref.read(authControllerProvider).hasError) {
      _startCooldown();
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Correo de verificación reenviado')),
        );
    }
  }

  Future<void> _checkVerified() async {
    await ref.read(authControllerProvider.notifier).reloadUser();
    if (!mounted) return;
    final verified = ref.read(emailVerifiedProvider);
    if (verified) {
      context.go('/');
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Tu correo aún no aparece como verificado'),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    listenAuthErrors(context, ref);
    final loading = ref.watch(authControllerProvider).isLoading;
    final email = ref.watch(currentUserProvider)?.email ?? '';
    final scheme = Theme.of(context).colorScheme;
    final canResend = _cooldown == 0 && !loading;

    return AuthScaffold(
      children: [
        Icon(Icons.mark_email_read_outlined, size: 56, color: scheme.onSurface),
        const SizedBox(height: 20),
        Text(
          'Verifica tu correo',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        Text(
          email.isEmpty
              ? 'Te hemos enviado un correo de verificación. Ábrelo y pulsa el enlace para activar tu cuenta.'
              : 'Hemos enviado un correo de verificación a $email. Ábrelo y pulsa el enlace para activar tu cuenta.',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: 32),
        AuthPrimaryButton(
          label: 'Ya lo he verificado',
          loading: loading,
          onPressed: _checkVerified,
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: canResend ? _resend : null,
          child: Text(
            _cooldown > 0
                ? 'Reenviar correo ($_cooldown s)'
                : 'Reenviar correo',
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: loading
              ? null
              : () => ref.read(authControllerProvider.notifier).logout(),
          child: const Text('Cerrar sesión'),
        ),
      ],
    );
  }
}
