import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketplace_shared/enums/report_reason.dart';
import 'package:marketplace_shared/enums/report_status.dart';
import 'package:marketplace_shared/enums/report_subject_type.dart';

class ReportModel {
  const ReportModel({
    required this.id,
    required this.type,
    required this.reporterId,
    required this.reason,
    required this.status,
    required this.createdAt,
    this.listingId,
    this.reportedUserId,
    this.details,
  });

  final String id;
  final ReportSubjectType type;
  final String reporterId;
  final String? listingId;
  final String? reportedUserId;
  final ReportReason reason;
  final String? details;
  final ReportStatus status;
  final DateTime createdAt;

  factory ReportModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return ReportModel.fromMap(doc.id, data);
  }

  factory ReportModel.fromMap(String id, Map<String, dynamic> data) {
    return ReportModel(
      id: id,
      type: ReportSubjectType.fromValue(data['type'] as String? ?? 'listing'),
      reporterId: data['reporterId'] as String? ?? '',
      listingId: data['listingId'] as String?,
      reportedUserId: data['reportedUserId'] as String?,
      reason: ReportReason.fromValue(data['reason'] as String? ?? 'other'),
      details: data['details'] as String?,
      status: ReportStatus.fromValue(data['status'] as String? ?? 'open'),
      createdAt: _toDateTime(data['createdAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'type': type.value,
      'reporterId': reporterId,
      if (listingId != null) 'listingId': listingId,
      if (reportedUserId != null) 'reportedUserId': reportedUserId,
      'reason': reason.value,
      if (details != null && details!.trim().isNotEmpty) 'details': details!.trim(),
      'status': status.value,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static String listingReportId({
    required String reporterId,
    required String listingId,
  }) =>
      '${reporterId}_listing_$listingId';

  static String userReportId({
    required String reporterId,
    required String reportedUserId,
  }) =>
      '${reporterId}_user_$reportedUserId';

  static DateTime? _toDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}
