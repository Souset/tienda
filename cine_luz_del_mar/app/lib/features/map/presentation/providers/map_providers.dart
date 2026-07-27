import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/models/models.dart';
import '../../data/map_repository.dart';

final mapRepositoryProvider = Provider<MapRepository>((ref) => MapRepository());

final mapEventsProvider = StreamProvider<List<EventItem>>(
  (ref) => ref.watch(mapRepositoryProvider).watchLocatedEvents(),
);

/// Posición del usuario (null si no da permiso o no está disponible).
final userPositionProvider = FutureProvider<Position?>((ref) async {
  try {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return null;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
      ),
    );
  } catch (_) {
    return null;
  }
});
