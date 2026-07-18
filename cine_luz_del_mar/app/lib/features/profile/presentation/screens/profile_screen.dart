import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/services/collections.dart';
import '../../../../core/theme/theme_mode_provider.dart';
import '../../../../core/utils/search_tokens.dart';
import '../../../../shared/models/app_user.dart';
import '../../../../shared/widgets/confirm_dialog.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

/// Pantalla de Perfil: datos del socio, accesos y preferencias.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: user == null
          ? EmptyState(
              icon: Icons.person_outline,
              title: 'Aún no has iniciado sesión',
              message:
                  'Accede para gestionar tu carné, tus certificados y más.',
              actionLabel: 'Iniciar sesión',
              onAction: () => context.go('/acceso'),
            )
          : _ProfileBody(user: user),
    );
  }
}

class _ProfileBody extends ConsumerWidget {
  const _ProfileBody({required this.user});

  final AppUser user;

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Cerrar sesión',
      message: '¿Seguro que quieres cerrar tu sesión?',
      confirmLabel: 'Cerrar sesión',
      destructive: true,
    );
    if (confirmed) {
      await ref.read(authControllerProvider.notifier).logout();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              UserAvatar(
                photoUrl: user.photoUrl,
                name: user.displayName,
                size: 96,
              ),
              const SizedBox(height: 16),
              Text(
                user.displayName.isEmpty ? 'Socio/a' : user.displayName,
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                user.email,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Chip(
                avatar: const Icon(Icons.verified_user_outlined, size: 18),
                label: Text(user.userRole.label),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => _openEditSheet(context, ref),
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('Editar perfil'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.badge_outlined),
          title: const Text('Carné de socio'),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => context.push('/carne'),
        ),
        ListTile(
          leading: const Icon(Icons.notifications_outlined),
          title: const Text('Notificaciones'),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => context.push('/notificaciones'),
        ),
        ListTile(
          leading: const Icon(Icons.workspace_premium_outlined),
          title: const Text('Mis certificados'),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Disponible próximamente')),
              );
          },
        ),
        const Divider(),
        SwitchListTile(
          secondary: Icon(
            isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
          ),
          title: const Text('Tema oscuro'),
          subtitle: Text(isDark ? 'Activado' : 'Desactivado'),
          value: isDark,
          onChanged: (value) => ref
              .read(themeModeProvider.notifier)
              .set(value ? ThemeMode.dark : ThemeMode.light),
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.logout_rounded, color: theme.colorScheme.error),
          title: Text(
            'Cerrar sesión',
            style: TextStyle(color: theme.colorScheme.error),
          ),
          onTap: () => _logout(context, ref),
        ),
      ],
    );
  }

  void _openEditSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _EditProfileSheet(user: user),
    );
  }
}

/// Hoja inferior para editar nombre visible y biografía.
class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet({required this.user});

  final AppUser user;

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.displayName);
    _bioController = TextEditingController(text: widget.user.bio ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final name = _nameController.text.trim();
    final bio = _bioController.text.trim();
    try {
      await FirebaseFirestore.instance
          .collection(Col.users)
          .doc(widget.user.id)
          .update({
            'displayName': name,
            'bio': bio,
            'searchTokens': buildSearchTokens([name, widget.user.email]),
            'updatedAt': FieldValue.serverTimestamp(),
          });
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('No se pudieron guardar los cambios')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Editar perfil',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nombre visible',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Introduce tu nombre'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bioController,
              maxLines: 3,
              maxLength: 160,
              decoration: const InputDecoration(
                labelText: 'Biografía',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.4),
                    )
                  : const Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
