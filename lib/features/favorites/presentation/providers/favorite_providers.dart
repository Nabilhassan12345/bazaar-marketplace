import 'package:bazaar/features/favorites/data/datasources/favorite_remote_datasource.dart';
import 'package:bazaar/features/favorites/data/repositories/favorite_repository_impl.dart';
import 'package:bazaar/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:bazaar/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteRemoteDataSourceProvider = Provider<FavoriteRemoteDataSource>((ref) {
  return FavoriteRemoteDataSource();
});

final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  return FavoriteRepositoryImpl(ref.watch(favoriteRemoteDataSourceProvider));
});

class FavoritesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    ref.listen(authStateChangesProvider, (previous, next) {
      final user = next.valueOrNull;
      if (user == null) {
        state = {};
      } else if (previous?.valueOrNull?.id != user.id) {
        _loadFavorites(user.id);
      }
    });

    Future.microtask(_loadIfAuthenticated);
    return {};
  }

  Future<void> _loadIfAuthenticated() async {
    final user = ref.read(authStateChangesProvider).valueOrNull;
    if (user != null) {
      await _loadFavorites(user.id);
    }
  }

  Future<void> _loadFavorites(String userId) async {
    try {
      final ids = await ref.read(favoriteRepositoryProvider).getFavoriteIds(userId);
      state = ids;
    } catch (_) {
      state = {};
    }
  }

  Future<void> reload() async {
    final user = ref.read(authStateChangesProvider).valueOrNull;
    if (user != null) {
      await _loadFavorites(user.id);
    }
  }

  Future<void> toggle(String listingId) async {
    final user = ref.read(authStateChangesProvider).valueOrNull;
    if (user == null) return;

    final repository = ref.read(favoriteRepositoryProvider);
    final wasFavorite = state.contains(listingId);

    if (wasFavorite) {
      state = Set<String>.from(state)..remove(listingId);
      try {
        await repository.removeFavorite(userId: user.id, listingId: listingId);
      } catch (_) {
        state = Set<String>.from(state)..add(listingId);
      }
    } else {
      state = Set<String>.from(state)..add(listingId);
      try {
        await repository.addFavorite(userId: user.id, listingId: listingId);
      } catch (_) {
        state = Set<String>.from(state)..remove(listingId);
      }
    }
  }

  bool isFavorite(String listingId) => state.contains(listingId);
}

final favoriteIdsProvider =
    NotifierProvider<FavoritesNotifier, Set<String>>(FavoritesNotifier.new);

final favoritesCountProvider = Provider<int>((ref) {
  return ref.watch(favoriteIdsProvider).length;
});
