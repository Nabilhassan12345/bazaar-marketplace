import 'package:bazaar/features/listings/domain/entities/listing_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesFeedState {
  const FavoritesFeedState({
    this.listings = const [],
    this.lastDocument,
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.errorMessage,
  });

  final List<ListingEntity> listings;
  final DocumentSnapshot<Map<String, dynamic>>? lastDocument;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? errorMessage;

  FavoritesFeedState copyWith({
    List<ListingEntity>? listings,
    DocumentSnapshot<Map<String, dynamic>>? lastDocument,
    bool clearLastDocument = false,
    bool? isInitialLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FavoritesFeedState(
      listings: listings ?? this.listings,
      lastDocument:
          clearLastDocument ? null : (lastDocument ?? this.lastDocument),
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
