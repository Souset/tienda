import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/models/models.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/notifications_repository_impl.dart';
import '../../domain/repositories/notifications_repository.dart';

/// Repositorio de notificaciones (implementación Firestore).
final notificationsRepositoryProvider = Provider<NotificationsRepository>((
  ref,
) {
  return NotificationsRepositoryImpl();
});

/// Bandeja de notificaciones del usuario actual (vacía sin sesión iniciada).
final inboxProvider = StreamProvider<List<AppNotification>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(const []);
  return ref.watch(notificationsRepositoryProvider).watchInbox(user.id);
});

/// Número de notificaciones no leídas (0 sin sesión), para el badge.
final unreadCountProvider = StreamProvider<int>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(0);
  return ref.watch(notificationsRepositoryProvider).watchUnreadCount(user.id);
});
