import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/models/models.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/chat_repository.dart';

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => ChatRepository(),
);

final myChatsProvider = StreamProvider<List<Chat>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(const []);
  return ref.watch(chatRepositoryProvider).watchMyChats(user.id);
});

final chatMessagesProvider = StreamProvider.family<List<ChatMessage>, String>(
  (ref, chatId) => ref.watch(chatRepositoryProvider).watchMessages(chatId),
);

final chatUserProvider = FutureProvider.family<AppUser?, String>(
  (ref, uid) => ref.watch(chatRepositoryProvider).getUser(uid),
);
