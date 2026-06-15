import 'package:bazaar/features/blocks/presentation/providers/block_providers.dart';
import 'package:bazaar/features/listings/presentation/providers/home_feed_state.dart';
import 'package:bazaar/features/listings/presentation/providers/listing_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

class HomeFeedNotifier extends Notifier<HomeFeedState> {
  @override
  HomeFeedState build() {
    ref.listen(blockedUserIdsProvider, (previous, next) {
      final blocked = next.valueOrNull ?? {};
      if (state.listings.isEmpty) return;
      state = state.copyWith(
        listings: filterBlockedListings(state.listings, blocked),
      );
    });

    Future.microtask(loadInitial);
    return const HomeFeedState(isInitialLoading: true);
  }

  Set<String> get _blockedUserIds =>
      ref.read(blockedUserIdsProvider).valueOrNull ?? {};

  Future<void> loadInitial() async {
    state = state.copyWith(
      isInitialLoading: true,
      clearError: true,
      listings: [],
      clearLastDocument: true,
      hasMore: true,
    );

    try {
      final page = await ref.read(listingRepositoryProvider).getApprovedListings(
            category: state.selectedCategory,
          );
      state = state.copyWith(
        listings: filterBlockedListings(page.listings, _blockedUserIds),
        lastDocument: page.lastDocument,
        hasMore: page.hasMore,
        isInitialLoading: false,
      );
    } catch (error) {
      state = state.copyWith(
        isInitialLoading: false,
        errorMessage: 'Failed to load listings.',
      );
    }
  }

  Future<void> refresh() async {
    if (state.isRefreshing) return;

    state = state.copyWith(isRefreshing: true, clearError: true);

    try {
      final page = await ref.read(listingRepositoryProvider).getApprovedListings(
            category: state.selectedCategory,
          );
      state = state.copyWith(
        listings: filterBlockedListings(page.listings, _blockedUserIds),
        lastDocument: page.lastDocument,
        hasMore: page.hasMore,
        isRefreshing: false,
      );
    } catch (_) {
      state = state.copyWith(
        isRefreshing: false,
        errorMessage: 'Failed to refresh listings.',
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || state.isInitialLoading || !state.hasMore) {
      return;
    }

    state = state.copyWith(isLoadingMore: true, clearError: true);

    try {
      final page = await ref.read(listingRepositoryProvider).getApprovedListings(
            category: state.selectedCategory,
            startAfter: state.lastDocument,
          );
      state = state.copyWith(
        listings: [
          ...state.listings,
          ...filterBlockedListings(page.listings, _blockedUserIds),
        ],
        lastDocument: page.lastDocument,
        hasMore: page.hasMore,
        isLoadingMore: false,
      );
    } catch (_) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: 'Failed to load more listings.',
      );
    }
  }

  Future<void> setCategory(ListingCategory? category) async {
    if (state.selectedCategory == category) return;

    state = state.copyWith(
      selectedCategory: category,
      clearCategory: category == null,
      listings: [],
      clearLastDocument: true,
      hasMore: true,
      isInitialLoading: true,
      clearError: true,
    );

    try {
      final page = await ref.read(listingRepositoryProvider).getApprovedListings(
            category: category,
          );
      state = state.copyWith(
        listings: filterBlockedListings(page.listings, _blockedUserIds),
        lastDocument: page.lastDocument,
        hasMore: page.hasMore,
        isInitialLoading: false,
      );
    } catch (_) {
      state = state.copyWith(
        isInitialLoading: false,
        errorMessage: 'Failed to load listings.',
      );
    }
  }
}

final homeFeedProvider =
    NotifierProvider<HomeFeedNotifier, HomeFeedState>(HomeFeedNotifier.new);
