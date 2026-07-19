import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/models/event_item.dart';
import '../../../../shared/widgets/confirm_dialog.dart';
import '../../../../shared/widgets/favorite_button.dart';
import '../../../../shared/widgets/brightness_boost.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/agenda_providers.dart';
import '../widgets/event_type_labels.dart';

/// Detalle de un evento: cabecera con imagen, datos, lugar, descripción y
/// CTA inferior fijo de reserva/cancelación según el estado del usuario.
class EventDetailScreen extends ConsumerWidget {
  const EventDetailScreen({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventProvider(eventId));

    return Scaffold(
      body: eventAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Scaffold(
          appBar: AppBar(),
          body: ErrorView(
            error: error,
            onRetry: () => ref.invalidate(eventProvider(eventId)),
          ),
        ),
        data: (event) {
          if (event == null) {
            return Scaffold(
              appBar: AppBar(),
              body: const ErrorView(error: NotFoundException()),
            );
          }
          return _EventDetailBody(event: event);
        },
      ),
    );
  }
}

class _EventDetailBody extends ConsumerWidget {
  const _EventDetailBody({required this.event});

  final EventItem event;

  Future<void> _openDirections(BuildContext context, Venue venue) async {
    final uri = Uri.parse(
      'https://www.openstreetmap.org/?mlat=${venue.lat}&mlon=${venue.lng}',
    );
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No se pudo abrir el mapa')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final start = event.start;
    final venue = event.venue;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 260,
          pinned: true,
          actions: [FavoriteButton.event(event.id)],
          flexibleSpace: FlexibleSpaceBar(
            background: Hero(
              tag: 'event-${event.id}',
              child: _CoverImage(coverUrl: event.coverUrl),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _InfoChip(
                      icon: EventTypeLabels.icon(event.type),
                      label: EventTypeLabels.label(event.type),
                    ),
                    if (start != null)
                      _InfoChip(
                        icon: Icons.schedule_outlined,
                        label: Formatters.dateTime.format(start),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(event.title, style: theme.textTheme.headlineMedium),
                if (venue != null && venue.name.isNotEmpty) ...[
                  const SizedBox(height: 28),
                  Text('Lugar', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(venue.name, style: theme.textTheme.bodyLarge),
                  if (venue.address.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      venue.address,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  if (venue.lat != 0 || venue.lng != 0) ...[
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => _openDirections(context, venue),
                      icon: const Icon(Icons.directions_outlined),
                      label: const Text('Cómo llegar'),
                    ),
                  ],
                ],
                if (event.description.isNotEmpty) ...[
                  const SizedBox(height: 28),
                  Text('Descripción', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                ],
                _EventFeedback(event: event),
              ],
            ).animate().fadeIn(duration: 300.ms),
          ),
        ),
      ],
    ).withBottomCta(event: event);
  }
}

/// Imagen de portada con fallback a un contenedor con icono de película.
class _CoverImage extends StatelessWidget {
  const _CoverImage({this.coverUrl});

  final String? coverUrl;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fallback = Container(
      color: scheme.surfaceContainer,
      alignment: Alignment.center,
      child: Icon(Icons.movie, size: 64, color: scheme.onSurfaceVariant),
    );
    final url = coverUrl;
    if (url == null || url.isEmpty) return fallback;
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, _) => Container(color: scheme.surfaceContainer),
      errorWidget: (_, _, _) => fallback,
    );
  }
}

/// Chip informativo con icono y etiqueta.
class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: scheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(label, style: theme.textTheme.labelMedium),
        ],
      ),
    );
  }
}

/// Extensión para superponer el CTA inferior fijo sobre el contenido.
extension _BottomCta on Widget {
  Widget withBottomCta({required EventItem event}) {
    return Stack(
      children: [
        Positioned.fill(child: this),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _EventCta(event: event),
        ),
      ],
    );
  }
}

/// Barra inferior fija con la acción de reserva según el estado del usuario.
class _EventCta extends ConsumerWidget {
  const _EventCta({required this.event});

  final EventItem event;

