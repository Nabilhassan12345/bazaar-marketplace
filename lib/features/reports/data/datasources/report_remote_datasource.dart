import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

class ReportRemoteDataSource {
  ReportRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _reports =>
      _firestore.collection(CollectionNames.reports);

  Future<bool> hasListingReport({
    required String reporterId,
    required String listingId,
  }) async {
    final doc = await _reports
        .doc(ReportModel.listingReportId(
          reporterId: reporterId,
          listingId: listingId,
        ))
        .get();
    return doc.exists;
  }

  Future<bool> hasUserReport({
    required String reporterId,
    required String reportedUserId,
  }) async {
    final doc = await _reports
        .doc(ReportModel.userReportId(
          reporterId: reporterId,
          reportedUserId: reportedUserId,
        ))
        .get();
    return doc.exists;
  }

  Future<void> submitListingReport({
    required String reporterId,
    required String listingId,
    required ReportReason reason,
    String? details,
  }) async {
    final report = ReportModel(
      id: ReportModel.listingReportId(
        reporterId: reporterId,
        listingId: listingId,
      ),
      type: ReportSubjectType.listing,
      reporterId: reporterId,
      listingId: listingId,
      reason: reason,
      details: details,
      status: ReportStatus.open,
      createdAt: DateTime.now(),
    );

    await _reports.doc(report.id).set(report.toFirestore());
  }

  Future<void> submitUserReport({
    required String reporterId,
    required String reportedUserId,
    required ReportReason reason,
    String? details,
  }) async {
    final report = ReportModel(
      id: ReportModel.userReportId(
        reporterId: reporterId,
        reportedUserId: reportedUserId,
      ),
      type: ReportSubjectType.user,
      reporterId: reporterId,
      reportedUserId: reportedUserId,
      reason: reason,
      details: details,
      status: ReportStatus.open,
      createdAt: DateTime.now(),
    );

    await _reports.doc(report.id).set(report.toFirestore());
  }
}
