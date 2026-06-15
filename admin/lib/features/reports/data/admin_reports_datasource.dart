import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

class AdminReportsDataSource {
  AdminReportsDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<List<ReportModel>> fetchReports() async {
    final snapshot = await _firestore
        .collection(CollectionNames.reports)
        .orderBy('createdAt', descending: true)
        .limit(100)
        .get();
    return snapshot.docs.map(ReportModel.fromFirestore).toList();
  }

  Future<void> updateStatus({
    required String reportId,
    required ReportStatus status,
  }) async {
    await _firestore.collection(CollectionNames.reports).doc(reportId).update({
      'status': status.value,
    });
  }
}
