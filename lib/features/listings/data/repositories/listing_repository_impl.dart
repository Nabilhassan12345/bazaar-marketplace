import 'package:bazaar/features/listings/data/datasources/listing_remote_datasource.dart';
import 'package:bazaar/features/listings/data/datasources/listing_storage_datasource.dart';
import 'package:bazaar/features/listings/data/models/approved_listings_page.dart';
import 'package:bazaar/features/listings/domain/entities/listing_entity.dart';
import 'package:bazaar/features/listings/domain/repositories/listing_repository.dart';
import 'package:bazaar/features/search/domain/models/search_filters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

class ListingRepositoryImpl implements ListingRepository {
  const ListingRepositoryImpl(this._remote, this._storage);

  final ListingRemoteDataSource _remote;
  final ListingStorageDataSource _storage;

  @override
  Future<ListingEntity> createAndSubmitListing(ListingModel listing) async {
    await _remote.createDraft(listing);
    await _remote.submitForReview(listing.id);
    return ListingEntity.fromModel(
      listing.copyWith(status: ListingStatus.pendingReview),
    );
  }

  @override
  Future<List<ListingEntity>> getMyListings(String ownerId) async {
    final listings = await _remote.getMyListings(ownerId);
    return listings.map(ListingEntity.fromModel).toList();
  }

  @override
  Future<ApprovedListingsPageResult> getApprovedListingsBySeller(
    String sellerId,
  ) async {
    final page = await _remote.getApprovedListingsBySeller(sellerId);
    return _mapPage(page);
  }

  @override
  Future<ApprovedListingsPageResult> getApprovedListings({
    ListingCategory? category,
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
  }) async {
    final page = await _remote.getApprovedListings(
      category: category,
      startAfter: startAfter,
    );
    return _mapPage(page);
  }

  @override
  Future<ListingEntity?> getListingById(String listingId) async {
    final listing = await _remote.getListingById(listingId);
    return listing == null ? null : ListingEntity.fromModel(listing);
  }

  @override
  Future<List<ListingEntity>> getListingsByIds(List<String> ids) async {
    final listings = await _remote.getListingsByIds(ids);
    return listings.map(ListingEntity.fromModel).toList();
  }

  @override
  Future<void> incrementViewCount(String listingId) =>
      _remote.incrementViewCount(listingId);

  @override
  Future<void> updateListing(ListingModel listing) =>
      _remote.updateListing(listing);

  @override
  Future<void> syncOwnerFieldsOnListings({
    required String ownerId,
    required String ownerName,
    String? ownerPhoto,
  }) =>
      _remote.syncOwnerFieldsOnListings(
        ownerId: ownerId,
        ownerName: ownerName,
        ownerPhoto: ownerPhoto,
      );

  @override
  Future<void> deleteListing({
    required String listingId,
    required ListingStatus status,
  }) async {
    if (status == ListingStatus.draft) {
      await _remote.deleteDraftListing(listingId);
    } else {
      await _remote.softDeleteListing(listingId);
    }
  }

  @override
  Future<ApprovedListingsPageResult> searchListings({
    required String keyword,
    required List<String> queryTokens,
    SearchFilters filters = SearchFilters.empty,
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
  }) async {
    final page = await _remote.searchListings(
      keyword: keyword,
      filters: filters,
      startAfter: startAfter,
    );

    final filtered = page.listings
        .where(
          (listing) => listingMatchesQueryTokens(
            title: listing.title,
            description: listing.description,
            queryTokens: queryTokens,
          ),
        )
        .map(ListingEntity.fromModel)
        .toList();

    return ApprovedListingsPageResult(
      listings: filtered,
      lastDocument: page.lastDocument,
      hasMore: page.hasMore,
    );
  }

  @override
  Stream<double> uploadListingImage({
    required String listingId,
    required int index,
    required List<int> imageBytes,
  }) {
    return _storage.uploadListingImage(
      listingId: listingId,
      index: index,
      imageBytes: imageBytes,
    );
  }

  @override
  Future<String> getImageDownloadUrl({
    required String listingId,
    required int index,
  }) {
    return _storage.getDownloadUrl(listingId: listingId, index: index);
  }

  ApprovedListingsPageResult _mapPage(ApprovedListingsPage page) {
    return ApprovedListingsPageResult(
      listings: page.listings.map(ListingEntity.fromModel).toList(),
      lastDocument: page.lastDocument,
      hasMore: page.hasMore,
    );
  }
}
