import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/models/models.dart';

/// Etiquetas en español de los tipos de actividad.
const Map<String, String> _typeLabels = {
  'proyeccion': 'Proyección',
  'taller': 'Taller',
  'charla': 'Charla',
  'festival': 'Festival',
};

/// Tarjeta compacta de una próxima actividad para el carrusel de Inicio.
class UpcomingEventCard extends StatelessWidget {
  const UpcomingEventCard({super.key, required this.event, this.onTap});

  final EventItem event;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remaining = event.capacity - event.reservedCount;
    final availability = event.capacity <= 0
        ? null
        : (remaining > 0 ? 'Quedan $remaining plazas' : 'Completo');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusM),
      child: Container(
        width: 280,
        height: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Chip(
                  label: Text(_typeLabels[event.type] ?? event.type),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const Spacer(),
                if (event.start != null)
                  Text(
                    Formatters.dayMonth.format(event.start!),
                    style: theme.textTheme.labelMedium,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              event.title,
              style: theme.textTheme.titleMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            if (event.venue != null && event.venue!.name.isNotEmpty)
              Text(
                event.venue!.name,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            if (availability != null)
              Text(
                availability,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: remaining > 0
                      ? theme.colorScheme.onSurfaceVariant
                      : theme.colorScheme.error,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
