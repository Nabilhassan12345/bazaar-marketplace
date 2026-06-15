import 'package:bazaar/features/reports/data/datasources/report_remote_datasource.dart';
import 'package:bazaar/features/reports/domain/repositories/report_repository.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

class ReportRepositoryImpl implements ReportRepository {
  const ReportRepositoryImpl(this._remote);

  final ReportRemoteDataSource _remote;

  @override
  Future<bool> hasListingReport({
    required String reporterId,
    required String listingId,
  }) =>
      _remote.hasListingReport(reporterId: reporterId, listingId: listingId);

  @override
  Future<bool> hasUserReport({
    required String reporterId,
    required String reportedUserId,
  }) =>
      _remote.hasUserReport(
        reporterId: reporterId,
        reportedUserId: reportedUserId,
      );

  @override
  Future<void> submitListingReport({
    required String reporterId,
    required String listingId,
    required ReportReason reason,
    String? details,
  }) =>
      _remote.submitListingReport(
        reporterId: reporterId,
        listingId: listingId,
        reason: reason,
        details: details,
      );

  @override
  Future<void> submitUserReport({
    required String reporterId,
    required String reportedUserId,
    required ReportReason reason,
    String? details,
  }) =>
      _remote.submitUserReport(
        reporterId: reporterId,
        reportedUserId: reportedUserId,
        reason: reason,
        details: details,
      );
}
