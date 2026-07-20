import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/widgets/app_shimmer.dart';
import '../../../../shared/widgets/confirm_dialog.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../providers/admin_providers.dart';
import 'content_tabs.dart' show runAdminAction;

/// Gestión de los packs de socio: precios, ventajas, periodicidad y orden.
///
/// Todo lo que se ve en la pantalla "Hazte socio" se configura aquí. El
/// precio que cobra Stripe se lee siempre de estos documentos en el
/// servidor: cambiar el precio aquí cambia lo que se cobra desde ese
/// momento (nunca afecta a pagos ya realizados).
class PlansTab extends ConsumerWidget {
  const PlansTab({super.key});

  void _edit(BuildContext context, [MembershipPlan? plan]) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _PlanEditSheet(plan: plan),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plans = ref.watch(allPlansProvider);
    final repo = ref.read(adminRepositoryProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'nuevo-pack',
        onPressed: () => _edit(context),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo pack'),
      ),
      body: plans.when(
        loading: () => const ShimmerList(itemHeight: 72),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(allPlansProvider),
        ),
        data: (list) => list.isEmpty
            ? EmptyState(
                icon: Icons.card_membership_outlined,
                title: 'Aún no hay packs de socio',
                message:
                    'Crea los packs de ejemplo y ajústalos a tu gusto: '
                    'precio, ventajas, periodicidad y orden.',
                actionLabel: 'Crear packs de ejemplo',
                onAction: () => runAdminAction(
                  context,
                  repo.createDefaultPlans,
                  successMessage:
                      'Packs de ejemplo creados: edítalos a tu gusto',
                ),
              )
            : ListView(
                padding: const EdgeInsets.only(bottom: 96),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                    child: Text(
                      'Estos packs son los que ven los usuarios en '
                      '"Hazte socio". El precio se cobra siempre desde el '
                      'servidor: cambiarlo aquí lo cambia al instante.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  for (final plan in list)
                    ListTile(
                      leading: Icon(
                        plan.active
                            ? Icons.card_membership_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      title: Text(
                        plan.highlight ? '${plan.name} ★' : plan.name,
                      ),
                      subtitle: Text(
                        '${Formatters.currency.format(plan.price)} '
                        '${plan.periodLabel}'
                        '${plan.active ? '' : ' · oculto'}',
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (action) => switch (action) {
                          'edit' => _edit(context, plan),
                          'toggle' => runAdminAction(
                            context,
                            () => ref
                                .read(adminRepositoryProvider)
                                .savePlan(plan.copyWith(active: !plan.active)),
                          ),
                          'delete' =>
                            showConfirmDialog(
                              context,
                              title: 'Eliminar pack',
                              message:
                                  'Se eliminará "${plan.name}". Los socios '
                                  'que ya lo tienen no se ven afectados.',
                              confirmLabel: 'Eliminar',
                              destructive: true,
                            ).then((ok) {
                              if (ok && context.mounted) {
                                runAdminAction(
                                  context,
                                  () => ref
                                      .read(adminRepositoryProvider)
                                      .deletePlan(plan.id),
                                );
                              }
                            }),
                          _ => null,
                        },
                        itemBuilder: (_) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Editar'),
                          ),
                          PopupMenuItem(
                            value: 'toggle',
                            child: Text(plan.active ? 'Ocultar' : 'Publicar'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Eliminar'),
                          ),
                        ],
                      ),
                      onTap: () => _edit(context, plan),
                    ),
                ],
              ),
      ),
    );
  }
}

/// Hoja de creación/edición de un pack de socio.
class _PlanEditSheet extends ConsumerStatefulWidget {
  const _PlanEditSheet({this.plan});

  final MembershipPlan? plan;

  @override
  ConsumerState<_PlanEditSheet> createState() => _PlanEditSheetState();
}

class _PlanEditSheetState extends ConsumerState<_PlanEditSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _description;
  late final TextEditingController _price;
  late final TextEditingController _benefits;
  late final TextEditingController _order;
  late String _period;
  late bool _active;
  late bool _highlight;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final plan = widget.plan;
    _name = TextEditingController(text: plan?.name ?? '');
    _description = TextEditingController(text: plan?.description ?? '');
    _price = TextEditingController(
      text: plan == null ? '' : plan.price.toStringAsFixed(2),
    );
    _benefits = TextEditingController(text: plan?.benefits.join('\n') ?? '');
    _order = TextEditingController(text: (plan?.order ?? 0).toString());
    _period = plan?.period ?? 'anual';
    _active = plan?.active ?? true;
    _highlight = plan?.highlight ?? false;
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _price.dispose();
    _benefits.dispose();
    _order.dispose();
    super.dispose();
  }

  double? _parsePrice(String value) =>
      double.tryParse(value.trim().replaceAll(',', '.'));

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final plan = (widget.plan ?? const MembershipPlan()).copyWith(
      name: _name.text.trim(),
      description: _description.text.trim(),
      price: _parsePrice(_price.text) ?? 0,
      period: _period,
      benefits: [
        for (final line in _benefits.text.split('\n'))
          if (line.trim().isNotEmpty) line.trim(),
      ],
      order: int.tryParse(_order.text.trim()) ?? 0,
      active: _active,
      highlight: _highlight,
    );
    try {
      await ref.read(adminRepositoryProvider).savePlan(plan);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('No se pudo guardar el pack')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + bottomInset),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              widget.plan == null ? 'Nuevo pack de socio' : 'Editar pack',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Nombre del pack'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Pon un nombre' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _description,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Descripción breve',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _price,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Precio',
                      suffixText: '€',
                    ),
                    validator: (v) {
                      final price = _parsePrice(v ?? '');
                      if (price == null) return 'Precio no válido';
                      if (price < 0.5) return 'Mínimo 0,50 € (límite Stripe)';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _period,
                    decoration: const InputDecoration(
                      labelText: 'Periodicidad',
                    ),
                    items: const [
                      DropdownMenuItem(value: 'anual', child: Text('Anual')),
                      DropdownMenuItem(
                        value: 'mensual',
                        child: Text('Mensual'),
                      ),
                      DropdownMenuItem(
                        value: 'unica',
                        child: Text('Pago único'),
                      ),
                    ],
                    onChanged: (v) => setState(() => _period = v ?? 'anual'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _benefits,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Ventajas (una por línea)',
                alignLabelWithHint: true,
                hintText:
                    'Entrada libre a proyecciones\nDescuento en talleres',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _order,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Orden (menor = primero)',
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Visible en "Hazte socio"'),
              value: _active,
              onChanged: (v) => setState(() => _active = v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Destacado (etiqueta "Recomendado")'),
              value: _highlight,
              onChanged: (v) => setState(() => _highlight = v),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.4),
                    )
                  : const Text('Guardar pack'),
            ),
          ],
        ),
      ),
    );
  }
}
