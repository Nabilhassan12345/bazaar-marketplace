import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

class AdminUsersDataSource {
  AdminUsersDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<List<UserModel>> fetchAllUsers() async {
    final snapshot = await _firestore
        .collection(CollectionNames.users)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map(UserModel.fromFirestore).toList();
  }

  Future<void> setBanned({
    required String userId,
    required bool banned,
  }) async {
    await _firestore.collection(CollectionNames.users).doc(userId).update({
      'isBlocked': banned,
      'isBanned': banned,
      'blockedAt': banned ? Timestamp.now() : null,
      'updatedAt': Timestamp.now(),
    });
  }
}

bool userIsBanned(UserModel user) => user.isBlocked;
