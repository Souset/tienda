import 'package:hooks_riverpod/hooks_riverpod.dart';
// StateProvider es un provider legacy en Riverpod 3.x: se importa aparte.
import 'package:hooks_riverpod/legacy.dart';

import '../../../../shared/models/models.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/library_repository_impl.dart';
import '../../domain/repositories/library_repository.dart';

/// Repositorio de biblioteca (implementación Firestore).
final libraryRepositoryProvider = Provider<LibraryRepository>((ref) {
  return LibraryRepositoryImpl();
});

/// Tipo de recurso seleccionado en los filtros (null = todos).
final selectedTypeProvider = StateProvider<String?>((ref) => null);

/// Categoría seleccionada en los filtros (null = todas).
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

/// Recursos de la biblioteca visibles para el rol actual, con los filtros de
/// tipo y categoría aplicados.
final resourcesProvider = StreamProvider<List<LibraryResource>>((ref) {
  final role = ref.watch(currentRoleProvider);
  final type = ref.watch(selectedTypeProvider);
  final category = ref.watch(selectedCategoryProvider);
  return ref
      .watch(libraryRepositoryProvider)
      .watchResources(role: role, type: type, category: category);
});
