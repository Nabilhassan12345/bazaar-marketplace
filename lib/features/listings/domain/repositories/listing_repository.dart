import 'package:bazaar/features/listings/domain/entities/listing_entity.dart';
import 'package:bazaar/features/search/domain/models/search_filters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

abstract class ListingRepository {
  Future<ListingEntity> createAndSubmitListing(ListingModel listing);

  Future<List<ListingEntity>> getMyListings(String ownerId);

  Future<ApprovedListingsPageResult> getApprovedListingsBySeller(
    String sellerId,
  );

  Future<ApprovedListingsPageResult> getApprovedListings({
    ListingCategory? category,
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
  });

  Future<ListingEntity?> getListingById(String listingId);

  Future<List<ListingEntity>> getListingsByIds(List<String> ids);

  Future<void> incrementViewCount(String listingId);

  Future<void> updateListing(ListingModel listing);

  Future<void> syncOwnerFieldsOnListings({
    required String ownerId,
    required String ownerName,
    String? ownerPhoto,
  });

  Future<void> deleteListing({
    required String listingId,
    required ListingStatus status,
  });

  Future<ApprovedListingsPageResult> searchListings({
    required String keyword,
    required List<String> queryTokens,
    SearchFilters filters = SearchFilters.empty,
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
  });

  Stream<double> uploadListingImage({
    required String listingId,
    required int index,
    required List<int> imageBytes,
  });

  Future<String> getImageDownloadUrl({
    required String listingId,
    required int index,
  });
}

class ApprovedListingsPageResult {
  const ApprovedListingsPageResult({
    required this.listings,
    required this.lastDocument,
    required this.hasMore,
  });

  final List<ListingEntity> listings;
  final DocumentSnapshot<Map<String, dynamic>>? lastDocument;
  final bool hasMore;
}
