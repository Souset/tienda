import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/errors/app_exception.dart';

import '../../../../core/config/user_role.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/widgets/app_shimmer.dart';
import '../../../../shared/widgets/confirm_dialog.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/admin_providers.dart';
import 'content_tabs.dart' show runAdminAction;

/// Gestión de socios (junta directiva o superior).
class MembersTab extends ConsumerWidget {
  const MembersTab({super.key});

  Future<void> _alta(BuildContext context, WidgetRef ref) async {
    final users = await ref.read(adminRepositoryProvider).watchUsers().first;
    final members = ref.read(allMembersProvider).value ?? const <Member>[];
    final memberUids = {for (final m in members) m.id};
    final candidates = users.where((u) => !memberUids.contains(u.id)).toList();
    if (!context.mounted) return;

    final selected = await showDialog<AppUser>(
      context: context,
      builder: (context) =>
          _UserSearchDialog(title: 'Alta de socio', users: candidates),
    );
    if (selected == null || !context.mounted) return;

    await runAdminAction(context, () async {
      final numero = await ref
          .read(adminRepositoryProvider)
          .altaSocio(selected.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${selected.displayName} ya es socio nº '
              '${numero.toString().padLeft(4, '0')}',
            ),
          ),
        );
      }
    });
  }

  void _fees(BuildContext context, WidgetRef ref, Member member) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => _FeesSheet(member: member),
    );
  }

  Future<void> _certificado(
    BuildContext context,
    WidgetRef ref,
    Member member,
  ) async {
    final me = ref.read(currentUserProvider);
    final user = ref.read(adminUserProvider(member.id)).value;
    final controller = TextEditingController();
    final title = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Certificado para ${user?.displayName ?? 'el socio'}'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Concepto',
            hintText: 'ha completado el Taller de guion (20 h)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Emitir'),
          ),
        ],
      ),
    );
    if (title == null || title.isEmpty || me == null || !context.mounted) {
      return;
    }
    await runAdminAction(
      context,
      () => ref
          .read(adminRepositoryProvider)
          .issueCertificate(uid: member.id, title: title, issuedBy: me.id),
      successMessage: 'Certificado emitido: aparecerá en el perfil del socio',
    );
  }

  /// Exporta socios y cuotas a CSV (compartir o copiar al portapapeles).
  Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
    try {
      final csv = await ref.read(adminRepositoryProvider).exportMembersCsv();
      final file = XFile.fromData(
        // BOM UTF-8 para que Excel abra los acentos correctamente.
        Uint8List.fromList([0xEF, 0xBB, 0xBF, ...csv.codeUnits]),
        mimeType: 'text/csv',
        name: 'socios-cine-luz-del-mar.csv',
      );
      await SharePlus.instance.share(
        ShareParams(files: [file], subject: 'Socios Cine Luz del Mar'),
      );
    } on AppException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (_) {
      // Plataformas sin diálogo de compartir: portapapeles como respaldo.
      final csv = await ref.read(adminRepositoryProvider).exportMembersCsv();
      await Clipboard.setData(ClipboardData(text: csv));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('CSV copiado al portapapeles (pégalo en Excel)'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(adminRepositoryProvider);
    final members = ref.watch(allMembersProvider);

    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'export-csv',
            onPressed: () => _exportCsv(context, ref),
            icon: const Icon(Icons.table_view_outlined),
            label: const Text('Exportar CSV'),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'alta-socio',
            onPressed: () => _alta(context, ref),
            icon: const Icon(Icons.person_add_alt),
            label: const Text('Alta de socio'),
          ),
        ],
      ),
      body: members.when(
        loading: () => const ShimmerList(itemHeight: 64),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(allMembersProvider),
        ),
        data: (list) => list.isEmpty
            ? const EmptyState(
                icon: Icons.badge_outlined,
                title: 'Todavía no hay socios dados de alta',
              )
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 96),
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final member = list[i];
                  final user = ref.watch(adminUserProvider(member.id)).value;
                  return ListTile(
                    leading: UserAvatar(
                      photoUrl: user?.photoUrl,
                      name: user?.displayName ?? '',
                      size: 40,
                    ),
                    title: Text(
                      'Nº ${member.memberNumber.toString().padLeft(4, '0')}'
                      ' · ${user?.displayName ?? '…'}',
                    ),
                    subtitle: Text(switch (member.status) {
                      'active' => 'Activo',
                      'suspended' => 'Suspendido',
                      _ => 'Baja',
                    }),
                    trailing: PopupMenuButton<String>(
                      onSelected: (action) => switch (action) {
                        'fees' => _fees(context, ref, member),
                        'certificate' => _certificado(context, ref, member),
                        'suspend' => runAdminAction(
                          context,
                          () => repo.setMemberStatus(
                            member.id,
                            member.status == 'active' ? 'suspended' : 'active',
                          ),
                        ),
                        'leave' =>
                          showConfirmDialog(
                            context,
                            title: 'Baja de socio',
                            message:
                                'El socio pasará a estado de baja '
                                '(conserva su historial).',
                            confirmLabel: 'Dar de baja',
                            destructive: true,
                          ).then((ok) {
                            if (ok && context.mounted) {
                              runAdminAction(
                                context,
                                () => repo.setMemberStatus(member.id, 'left'),
                              );
                            }
                          }),
                        _ => null,
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: 'fees',
                          child: Text('Cuotas'),
                        ),
                        const PopupMenuItem(
                          value: 'certificate',
                          child: Text('Emitir certificado'),
                        ),
                        PopupMenuItem(
                          value: 'suspend',
                          child: Text(
                            member.status == 'active'
                                ? 'Suspender'
                                : 'Reactivar',
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'leave',
                          child: Text('Dar de baja'),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _FeesSheet extends ConsumerWidget {
  const _FeesSheet({required this.member});

  final Member member;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fees = ref.watch(memberFeesProvider(member.id));
    final repo = ref.read(adminRepositoryProvider);
    final year = DateTime.now().year.toString();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cuotas del socio nº '
              '${member.memberNumber.toString().padLeft(4, '0')}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            fees.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
              data: (list) => Column(
                children: [
                  if (list.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('Sin cuotas registradas'),
                    ),
                  for (final fee in list)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        '${fee.id} · ${Formatters.currency.format(fee.amount)}',
                      ),
                      subtitle: Text(switch (fee.status) {
                        'paid' => 'Pagada',
                        'exempt' => 'Exento',
                        _ => 'Pendiente',
                      }),
                      trailing: fee.status == 'pending'
                          ? FilledButton(
                              onPressed: () => runAdminAction(
                                context,
                                () => repo.setFee(
                                  uid: member.id,
                                  year: fee.id,
                                  amount: fee.amount,
                                  status: 'paid',
                                  method: 'efectivo/transferencia',
                                ),
                                successMessage: 'Cuota marcada como pagada',
                              ),
                              child: const Text('Marcar pagada'),
                            )
                          : null,
                    ),
                  if (!list.any((f) => f.id == year))
                    OutlinedButton.icon(
                      onPressed: () => runAdminAction(
                        context,
                        () => repo.setFee(
                          uid: member.id,
                          year: year,
                          amount: 20,
                          status: 'pending',
                        ),
                        successMessage: 'Cuota de $year creada',
                      ),
                      icon: const Icon(Icons.add),
                      label: Text('Crear cuota de $year'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Gestión de usuarios y roles (presidente o admin).
class UsersTab extends ConsumerStatefulWidget {
  const UsersTab({super.key});

  @override
  ConsumerState<UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends ConsumerState<UsersTab> {
  String _filter = '';

  Future<void> _changeRole(AppUser user) async {
    final myRole = ref.read(currentRoleProvider);
    final selectable = UserRole.values
        .where((r) => r.rank <= myRole.rank)
        .toList();

    final selected = await showDialog<UserRole>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Rol de ${user.displayName}'),
        children: [
          for (final role in selectable)
            RadioListTile<UserRole>(
              // ignore: deprecated_member_use
              value: role,
              // ignore: deprecated_member_use
              groupValue: user.userRole,
              title: Text(role.label),
              // ignore: deprecated_member_use
              onChanged: (r) => Navigator.of(context).pop(r),
            ),
        ],
      ),
    );
    if (selected == null || selected == user.userRole || !mounted) return;

    if (selected.rank >= UserRole.presidente.rank) {
      final ok = await showConfirmDialog(
        context,
        title: 'Confirmar rol elevado',
        message:
            '${user.displayName} tendrá control total como '
            '${selected.label}. ¿Seguro?',
        confirmLabel: 'Confirmar',
      );
      if (!ok || !mounted) return;
    }
    if (!mounted) return;
    await runAdminAction(
      context,
      () => ref.read(adminRepositoryProvider).setRole(user.id, selected.id),
      successMessage: '${user.displayName} ahora es ${selected.label}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(allUsersProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Buscar usuario…',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) => setState(() => _filter = value),
          ),
        ),
        Expanded(
          child: users.when(
            loading: () => const ShimmerList(itemHeight: 64),
            error: (error, _) => ErrorView(
              error: error,
              onRetry: () => ref.invalidate(allUsersProvider),
            ),
            data: (list) {
              final filtered = list
                  .where(
                    (u) =>
                        u.displayName.toLowerCase().contains(
                          _filter.toLowerCase(),
                        ) ||
                        u.email.toLowerCase().contains(_filter.toLowerCase()),
                  )
                  .toList();
              if (filtered.isEmpty) {
                return const EmptyState(
                  icon: Icons.people_outline,
                  title: 'Sin usuarios que coincidan',
                );
              }
              return ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, i) {
                  final user = filtered[i];
                  return ListTile(
                    leading: UserAvatar(
                      photoUrl: user.photoUrl,
                      name: user.displayName,
                      size: 40,
                    ),
                    title: Text(user.displayName, maxLines: 1),
                    subtitle: Text(user.email, maxLines: 1),
                    trailing: Chip(label: Text(user.userRole.label)),
                    onTap: () => _changeRole(user),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _UserSearchDialog extends StatefulWidget {
  const _UserSearchDialog({required this.title, required this.users});

  final String title;
  final List<AppUser> users;

  @override
  State<_UserSearchDialog> createState() => _UserSearchDialogState();
}

class _UserSearchDialogState extends State<_UserSearchDialog> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.users
        .where(
          (u) => u.displayName.toLowerCase().contains(_filter.toLowerCase()),
        )
        .take(12)
        .toList();
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Buscar persona…',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => _filter = value),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final user in filtered)
                    ListTile(
                      leading: UserAvatar(
                        photoUrl: user.photoUrl,
                        name: user.displayName,
                        size: 36,
                      ),
                      title: Text(user.displayName),
                      subtitle: Text(user.email),
                      onTap: () => Navigator.of(context).pop(user),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
