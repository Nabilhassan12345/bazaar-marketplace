import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FavoriteRepository {
  Future<Set<String>> getFavoriteIds(String userId);

  Future<FavoriteListingIdsPage> getFavoriteListingIds({
    required String userId,
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
  });

  Future<void> addFavorite({
    required String userId,
    required String listingId,
  });

  Future<void> removeFavorite({
    required String userId,
    required String listingId,
  });
}

class FavoriteListingIdsPage {
  const FavoriteListingIdsPage({
    required this.listingIds,
    required this.lastDocument,
    required this.hasMore,
  });

  final List<String> listingIds;
  final DocumentSnapshot<Map<String, dynamic>>? lastDocument;
  final bool hasMore;
}
