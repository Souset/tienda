import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/models/event_item.dart';
import 'event_type_labels.dart';

/// Tarjeta elegante de evento para la lista de agenda: chip del tipo, título,
/// fecha/hora, lugar y badge de plazas. Monocroma, coherente con el tema.
class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event, this.onTap});

  final EventItem event;
  final VoidCallback? onTap;

  /// Texto de disponibilidad de plazas ('12/60 plazas' o 'Completo').
  String _seatsLabel() {
    if (event.capacity <= 0) return 'Entrada libre';
    if (event.reservedCount >= event.capacity) return 'Completo';
    return '${event.reservedCount}/${event.capacity} plazas';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final start = event.start;
    final full = event.capacity > 0 && event.reservedCount >= event.capacity;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _TypeChip(type: event.type),
                  const Spacer(),
                  _SeatsBadge(label: _seatsLabel(), full: full),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                event.title,
                style: theme.textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (start != null) ...[
                const SizedBox(height: 8),
                _IconLine(
                  icon: Icons.schedule_outlined,
                  text: Formatters.dateTime.format(start),
                ),
              ],
              if (event.venue != null && event.venue!.name.isNotEmpty) ...[
                const SizedBox(height: 6),
                _IconLine(icon: Icons.place_outlined, text: event.venue!.name),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Chip con icono y etiqueta del tipo de evento.
class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            EventTypeLabels.icon(type),
            size: 14,
            color: scheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(EventTypeLabels.label(type), style: theme.textTheme.labelSmall),
        ],
      ),
    );
  }
}

/// Badge de plazas: resaltado cuando el evento está completo.
class _SeatsBadge extends StatelessWidget {
  const _SeatsBadge({required this.label, required this.full});

  final String label;
  final bool full;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: full ? scheme.onSurface : scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: full ? scheme.surface : scheme.onSurfaceVariant,
          fontWeight: full ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}

/// Línea con icono pequeño y texto secundario.
class _IconLine extends StatelessWidget {
  const _IconLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
      children: [
        Icon(icon, size: 16, color: scheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
