import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/errors/app_exception.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/profile/data/favorites_repository.dart';

/// Corazón de favorito para películas y eventos (monocromo).
///
/// Sin sesión invita a iniciar sesión; con sesión alterna el id en la lista
/// correspondiente del perfil.
class FavoriteButton extends ConsumerWidget {
  const FavoriteButton.film(this.itemId, {super.key}) : field = 'favoriteFilms';

  const FavoriteButton.event(this.itemId, {super.key})
    : field = 'favoriteEvents';

  final String itemId;
  final String field;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final favorites = switch (field) {
      'favoriteFilms' => user?.favoriteFilms ?? const <String>[],
      _ => user?.favoriteEvents ?? const <String>[],
    };
    final isFavorite = favorites.contains(itemId);

    return IconButton(
      tooltip: isFavorite ? 'Quitar de favoritos' : 'Añadir a favoritos',
      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
      onPressed: () async {
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Inicia sesión para guardar favoritos'),
            ),
          );
          return;
        }
        try {
          await ref
              .read(favoritesRepositoryProvider)
              .toggle(
                uid: user.id,
                field: field,
                itemId: itemId,
                isFavorite: isFavorite,
              );
        } on AppException catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(e.message)));
          }
        }
      },
    );
  }
}
