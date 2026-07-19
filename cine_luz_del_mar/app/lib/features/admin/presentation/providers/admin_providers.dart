import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/models/models.dart';
import '../../data/admin_repository.dart';
import '../../domain/admin_stats.dart';

final adminRepositoryProvider = Provider<AdminRepository>(
  (ref) => AdminRepository(),
);

final adminStatsProvider = FutureProvider<AdminStats>(
  (ref) => ref.watch(adminRepositoryProvider).loadStats(),
);

final allNewsProvider = StreamProvider<List<NewsItem>>(
  (ref) => ref.watch(adminRepositoryProvider).watchAllNews(),
);

final allEventsProvider = StreamProvider<List<EventItem>>(
  (ref) => ref.watch(adminRepositoryProvider).watchAllEvents(),
);

final allFilmsProvider = StreamProvider<List<Film>>(
  (ref) => ref.watch(adminRepositoryProvider).watchAllFilms(),
);

final allLibraryProvider = StreamProvider<List<LibraryResource>>(
  (ref) => ref.watch(adminRepositoryProvider).watchAllLibrary(),
);

final allMembersProvider = StreamProvider<List<Member>>(
  (ref) => ref.watch(adminRepositoryProvider).watchAllMembers(),
);

final allUsersProvider = StreamProvider<List<AppUser>>(
  (ref) => ref.watch(adminRepositoryProvider).watchUsers(),
);

final adminUserProvider = FutureProvider.family<AppUser?, String>(
  (ref, uid) => ref.watch(adminRepositoryProvider).getUser(uid),
);

final memberFeesProvider = StreamProvider.family<List<MemberFee>, String>(
  (ref, uid) => ref.watch(adminRepositoryProvider).watchFees(uid),
);
