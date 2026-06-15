import 'package:bazaar/features/auth/presentation/providers/auth_providers.dart';
import 'package:bazaar/features/favorites/presentation/providers/favorite_providers.dart';
import 'package:bazaar/features/favorites/presentation/providers/favorites_feed_state.dart';
import 'package:bazaar/features/listings/domain/entities/listing_entity.dart';
import 'package:bazaar/features/listings/presentation/providers/listing_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesFeedNotifier extends Notifier<FavoritesFeedState> {
  @override
  FavoritesFeedState build() {
    ref.listen(favoriteIdsProvider, (_, __) {
      Future.microtask(loadInitial);
    });
    Future.microtask(loadInitial);
    return const FavoritesFeedState(isInitialLoading: true);
  }

  Future<void> loadInitial() async {
    final user = ref.read(authStateChangesProvider).valueOrNull;
    if (user == null) {
      state = const FavoritesFeedState();
      return;
    }

    state = state.copyWith(
      isInitialLoading: true,
      listings: [],
      clearLastDocument: true,
      hasMore: true,
      clearError: true,
    );

    try {
      final page = await ref.read(favoriteRepositoryProvider).getFavoriteListingIds(
            userId: user.id,
          );
      final listings = page.listingIds.isEmpty
          ? <ListingEntity>[]
          : await ref.read(listingRepositoryProvider).getListingsByIds(
                page.listingIds,
              );

      state = state.copyWith(
        listings: listings,
        lastDocument: page.lastDocument,
        hasMore: page.hasMore,
        isInitialLoading: false,
      );
    } catch (_) {
      state = state.copyWith(
        isInitialLoading: false,
        errorMessage: 'Failed to load favorites.',
      );
    }
  }

  Future<void> loadMore() async {
    final user = ref.read(authStateChangesProvider).valueOrNull;
    if (user == null ||
        state.isLoadingMore ||
        state.isInitialLoading ||
        !state.hasMore) {
      return;
    }

    state = state.copyWith(isLoadingMore: true, clearError: true);

    try {
      final page = await ref.read(favoriteRepositoryProvider).getFavoriteListingIds(
            userId: user.id,
            startAfter: state.lastDocument,
          );
      final listings = page.listingIds.isEmpty
          ? <ListingEntity>[]
          : await ref.read(listingRepositoryProvider).getListingsByIds(
                page.listingIds,
              );

      state = state.copyWith(
        listings: [...state.listings, ...listings],
        lastDocument: page.lastDocument,
        hasMore: page.hasMore,
        isLoadingMore: false,
      );
    } catch (_) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: 'Failed to load more favorites.',
      );
    }
  }
}

final favoritesFeedProvider =
    NotifierProvider<FavoritesFeedNotifier, FavoritesFeedState>(
  FavoritesFeedNotifier.new,
);
