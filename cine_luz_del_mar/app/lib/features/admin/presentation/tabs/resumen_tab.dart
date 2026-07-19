import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/section_header.dart';
import '../providers/admin_providers.dart';

/// Resumen: estadísticas de la asociación y portada de la app.
class ResumenTab extends ConsumerWidget {
  const ResumenTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(adminStatsProvider);

    return stats.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => ErrorView(
        error: error,
        onRetry: () => ref.invalidate(adminStatsProvider),
      ),
      data: (s) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _StatCard(
                icon: Icons.people_outline,
                value: s.users,
                label: 'Usuarios',
              ),
              _StatCard(
                icon: Icons.badge_outlined,
                value: s.activeMembers,
                label: 'Socios activos',
              ),
              _StatCard(
                icon: Icons.calendar_month_outlined,
                value: s.upcomingEvents,
                label: 'Eventos próximos',
              ),
              _StatCard(
                icon: Icons.newspaper,
                value: s.publishedNews,
                label: 'Noticias publicadas',
              ),
              _StatCard(
                icon: Icons.forum_outlined,
                value: s.posts,
                label: 'Publicaciones',
              ),
              _StatCard(
                icon: Icons.theaters_outlined,
                value: s.films,
                label: 'Películas',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => ref.invalidate(adminStatsProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('Actualizar'),
            ),
          ),
          const SectionHeader(
            title: 'Portada de la app',
            padding: EdgeInsets.fromLTRB(0, 16, 0, 12),
          ),
          const _HomeConfigForm(),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(height: 10),
          Text('$value', style: theme.textTheme.displaySmall),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Edición del banner de la home (app_config/home).
class _HomeConfigForm extends ConsumerStatefulWidget {
  const _HomeConfigForm();

  @override
  ConsumerState<_HomeConfigForm> createState() => _HomeConfigFormState();
}

class _HomeConfigFormState extends ConsumerState<_HomeConfigForm> {
  final _title = TextEditingController();
  final _subtitle = TextEditingController();
  final _imageUrl = TextEditingController();
  String _route = '/agenda';
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    ref.read(adminRepositoryProvider).getHomeConfig().then((config) {
      if (!mounted) return;
      setState(() {
        _title.text = config?.bannerTitle ?? '';
        _subtitle.text = config?.bannerSubtitle ?? '';
        _imageUrl.text = config?.bannerImageUrl ?? '';
        _route = config?.bannerRoute ?? '/agenda';
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    _title.dispose();
    _subtitle.dispose();
    _imageUrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref
          .read(adminRepositoryProvider)
          .saveHomeConfig(
            HomeConfig(
              bannerTitle: _title.text.trim(),
              bannerSubtitle: _subtitle.text.trim(),
              bannerImageUrl: _imageUrl.text.trim().isEmpty
                  ? null
                  : _imageUrl.text.trim(),
              bannerRoute: _route,
            ),
          );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Portada actualizada')));
      }
    } on AppException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const LinearProgressIndicator();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _title,
          decoration: const InputDecoration(labelText: 'Título del banner'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _subtitle,
          decoration: const InputDecoration(labelText: 'Subtítulo'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _imageUrl,
          decoration: const InputDecoration(
            labelText: 'URL de imagen (opcional)',
            helperText:
                'Puedes subir la imagen desde Noticias/Eventos '
                'y copiar aquí su URL',
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _route,
          decoration: const InputDecoration(labelText: 'Destino al tocar'),
          items: const [
            DropdownMenuItem(value: '/agenda', child: Text('Agenda')),
            DropdownMenuItem(value: '/peliculas', child: Text('Películas')),
            DropdownMenuItem(value: '/noticias', child: Text('Noticias')),
            DropdownMenuItem(value: '/comunidad', child: Text('Comunidad')),
          ],
          onChanged: (value) => setState(() => _route = value ?? '/agenda'),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(_saving ? 'Guardando…' : 'Guardar portada'),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
