import 'package:bazaar/features/auth/presentation/providers/auth_providers.dart';
import 'package:bazaar/features/blocks/data/datasources/block_remote_datasource.dart';
import 'package:bazaar/features/blocks/data/repositories/block_repository_impl.dart';
import 'package:bazaar/features/blocks/domain/repositories/block_repository.dart';
import 'package:bazaar/features/listings/domain/entities/listing_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

final blockRemoteDataSourceProvider = Provider<BlockRemoteDataSource>((ref) {
  return BlockRemoteDataSource();
});

final blockRepositoryProvider = Provider<BlockRepository>((ref) {
  return BlockRepositoryImpl(ref.watch(blockRemoteDataSourceProvider));
});

final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(authStateChangesProvider).valueOrNull?.id;
});

class BlockedUserIdsNotifier extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() async {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) return {};

    return ref.read(blockRepositoryProvider).getBlockedUserIds(userId);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await build());
  }

  Future<void> blockUser({
    required String blockedUserId,
    String? blockedDisplayName,
  }) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    await ref.read(blockRepositoryProvider).blockUser(
          currentUserId: userId,
          blockedUserId: blockedUserId,
          blockedDisplayName: blockedDisplayName,
        );
    await refresh();
  }

  Future<void> unblockUser(String blockedUserId) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    await ref.read(blockRepositoryProvider).unblockUser(
          currentUserId: userId,
          blockedUserId: blockedUserId,
        );
    await refresh();
  }
}

final blockedUserIdsProvider =
    AsyncNotifierProvider<BlockedUserIdsNotifier, Set<String>>(
  BlockedUserIdsNotifier.new,
);

final blockedUsersListProvider =
    FutureProvider.autoDispose<List<BlockModel>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return [];
  return ref.watch(blockRepositoryProvider).getBlockedUsers(userId);
});

List<ListingEntity> filterBlockedListings(
  List<ListingEntity> listings,
  Set<String> blockedUserIds,
) {
  if (blockedUserIds.isEmpty) return listings;
  return listings
      .where((listing) => !blockedUserIds.contains(listing.ownerId))
      .toList();
}
