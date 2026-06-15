import 'package:bazaar/features/auth/presentation/providers/auth_providers.dart';
import 'package:bazaar/features/reports/data/datasources/report_remote_datasource.dart';
import 'package:bazaar/features/reports/data/repositories/report_repository_impl.dart';
import 'package:bazaar/features/reports/domain/repositories/report_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

final reportRemoteDataSourceProvider = Provider<ReportRemoteDataSource>((ref) {
  return ReportRemoteDataSource();
});

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepositoryImpl(ref.watch(reportRemoteDataSourceProvider));
});

class ReportController {
  ReportController(this._repository, this._reporterId);

  final ReportRepository _repository;
  final String? _reporterId;

  Future<ReportSubmitResult> submitListingReport({
    required String listingId,
    required ReportReason reason,
    String? details,
  }) async {
    final reporterId = _reporterId;
    if (reporterId == null) {
      return ReportSubmitResult.notSignedIn;
    }

    final alreadyReported = await _repository.hasListingReport(
      reporterId: reporterId,
      listingId: listingId,
    );
    if (alreadyReported) return ReportSubmitResult.alreadyReported;

    await _repository.submitListingReport(
      reporterId: reporterId,
      listingId: listingId,
      reason: reason,
      details: details,
    );
    return ReportSubmitResult.success;
  }

  Future<ReportSubmitResult> submitUserReport({
    required String reportedUserId,
    required ReportReason reason,
    String? details,
  }) async {
    final reporterId = _reporterId;
    if (reporterId == null) {
      return ReportSubmitResult.notSignedIn;
    }

    final alreadyReported = await _repository.hasUserReport(
      reporterId: reporterId,
      reportedUserId: reportedUserId,
    );
    if (alreadyReported) return ReportSubmitResult.alreadyReported;

    await _repository.submitUserReport(
      reporterId: reporterId,
      reportedUserId: reportedUserId,
      reason: reason,
      details: details,
    );
    return ReportSubmitResult.success;
  }
}

enum ReportSubmitResult {
  success,
  alreadyReported,
  notSignedIn,
}

final reportControllerProvider = Provider<ReportController>((ref) {
  final reporterId = ref.watch(authStateChangesProvider).valueOrNull?.id;
  return ReportController(ref.watch(reportRepositoryProvider), reporterId);
});
