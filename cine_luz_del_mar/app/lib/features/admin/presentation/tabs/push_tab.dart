import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../shared/widgets/confirm_dialog.dart';
import '../providers/admin_providers.dart';

/// Envío de notificaciones push a toda la comunidad (vía API de Nicalia).
class PushTab extends ConsumerStatefulWidget {
  const PushTab({super.key});

  @override
  ConsumerState<PushTab> createState() => _PushTabState();
}

class _PushTabState extends ConsumerState<PushTab> {
  final _title = TextEditingController();
  final _body = TextEditingController();
  String _route = '';
  bool _sending = false;
  String? _result;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_title.text.trim().isEmpty || _body.text.trim().isEmpty) return;
    final ok = await showConfirmDialog(
      context,
      title: 'Enviar a toda la comunidad',
      message:
          'La notificación llegará al móvil de todos los usuarios con la '
          'app y a su buzón interno. ¿Enviar ahora?',
      confirmLabel: 'Enviar',
    );
    if (!ok || !mounted) return;

    setState(() {
      _sending = true;
      _result = null;
    });
    try {
      final result = await ref
          .read(adminRepositoryProvider)
          .sendPush(
            title: _title.text.trim(),
            body: _body.text.trim(),
            route: _route.isEmpty ? null : _route,
          );
      setState(() {
        _result =
            'Enviadas ${result.sent} notificaciones push · '
            '${result.inbox} buzones actualizados';
        _title.clear();
        _body.clear();
      });
    } on AppException catch (e) {
      setState(() => _result = e.message);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Notificación para toda la comunidad',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Requiere la mini-API de Nicalia configurada (docs/SETUP.md).',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _title,
              maxLength: 60,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _body,
              minLines: 2,
              maxLines: 4,
              maxLength: 180,
              decoration: const InputDecoration(labelText: 'Mensaje'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _route,
              decoration: const InputDecoration(labelText: 'Al tocarla abre…'),
              items: const [
                DropdownMenuItem(value: '', child: Text('La app (inicio)')),
                DropdownMenuItem(value: '/agenda', child: Text('Agenda')),
                DropdownMenuItem(value: '/noticias', child: Text('Noticias')),
                DropdownMenuItem(value: '/carne', child: Text('Carné')),
                DropdownMenuItem(value: '/comunidad', child: Text('Comunidad')),
              ],
              onChanged: (v) => setState(() => _route = v ?? ''),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _sending ? null : _send,
              icon: _sending
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send_outlined),
              label: Text(_sending ? 'Enviando…' : 'Enviar a todos'),
            ),
            if (_result != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(_result!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
