import 'dart:async';

import 'package:bazaar/features/blocks/presentation/providers/block_providers.dart';
import 'package:bazaar/features/listings/presentation/providers/listing_providers.dart';
import 'package:bazaar/features/search/data/datasources/recent_searches_local_datasource.dart';
import 'package:bazaar/features/search/domain/models/search_filters.dart';
import 'package:bazaar/features/search/presentation/providers/search_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketplace_shared/marketplace_shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main.dart');
});

final recentSearchesLocalDataSourceProvider =
    Provider<RecentSearchesLocalDataSource>((ref) {
  return RecentSearchesLocalDataSource(ref.watch(sharedPreferencesProvider));
});

class SearchNotifier extends Notifier<SearchState> {
  Timer? _debounceTimer;

  @override
  SearchState build() {
    ref.onDispose(() => _debounceTimer?.cancel());
    ref.listen(blockedUserIdsProvider, (previous, next) {
      final blocked = next.valueOrNull ?? {};
      if (state.listings.isEmpty) return;
      state = state.copyWith(
        listings: filterBlockedListings(state.listings, blocked),
      );
    });
    Future.microtask(_loadRecentSearches);
    return const SearchState();
  }

  RecentSearchesLocalDataSource get _recentSearchesDataSource =>
      ref.read(recentSearchesLocalDataSourceProvider);

  Set<String> get _blockedUserIds =>
      ref.read(blockedUserIdsProvider).valueOrNull ?? {};

  void _loadRecentSearches() {
    final recent = _recentSearchesDataSource.getRecentSearches();
    state = state.copyWith(recentSearches: recent);
  }

  void setQuery(String value) {
    _debounceTimer?.cancel();
    state = state.copyWith(query: value);

    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      state = state.copyWith(
        activeQuery: '',
        queryTokens: [],
        listings: [],
        clearLastDocument: true,
        status: SearchStatus.idle,
        hasMore: false,
      );
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      _runSearch(trimmed);
    });
  }

  void clearQuery() {
    _debounceTimer?.cancel();
    state = state.copyWith(
      query: '',
      activeQuery: '',
      queryTokens: [],
      listings: [],
      clearLastDocument: true,
      status: SearchStatus.idle,
      hasMore: false,
    );
  }

  Future<void> searchFromChip(String query) async {
    _debounceTimer?.cancel();
    state = state.copyWith(query: query);
    await _runSearch(query);
  }

  Future<void> removeRecentSearch(String query) async {
    await _recentSearchesDataSource.removeSearch(query);
    _loadRecentSearches();
  }

  Future<void> applyFilters(SearchFilters filters) async {
    state = state.copyWith(filters: filters);
    final query = state.activeQuery;
    if (query.isNotEmpty) {
      await _runSearch(query);
    }
  }

  Future<void> clearFilters() async {
    state = state.copyWith(filters: SearchFilters.empty);
    final query = state.activeQuery;
    if (query.isNotEmpty) {
      await _runSearch(query);
    }
  }

  Future<void> removeFilter(String filterId) async {
    final updated = state.filters.removeFilter(filterId);
    await applyFilters(updated);
  }

  Future<void> retry() async {
    final query = state.activeQuery;
    if (query.isEmpty) return;
    await _runSearch(query);
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore ||
        state.status != SearchStatus.success ||
        !state.hasMore) {
      return;
    }

    final keyword = primarySearchToken(state.activeQuery);
    if (keyword == null) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final page = await ref.read(listingRepositoryProvider).searchListings(
            keyword: keyword,
            queryTokens: state.queryTokens,
            filters: state.filters,
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
      state = state.copyWith(isLoadingMore: false);
    }
  }

  Future<void> _runSearch(String query) async {
    final tokens = extractSearchQueryTokens(query);
    final keyword = primarySearchToken(query);

    if (keyword == null) {
      state = state.copyWith(
        activeQuery: query,
        queryTokens: tokens,
        listings: [],
        clearLastDocument: true,
        status: SearchStatus.empty,
        hasMore: false,
      );
      return;
    }

    state = state.copyWith(
      activeQuery: query,
      queryTokens: tokens,
      listings: [],
      clearLastDocument: true,
      status: SearchStatus.loading,
      hasMore: false,
    );

    try {
      final page = await ref.read(listingRepositoryProvider).searchListings(
            keyword: keyword,
            queryTokens: tokens,
            filters: state.filters,
          );

      await _recentSearchesDataSource.addSearch(query);
      _loadRecentSearches();

      final filtered = filterBlockedListings(page.listings, _blockedUserIds);

      state = state.copyWith(
        listings: filtered,
        lastDocument: page.lastDocument,
        hasMore: page.hasMore,
        status: filtered.isEmpty ? SearchStatus.empty : SearchStatus.success,
      );
    } catch (_) {
      state = state.copyWith(
        status: SearchStatus.error,
        listings: [],
        clearLastDocument: true,
        hasMore: false,
      );
    }
  }
}

final searchProvider = NotifierProvider<SearchNotifier, SearchState>(
  SearchNotifier.new,
);
