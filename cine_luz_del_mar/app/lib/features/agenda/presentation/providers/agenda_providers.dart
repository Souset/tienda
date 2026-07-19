import 'package:hooks_riverpod/hooks_riverpod.dart';
// StateProvider es un provider legacy en Riverpod 3.x: se importa aparte.
import 'package:hooks_riverpod/legacy.dart';

import '../../../../shared/models/app_user.dart';
import '../../../../shared/models/event_item.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/agenda_repository_impl.dart';
import '../../domain/repositories/agenda_repository.dart';

/// Repositorio de agenda (implementación Firestore).
final agendaRepositoryProvider = Provider<AgendaRepository>((ref) {
  return AgendaRepositoryImpl();
});

/// Próximos eventos publicados.
final upcomingEventsProvider = StreamProvider<List<EventItem>>((ref) {
  return ref.watch(agendaRepositoryProvider).watchUpcoming();
});

/// Mes seleccionado en el calendario (día 1 del mes en curso por defecto).
final selectedMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, 1);
});

/// Eventos publicados del mes seleccionado (para pintar los marcadores).
final monthEventsProvider = StreamProvider<List<EventItem>>((ref) {
  final month = ref.watch(selectedMonthProvider);
  return ref.watch(agendaRepositoryProvider).watchByMonth(month);
});

/// Detalle reactivo de un evento por id.
final eventProvider = StreamProvider.family<EventItem?, String>((ref, id) {
  return ref.watch(agendaRepositoryProvider).watchEvent(id);
});

/// Reserva del usuario actual para un evento (null si no hay sesión o reserva).
final myReservationProvider = StreamProvider.family<Reservation?, String>((
  ref,
  eventId,
) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream<Reservation?>.value(null);
  return ref
      .watch(agendaRepositoryProvider)
      .watchMyReservation(eventId, user.id);
});

/// Controlador de acciones de reserva (reservar / cancelar).
///
/// Expone un [AsyncValue] de estado que la UI observa para mostrar spinners
/// en el botón y traducir errores a SnackBars.
class AgendaController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  AgendaRepository get _repo => ref.read(agendaRepositoryProvider);

  Future<void> reserve(EventItem event, AppUser user) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.reserve(event, user));
  }

  Future<void> cancel(String eventId, String uid) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.cancelReservation(eventId, uid));
  }
}

final agendaControllerProvider =
    NotifierProvider<AgendaController, AsyncValue<void>>(AgendaController.new);

/// Valoración propia del evento (null si aún no valoró o sin sesión).
final myEventScoreProvider = StreamProvider.family<double?, String>((
  ref,
  eventId,
) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(null);
  return ref
      .watch(agendaRepositoryProvider)
      .watchMyEventScore(eventId, user.id);
});
