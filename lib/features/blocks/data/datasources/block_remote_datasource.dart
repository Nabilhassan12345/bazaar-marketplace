import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

class BlockRemoteDataSource {
  BlockRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _blockedCollection(String userId) =>
      _firestore
          .collection(CollectionNames.blocks)
          .doc(userId)
          .collection('blocked');

  Future<Set<String>> getBlockedUserIds(String userId) async {
    final snapshot = await _blockedCollection(userId).get();
    return snapshot.docs.map((doc) => doc.id).toSet();
  }

  Future<List<BlockModel>> getBlockedUsers(String userId) async {
    final snapshot = await _blockedCollection(userId)
        .orderBy('blockedAt', descending: true)
        .get();
    return snapshot.docs.map(BlockModel.fromFirestore).toList();
  }

  Future<void> blockUser({
    required String currentUserId,
    required String blockedUserId,
    String? blockedDisplayName,
  }) async {
    final block = BlockModel(
      blockedUserId: blockedUserId,
      blockedAt: DateTime.now(),
      blockedDisplayName: blockedDisplayName,
    );

    await _blockedCollection(currentUserId)
        .doc(blockedUserId)
        .set(block.toFirestore());
  }

  Future<void> unblockUser({
    required String currentUserId,
    required String blockedUserId,
  }) async {
    await _blockedCollection(currentUserId).doc(blockedUserId).delete();
  }
}
