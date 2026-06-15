import 'package:bazaar/features/listings/domain/entities/listing_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

class HomeFeedState {
  const HomeFeedState({
    this.selectedCategory,
    this.listings = const [],
    this.lastDocument,
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.hasMore = true,
    this.errorMessage,
  });

  final ListingCategory? selectedCategory;
  final List<ListingEntity> listings;
  final DocumentSnapshot<Map<String, dynamic>>? lastDocument;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final bool isRefreshing;
  final bool hasMore;
  final String? errorMessage;

  HomeFeedState copyWith({
    ListingCategory? selectedCategory,
    bool clearCategory = false,
    List<ListingEntity>? listings,
    DocumentSnapshot<Map<String, dynamic>>? lastDocument,
    bool clearLastDocument = false,
    bool? isInitialLoading,
    bool? isLoadingMore,
    bool? isRefreshing,
    bool? hasMore,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HomeFeedState(
      selectedCategory:
          clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      listings: listings ?? this.listings,
      lastDocument:
          clearLastDocument ? null : (lastDocument ?? this.lastDocument),
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
