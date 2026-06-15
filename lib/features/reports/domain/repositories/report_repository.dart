import 'package:marketplace_shared/marketplace_shared.dart';

abstract class ReportRepository {
  Future<bool> hasListingReport({
    required String reporterId,
    required String listingId,
  });

  Future<bool> hasUserReport({
    required String reporterId,
    required String reportedUserId,
  });

  Future<void> submitListingReport({
    required String reporterId,
    required String listingId,
    required ReportReason reason,
    String? details,
  });

  Future<void> submitUserReport({
    required String reporterId,
    required String reportedUserId,
    required ReportReason reason,
    String? details,
  });
}
