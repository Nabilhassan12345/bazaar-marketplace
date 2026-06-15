import 'package:marketplace_shared/marketplace_shared.dart';

abstract class BlockRepository {
  Future<Set<String>> getBlockedUserIds(String userId);

  Future<List<BlockModel>> getBlockedUsers(String userId);

  Future<void> blockUser({
    required String currentUserId,
    required String blockedUserId,
    String? blockedDisplayName,
  });

  Future<void> unblockUser({
    required String currentUserId,
    required String blockedUserId,
  });
}
