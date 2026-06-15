import 'dart:math';

import 'package:bazaar/features/listings/data/models/approved_listings_page.dart';
import 'package:bazaar/features/search/domain/models/search_filters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

class ListingRemoteDataSource {
  ListingRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const _pageSize = 20;

  CollectionReference<Map<String, dynamic>> get _listings =>
      _firestore.collection(CollectionNames.listings);

  Future<void> createDraft(ListingModel listing) async {
    await _listings.doc(listing.id).set(
          listing.copyWith(status: ListingStatus.draft).toFirestore(),
        );
  }

  Future<void> submitForReview(String listingId) async {
    await _listings.doc(listingId).update({
      'status': ListingStatus.pendingReview.value,
      'updatedAt': Timestamp.now(),
      'submittedAt': Timestamp.now(),
    });
  }

  Future<List<ListingModel>> getMyListings(String ownerId) async {
    final snapshot = await _listings
        .where('sellerId', isEqualTo: ownerId)
        .where('isDeleted', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map(ListingModel.fromFirestore).toList();
  }

  Future<ApprovedListingsPage> getApprovedListingsBySeller(String sellerId) async {
    final snapshot = await _listings
        .where('sellerId', isEqualTo: sellerId)
        .where('status', isEqualTo: ListingStatus.approved.value)
        .where('isDeleted', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .limit(_pageSize)
        .get();

    final listings = snapshot.docs.map(ListingModel.fromFirestore).toList();
    return ApprovedListingsPage(
      listings: listings,
      lastDocument: null,
      hasMore: false,
    );
  }

  Future<ApprovedListingsPage> getApprovedListings({
    ListingCategory? category,
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
  }) async {
    Query<Map<String, dynamic>> query = _listings
        .where('status', isEqualTo: ListingStatus.approved.value)
        .where('isDeleted', isEqualTo: false);

    if (category != null) {
      query = query.where('category', isEqualTo: category.value);
    }

    query = query.orderBy('createdAt', descending: true).limit(_pageSize);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final snapshot = await query.get();
    final listings = snapshot.docs.map(ListingModel.fromFirestore).toList();
    final lastDoc = snapshot.docs.isEmpty ? null : snapshot.docs.last;

    return ApprovedListingsPage(
      listings: listings,
      lastDocument: lastDoc,
      hasMore: snapshot.docs.length == _pageSize,
    );
  }

  Future<ListingModel?> getListingById(String listingId) async {
    final doc = await _listings.doc(listingId).get();
    if (!doc.exists) return null;
    return ListingModel.fromFirestore(doc);
  }

  Future<List<ListingModel>> getListingsByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    final byId = <String, ListingModel>{};
    for (var i = 0; i < ids.length; i += 10) {
      final chunk = ids.sublist(i, min(i + 10, ids.length));
      final snapshot = await _listings
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      for (final doc in snapshot.docs) {
        byId[doc.id] = ListingModel.fromFirestore(doc);
      }
    }

    return [
      for (final id in ids)
        if (byId.containsKey(id)) byId[id]!,
    ];
  }

  Future<void> incrementViewCount(String listingId) async {
    await _listings.doc(listingId).update({
      'viewCount': FieldValue.increment(1),
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> updateListing(ListingModel listing) async {
    await _listings.doc(listing.id).update({
      'title': listing.title,
      'description': listing.description,
      'price': listing.price,
      'category': listing.category.value,
      'city': listing.city,
      'images': listing.images,
      'searchTokens': generateSearchTokens(
        title: listing.title,
        description: listing.description,
      ),
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> syncOwnerFieldsOnListings({
    required String ownerId,
    required String ownerName,
    String? ownerPhoto,
  }) async {
    final snapshot =
        await _listings.where('ownerId', isEqualTo: ownerId).get();
    if (snapshot.docs.isEmpty) return;

    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {
        'ownerName': ownerName,
        if (ownerPhoto != null) 'ownerPhoto': ownerPhoto,
        'updatedAt': Timestamp.now(),
      });
    }
    await batch.commit();
  }

  Future<void> softDeleteListing(String listingId) async {
    await _listings.doc(listingId).update({
      'isDeleted': true,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> deleteDraftListing(String listingId) async {
    await _listings.doc(listingId).delete();
  }

  Future<ApprovedListingsPage> searchListings({
    required String keyword,
    SearchFilters filters = SearchFilters.empty,
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
  }) async {
    Query<Map<String, dynamic>> query = _listings
        .where('searchTokens', arrayContains: keyword)
        .where('status', isEqualTo: ListingStatus.approved.value)
        .where('isDeleted', isEqualTo: false);

    if (filters.category != null) {
      query = query.where('category', isEqualTo: filters.category!.value);
    }
    if (filters.city != null) {
      query = query.where('city', isEqualTo: filters.city);
    }

    final hasPriceFilter = filters.hasPriceRange;
    if (filters.minPrice != null) {
      query = query.where('price', isGreaterThanOrEqualTo: filters.minPrice);
    }
    if (filters.maxPrice != null) {
      query = query.where('price', isLessThanOrEqualTo: filters.maxPrice);
    }

    switch (filters.sort) {
      case SearchSortOption.newest:
        if (hasPriceFilter) {
          query = query
              .orderBy('price')
              .orderBy('createdAt', descending: true);
        } else {
          query = query.orderBy('createdAt', descending: true);
        }
      case SearchSortOption.priceLowToHigh:
        query = query.orderBy('price');
      case SearchSortOption.priceHighToLow:
        query = query.orderBy('price', descending: true);
    }

    query = query.limit(_pageSize);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final snapshot = await query.get();
    final listings = snapshot.docs.map(ListingModel.fromFirestore).toList();
    final lastDoc = snapshot.docs.isEmpty ? null : snapshot.docs.last;

    return ApprovedListingsPage(
      listings: listings,
      lastDocument: lastDoc,
      hasMore: snapshot.docs.length == _pageSize,
    );
  }
}
