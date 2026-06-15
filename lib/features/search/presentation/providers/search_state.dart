import 'package:bazaar/features/listings/domain/entities/listing_entity.dart';
import 'package:bazaar/features/search/domain/models/search_filters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum SearchStatus {
  idle,
  loading,
  success,
  empty,
  error,
}

class SearchState {
  const SearchState({
    this.query = '',
    this.activeQuery = '',
    this.queryTokens = const [],
    this.filters = SearchFilters.empty,
    this.listings = const [],
    this.recentSearches = const [],
    this.lastDocument,
    this.status = SearchStatus.idle,
    this.isLoadingMore = false,
    this.hasMore = false,
  });

  final String query;
  final String activeQuery;
  final List<String> queryTokens;
  final SearchFilters filters;
  final List<ListingEntity> listings;
  final List<String> recentSearches;
  final DocumentSnapshot<Map<String, dynamic>>? lastDocument;
  final SearchStatus status;
  final bool isLoadingMore;
  final bool hasMore;

  bool get showRecentSearches =>
      query.trim().isEmpty && status != SearchStatus.loading;

  int get activeFilterCount => filters.activeCount;

  String get resultCountLabel {
    if (status != SearchStatus.success && status != SearchStatus.empty) {
      return '';
    }
    final count = listings.length;
    if (count == 0) return '0 results';
    if (hasMore) return '$count+ results';
    return count == 1 ? '1 result' : '$count results';
  }

  SearchState copyWith({
    String? query,
    String? activeQuery,
    List<String>? queryTokens,
    SearchFilters? filters,
    List<ListingEntity>? listings,
    List<String>? recentSearches,
    DocumentSnapshot<Map<String, dynamic>>? lastDocument,
    bool clearLastDocument = false,
    SearchStatus? status,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return SearchState(
      query: query ?? this.query,
      activeQuery: activeQuery ?? this.activeQuery,
      queryTokens: queryTokens ?? this.queryTokens,
      filters: filters ?? this.filters,
      listings: listings ?? this.listings,
      recentSearches: recentSearches ?? this.recentSearches,
      lastDocument:
          clearLastDocument ? null : (lastDocument ?? this.lastDocument),
      status: status ?? this.status,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
