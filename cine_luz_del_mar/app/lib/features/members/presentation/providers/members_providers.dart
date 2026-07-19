import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/models/attendance_record.dart';
import '../../../../shared/models/member.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/members_repository_impl.dart';
import '../../domain/repositories/members_repository.dart';

/// Repositorio de socios (implementación Firestore).
final membersRepositoryProvider = Provider<MembersRepository>((ref) {
  return MembersRepositoryImpl();
});

/// Documento de socio del usuario actual (null si no hay sesión o no es socio).
final myMemberProvider = StreamProvider<Member?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream<Member?>.value(null);
  return ref.watch(membersRepositoryProvider).watchMember(user.id);
});

/// Cuotas anuales del usuario actual (vacío si no hay sesión).
final myFeesProvider = StreamProvider<List<MemberFee>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream<List<MemberFee>>.value(const []);
  return ref.watch(membersRepositoryProvider).watchFees(user.id);
});

/// Historial de asistencia del usuario actual (vacío si no hay sesión).
final myAttendanceProvider = StreamProvider<List<AttendanceRecord>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream<List<AttendanceRecord>>.value(const []);
  return ref.watch(membersRepositoryProvider).watchAttendance(user.id);
});

/// Controlador de la acción de check-in (validación de entradas).
///
/// Expone un [AsyncValue] de estado que la pantalla de escaneo observa para
/// mostrar el resultado (éxito / error traducido) de cada validación.
class CheckInController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  MembersRepository get _repo => ref.read(membersRepositoryProvider);

  Future<void> checkIn({
    required String eventId,
    required String eventTitle,
    required String eventType,
    required String uid,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.checkIn(
        eventId: eventId,
        eventTitle: eventTitle,
        eventType: eventType,
        uid: uid,
      ),
    );
  }
}

final checkInControllerProvider =
    NotifierProvider<CheckInController, AsyncValue<void>>(
      CheckInController.new,
    );
