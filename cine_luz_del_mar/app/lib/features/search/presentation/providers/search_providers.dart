import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart'
    as auth_feature;
import '../../data/search_repository.dart';
import '../../domain/search_results.dart';

final searchRepositoryProvider = Provider<SearchRepository>(
  (ref) => SearchRepository(),
);

/// Término de búsqueda actual (lo escribe la pantalla con debounce).
class SearchQueryNotifier extends Notifier<String> {
  Timer? _debounce;

  @override
  String build() {
    ref.onDispose(() => _debounce?.cancel());
    return '';
  }

  /// Aplica el término tras 350 ms sin teclear.
  void update(String term) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      state = term.trim();
    });
  }

  void clear() {
    _debounce?.cancel();
    state = '';
  }
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

/// Resultados de la búsqueda activa.
final searchResultsProvider = FutureProvider<SearchResults>((ref) async {
  final term = ref.watch(searchQueryProvider);
  if (term.length < 2) return const SearchResults();

  final user = ref.watch(auth_feature.currentUserProvider);
  final role = ref.watch(auth_feature.currentRoleProvider);
  return ref
      .read(searchRepositoryProvider)
      .search(term, signedIn: user != null, role: role);
});
