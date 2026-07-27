import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/models/membership_plan.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/app_shimmer.dart';
import '../providers/members_providers.dart';

/// Medidas de la rejilla de packs (móvil: una columna; escritorio: varias).
const double _minCardWidth = 300;
const double _maxContentWidth = 1240;
const double _gap = 16;

/// Pantalla "Hazte socio" (ruta `/socio`): packs de socio configurados por
/// la junta, con pago online mediante Stripe Checkout.
class BecomeMemberScreen extends ConsumerWidget {
  const BecomeMemberScreen({super.key});

  Future<void> _pay(
    BuildContext context,
    WidgetRef ref,
    MembershipPlan plan,
  ) async {
    final uri = await ref
        .read(checkoutControllerProvider.notifier)
        .createCheckout(plan.id);
    if (uri == null) {
      if (!context.mounted) return;
      final state = ref.read(checkoutControllerProvider);
      final error = state.error;
      final message = error is AppException
          ? error.message
          : 'No se pudo iniciar el pago. Inténtalo de nuevo.';
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
      return;
    }
    // En web redirige en la misma pestaña: Stripe devuelve al usuario a
    // /#/socio/pago-ok o /#/socio/pago-cancelado al terminar.
    await launchUrl(uri, webOnlyWindowName: '_self');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(activePlansProvider);
    final member = ref.watch(myMemberProvider).value;
    final paying = ref.watch(checkoutControllerProvider).isLoading;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Hazte socio')),
      body: plansAsync.when(
        loading: () => const ShimmerList(itemHeight: 220),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(activePlansProvider),
        ),
        data: (plans) {
          if (plans.isEmpty) {
            return const EmptyState(
              icon: Icons.card_membership_outlined,
              title: 'Muy pronto podrás hacerte socio desde aquí',
              message:
                  'Mientras tanto, habla con la junta en cualquier '
                  'actividad de la asociación.',
            );
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              // Rejilla responsive: tantas tarjetas por fila como quepan
              // con un ancho cómodo, centradas y sin estirarse de más.
              final width = constraints.maxWidth.clamp(0.0, _maxContentWidth);
              final columns = ((width - 32 + _gap) / (_minCardWidth + _gap))
                  .floor()
                  .clamp(1, 4);
              final rows = <List<(int, MembershipPlan)>>[];
              for (var i = 0; i < plans.length; i += columns) {
                rows.add([
                  for (var j = i; j < i + columns && j < plans.length; j++)
                    (j, plans[j]),
                ]);
              }

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: _maxContentWidth,
                  ),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 8, 4, 16),
                        child: Text(
                          member != null
                              ? 'Ya eres socio: al pagar renovarás tu cuota '
                                    'con el pack que elijas.'
                              : 'Elige tu pack, paga online de forma segura '
                                    'y tu carné digital se activará al '
                                    'instante.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      for (final row in rows)
                        Padding(
                          padding: const EdgeInsets.only(bottom: _gap),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (final (index, plan) in row) ...[
                                  if (index != row.first.$1)
                                    const SizedBox(width: _gap),
                                  Expanded(
                                    child:
                                        _PlanCard(
                                          plan: plan,
                                          busy: paying,
                                          // En rejilla el botón se alinea
                                          // abajo para que todas cuadren.
                                          fillHeight: columns > 1,
                                          onPay: () => _pay(context, ref, plan),
                                        ).animate().fadeIn(
                                          delay: (80 * index).ms,
                                          duration: 350.ms,
                                        ),
                                  ),
                                ],
                                // Huecos de la última fila incompleta: así
                                // las tarjetas no se ensanchan de más.
                                for (var i = row.length; i < columns; i++) ...[
                                  const SizedBox(width: _gap),
                                  const Expanded(child: SizedBox()),
                                ],
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_outline,
                            size: 16,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'Pago seguro con Stripe. No guardamos los '
                              'datos de tu tarjeta.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Tarjeta de un pack de socio.
class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.busy,
    required this.onPay,
    this.fillHeight = false,
  });

  final MembershipPlan plan;
  final bool busy;
  final VoidCallback onPay;

  /// En rejilla, la tarjeta ocupa toda la altura de su fila y el botón
  /// queda anclado abajo (en lista vertical, la altura es la del contenido).
  final bool fillHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final highlight = plan.highlight;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(
          color: highlight
              ? theme.colorScheme.onSurface
              : theme.colorScheme.outlineVariant,
          width: highlight ? 1.6 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: fillHeight ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(plan.name, style: theme.textTheme.titleLarge),
              ),
              if (highlight)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface,
                    borderRadius: BorderRadius.circular(AppTheme.radiusS),
                  ),
                  child: Text(
                    'Recomendado',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.surface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Formatters.currency.format(plan.price),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  plan.periodLabel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          if (plan.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(plan.description, style: theme.textTheme.bodyMedium),
          ],
          if (plan.benefits.isNotEmpty) ...[
            const SizedBox(height: 12),
            for (final benefit in plan.benefits)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check,
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        benefit,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
          ],
          if (fillHeight) const Spacer() else const SizedBox(height: 16),
          if (fillHeight) const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: busy ? null : onPay,
              icon: busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2.2),
                    )
                  : const Icon(Icons.arrow_forward_rounded, size: 18),
              label: Text(busy ? 'Preparando el pago…' : 'Elegir este pack'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Pantalla de vuelta desde Stripe (rutas `/socio/pago-ok` y
/// `/socio/pago-cancelado`).
///
/// El pago lo confirma el webhook del servidor: esta pantalla observa las
/// cuotas del usuario y muestra el éxito cuando aparece la cuota pagada.
class PaymentResultScreen extends ConsumerStatefulWidget {
  const PaymentResultScreen({super.key, required this.success});

  final bool success;

  @override
  ConsumerState<PaymentResultScreen> createState() =>
      _PaymentResultScreenState();
}

class _PaymentResultScreenState extends ConsumerState<PaymentResultScreen> {
  bool _slow = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.success) {
      // Si el webhook tarda (raro), no dejar al usuario ante un spinner
      // eterno: pasados 30 s se le tranquiliza y se le deja continuar.
      _timer = Timer(const Duration(seconds: 30), () {
        if (mounted) setState(() => _slow = true);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool _isConfirmed() {
    final fees = ref.watch(myFeesProvider).value ?? const [];
    final now = DateTime.now();
    return fees.any(
      (fee) =>
          fee.status == 'paid' &&
          fee.paidAt != null &&
          now.difference(fee.paidAt!).inMinutes < 60,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!widget.success) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pago cancelado')),
        body: EmptyState(
          icon: Icons.remove_shopping_cart_outlined,
          title: 'No se ha realizado ningún cargo',
          message:
              'Has cancelado el pago. Puedes intentarlo de nuevo '
              'cuando quieras.',
          actionLabel: 'Volver a los packs',
          onAction: () => context.go('/socio'),
        ),
      );
    }

    final confirmed = _isConfirmed();

    return Scaffold(
      appBar: AppBar(title: const Text('Pago completado')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: confirmed
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_rounded, size: 72)
                        .animate()
                        .scale(
                          begin: const Offset(0.6, 0.6),
                          curve: Curves.easeOutBack,
                          duration: 400.ms,
                        ),
                    const SizedBox(height: 20),
                    Text(
                      '¡Bienvenido/a, socio/a!',
                      style: theme.textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tu cuota está pagada y tu carné digital ya está '
                      'activo.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => context.go('/carne'),
                      icon: const Icon(Icons.badge_outlined, size: 18),
                      label: const Text('Ver mi carné'),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 24),
                    Text(
                      'Confirmando tu pago…',
                      style: theme.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _slow
                          ? 'El banco está tardando más de lo normal. '
                                'Recibirás una notificación en cuanto se '
                                'confirme; no hace falta que esperes aquí.'
                          : 'Suele tardar solo unos segundos.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (_slow) ...[
                      const SizedBox(height: 24),
                      OutlinedButton(
                        onPressed: () => context.go('/carne'),
                        child: const Text('Ir a mi carné'),
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
