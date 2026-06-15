import 'package:bazaar/features/favorites/data/datasources/favorite_remote_datasource.dart';
import 'package:bazaar/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  const FavoriteRepositoryImpl(this._remote);

  final FavoriteRemoteDataSource _remote;

  @override
  Future<Set<String>> getFavoriteIds(String userId) =>
      _remote.getFavoriteIds(userId);

  @override
  Future<FavoriteListingIdsPage> getFavoriteListingIds({
    required String userId,
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
  }) async {
    final page = await _remote.getFavoriteListingIds(
      userId: userId,
      startAfter: startAfter,
    );
    return FavoriteListingIdsPage(
      listingIds: page.listingIds,
      lastDocument: page.lastDocument,
      hasMore: page.hasMore,
    );
  }

  @override
  Future<void> addFavorite({
    required String userId,
    required String listingId,
  }) =>
      _remote.addFavorite(userId: userId, listingId: listingId);

  @override
  Future<void> removeFavorite({
    required String userId,
    required String listingId,
  }) =>
      _remote.removeFavorite(userId: userId, listingId: listingId);
}
