import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

class DashboardStats {
  const DashboardStats({
    required this.totalUsers,
    required this.totalListings,
    required this.pendingListings,
    required this.approvedListings,
    required this.rejectedListings,
    required this.openReports,
  });

  final int totalUsers;
  final int totalListings;
  final int pendingListings;
  final int approvedListings;
  final int rejectedListings;
  final int openReports;
}

class AdminStatsDataSource {
  AdminStatsDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<DashboardStats> fetchStats() async {
    final usersCount = await _count(CollectionNames.users);
    final pending = await _countListings(ListingStatus.pendingReview.value);
    final approved = await _countListings(ListingStatus.approved.value);
    final rejected = await _countListings(ListingStatus.rejected.value);
    final openReports = await _countReports('open');

    return DashboardStats(
      totalUsers: usersCount,
      totalListings: pending + approved + rejected,
      pendingListings: pending,
      approvedListings: approved,
      rejectedListings: rejected,
      openReports: openReports,
    );
  }

  Future<int> _count(String collection) async {
    final snapshot = await _firestore.collection(collection).count().get();
    return snapshot.count ?? 0;
  }

  Future<int> _countListings(String status) async {
    final snapshot = await _firestore
        .collection(CollectionNames.listings)
        .where('status', isEqualTo: status)
        .count()
        .get();
    return snapshot.count ?? 0;
  }

  Future<int> _countReports(String status) async {
    final snapshot = await _firestore
        .collection(CollectionNames.reports)
        .where('status', isEqualTo: status)
        .count()
        .get();
    return snapshot.count ?? 0;
  }
}