  Future<void> _reserve(BuildContext context, WidgetRef ref) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    await ref.read(agendaControllerProvider.notifier).reserve(event, user);
    final state = ref.read(agendaControllerProvider);
    if (!context.mounted) return;
    if (state.hasError) {
      _showError(context, state.error);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('¡Plaza reservada!')));
    }
  }

  Future<void> _cancel(BuildContext context, WidgetRef ref) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    final confirmed = await showConfirmDialog(
      context,
      title: 'Cancelar reserva',
      message: '¿Seguro que quieres liberar tu plaza para este evento?',
      confirmLabel: 'Cancelar reserva',
      cancelLabel: 'Volver',
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    await ref.read(agendaControllerProvider.notifier).cancel(event.id, user.id);
    final state = ref.read(agendaControllerProvider);
    if (!context.mounted) return;
    if (state.hasError) {
      _showError(context, state.error);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Reserva cancelada')));
    }
  }

  void _showError(BuildContext context, Object? error) {
    final message = error is AppException
        ? error.message
        : 'No se pudo completar la acción';
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final user = ref.watch(currentUserProvider);
    final controllerState = ref.watch(agendaControllerProvider);
    final loading = controllerState.isLoading;
    final reservationAsync = ref.watch(myReservationProvider(event.id));
    final reservation = reservationAsync.value;
    final hasActiveReservation = reservation?.status == 'active';
    final remaining = event.capacity - event.reservedCount;
    final full = event.capacity > 0 && remaining <= 0;

    Widget content;
    if (user == null) {
      // Sin sesión: invitar a acceder.
      content = FilledButton(
        onPressed: () => context.go('/acceso'),
        child: const Text('Inicia sesión para reservar'),
      );
    } else if (hasActiveReservation) {
      // Con reserva activa: estado + cancelar.
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 20,
                color: scheme.onSurface,
              ),
              const SizedBox(width: 8),
              Text('Plaza reservada', style: theme.textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: () => _showTicketSheet(context, event.id, user.id),
                  icon: const Icon(Icons.qr_code_2),
                  label: const Text('Ver entrada'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: loading ? null : () => _cancel(context, ref),
                  child: loading ? const _BtnSpinner() : const Text('Cancelar'),
                ),
              ),
            ],
          ),
        ],
      );
    } else if (full) {
      // Aforo completo: botón deshabilitado.
      content = const FilledButton(onPressed: null, child: Text('Completo'));
    } else {
      // Con sesión y sin reserva: reservar.
      content = FilledButton(
        onPressed: loading ? null : () => _reserve(context, ref),
        child: loading
            ? const _BtnSpinner()
            : Text('Reservar plaza (quedan $remaining)'),
      );
    }

    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        16 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
      ),
      child: SizedBox(width: double.infinity, child: content),
    );
  }
}

/// Spinner pequeño para el interior de un botón durante la acción.

/// Entrada con QR de la reserva (brillo al máximo mientras se muestra).
void _showTicketSheet(BuildContext context, String eventId, String uid) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      final theme = Theme.of(context);
      return BrightnessBoost(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Tu entrada', style: theme.textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(
                  'Muéstrala en la puerta para el check-in',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: QrImageView(
                    data: '{"ev":"$eventId","uid":"$uid"}',
                    size: 210,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// Valoración del evento una vez celebrado (solo para quienes reservaron).
class _EventFeedback extends ConsumerStatefulWidget {
  const _EventFeedback({required this.event});

  final EventItem event;

  @override
  ConsumerState<_EventFeedback> createState() => _EventFeedbackState();
}

class _EventFeedbackState extends ConsumerState<_EventFeedback> {
  double _score = 0;
  bool _sending = false;

  Future<void> _send(double score) async {
    final user = ref.read(currentUserProvider);
    if (user == null || _sending) return;
    setState(() {
      _sending = true;
      _score = score;
    });
    try {
      await ref
          .read(agendaRepositoryProvider)
          .rateEvent(eventId: widget.event.id, uid: user.id, score: score);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Gracias por tu valoración!')),
        );
      }
    } on AppException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);
    final reservation = ref.watch(myReservationProvider(widget.event.id)).value;
    final ended =
        widget.event.start != null &&
        widget.event.start!.isBefore(
          DateTime.now().subtract(const Duration(hours: 3)),
        );
    if (user == null || reservation == null || !ended) {
      return const SizedBox.shrink();
    }

    final myScore = ref.watch(myEventScoreProvider(widget.event.id)).value;
    final shown = myScore ?? _score;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            myScore == null
                ? '¿Qué te pareció esta actividad?'
                : 'Tu valoración',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  onPressed: _sending ? null : () => _send(i.toDouble()),
                  icon: Icon(
                    shown >= i ? Icons.star : Icons.star_border,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              if (widget.event.feedbackCount > 0) ...[
                const Spacer(),
                Text(
                  '${widget.event.feedbackAvg.toStringAsFixed(1)} '
                  '(${widget.event.feedbackCount})',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _BtnSpinner extends StatelessWidget {
  const _BtnSpinner();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
