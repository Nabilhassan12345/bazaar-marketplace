import 'package:bazaar/features/blocks/data/datasources/block_remote_datasource.dart';
import 'package:bazaar/features/blocks/domain/repositories/block_repository.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

class BlockRepositoryImpl implements BlockRepository {
  const BlockRepositoryImpl(this._remote);

  final BlockRemoteDataSource _remote;

  @override
  Future<Set<String>> getBlockedUserIds(String userId) =>
      _remote.getBlockedUserIds(userId);

  @override
  Future<List<BlockModel>> getBlockedUsers(String userId) =>
      _remote.getBlockedUsers(userId);

  @override
  Future<void> blockUser({
    required String currentUserId,
    required String blockedUserId,
    String? blockedDisplayName,
  }) =>
      _remote.blockUser(
        currentUserId: currentUserId,
        blockedUserId: blockedUserId,
        blockedDisplayName: blockedDisplayName,
      );

  @override
  Future<void> unblockUser({
    required String currentUserId,
    required String blockedUserId,
  }) =>
      _remote.unblockUser(
        currentUserId: currentUserId,
        blockedUserId: blockedUserId,
      );
}
