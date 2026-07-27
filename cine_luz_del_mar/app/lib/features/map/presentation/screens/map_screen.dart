import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../shared/models/models.dart';
import '../providers/map_providers.dart';

/// Mapa de actividades (OpenStreetMap, sin coste ni API key) con la
/// localización de los eventos publicados y la posición del usuario.
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final _mapController = MapController();

  // Centro por defecto: España, hasta que haya eventos o posición.
  static const _fallbackCenter = LatLng(40.0, -3.7);

  /// Filtro que integra los tiles claros de OSM en el tema oscuro:
  /// invierte y desatura, manteniendo la legibilidad de las etiquetas.
  static const _darkTileFilter = ColorFilter.matrix(<double>[
    -0.85, 0, 0, 0, 255, //
    0, -0.85, 0, 0, 255, //
    0, 0, -0.85, 0, 255, //
    0, 0, 0, 1, 0,
  ]);

  void _openEvent(EventItem event) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final theme = Theme.of(context);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title, style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                if (event.start != null)
                  Row(
                    children: [
                      const Icon(Icons.schedule, size: 18),
                      const SizedBox(width: 8),
                      Text(Formatters.dateTime.format(event.start!)),
                    ],
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.place_outlined, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${event.venue!.name} · ${event.venue!.address}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.push('/agenda/${event.id}');
                    },
                    child: const Text('Ver actividad'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _goToMyLocation() async {
    final position = await ref.read(userPositionProvider.future);
    if (position == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo obtener tu ubicación (revisa permisos)'),
          ),
        );
      }
      return;
    }
    _mapController.move(LatLng(position.latitude, position.longitude), 14);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final events = ref.watch(mapEventsProvider);
    final items = events.value ?? const <EventItem>[];

    final center = items.isNotEmpty
        ? LatLng(items.first.venue!.lat, items.first.venue!.lng)
        : _fallbackCenter;

    Widget tiles = TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'es.cineluzdelmar.app',
    );
    if (isDark) {
      tiles = ColorFiltered(colorFilter: _darkTileFilter, child: tiles);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Mapa de actividades')),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToMyLocation,
        tooltip: 'Mi ubicación',
        child: const Icon(Icons.my_location),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: center,
          initialZoom: items.isNotEmpty ? 13 : 5.5,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
        ),
        children: [
          tiles,
          MarkerLayer(
            markers: [
              for (final event in items)
                Marker(
                  point: LatLng(event.venue!.lat, event.venue!.lng),
                  width: 44,
                  height: 44,
                  child: GestureDetector(
                    onTap: () => _openEvent(event),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.onPrimary,
                          width: 2,
                        ),
                        boxShadow: const [
                          BoxShadow(blurRadius: 8, color: Colors.black45),
                        ],
                      ),
                      child: Icon(
                        Icons.local_movies_outlined,
                        size: 22,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution('© OpenStreetMap contributors'),
            ],
          ),
        ],
      ),
    );
  }
}
