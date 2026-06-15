import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

class FavoriteItemsPage {
  const FavoriteItemsPage({
    required this.listingIds,
    required this.lastDocument,
    required this.hasMore,
  });

  final List<String> listingIds;
  final DocumentSnapshot<Map<String, dynamic>>? lastDocument;
  final bool hasMore;
}

class FavoriteRemoteDataSource {
  FavoriteRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _items(String userId) => _firestore
      .collection(CollectionNames.favorites)
      .doc(userId)
      .collection('items');

  Future<Set<String>> getFavoriteIds(String userId) async {
    final snapshot = await _items(userId).get();
    return snapshot.docs.map((doc) => doc.id).toSet();
  }

  Future<FavoriteItemsPage> getFavoriteListingIds({
    required String userId,
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
    int limit = 20,
  }) async {
    Query<Map<String, dynamic>> query =
        _items(userId).orderBy('addedAt', descending: true).limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final snapshot = await query.get();
    final listingIds = snapshot.docs
        .map((doc) => doc.data()['listingId'] as String? ?? doc.id)
        .toList();
    final lastDoc = snapshot.docs.isEmpty ? null : snapshot.docs.last;

    return FavoriteItemsPage(
      listingIds: listingIds,
      lastDocument: lastDoc,
      hasMore: snapshot.docs.length == limit,
    );
  }

  Future<void> addFavorite({
    required String userId,
    required String listingId,
  }) async {
    await _items(userId).doc(listingId).set({
      'listingId': listingId,
      'addedAt': Timestamp.now(),
    });
  }

  Future<void> removeFavorite({
    required String userId,
    required String listingId,
  }) async {
    await _items(userId).doc(listingId).delete();
  }
}
