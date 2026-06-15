import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

class AdminListingsDataSource {
  AdminListingsDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<List<ListingModel>> fetchAllListings() async {
    final snapshot = await _firestore
        .collection(CollectionNames.listings)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map(ListingModel.fromFirestore).toList();
  }

  Future<void> updateStatus({
    required String listingId,
    required ListingStatus status,
  }) async {
    final updates = <String, dynamic>{
      'status': status.value,
      'updatedAt': Timestamp.now(),
    };

    if (status == ListingStatus.approved) {
      updates['approvedAt'] = Timestamp.now();
    }
    if (status == ListingStatus.rejected) {
      updates['rejectedAt'] = Timestamp.now();
    }

    await _firestore.collection(CollectionNames.listings).doc(listingId).update(updates);
  }

  Future<void> deleteListing(String listingId) async {
    await _firestore.collection(CollectionNames.listings).doc(listingId).delete();
  }
}
