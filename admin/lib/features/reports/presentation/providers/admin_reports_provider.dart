import 'package:admin/features/reports/data/admin_reports_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

final adminReportsDataSourceProvider = Provider<AdminReportsDataSource>((ref) {
  return AdminReportsDataSource();
});

final adminReportsProvider =
    FutureProvider.autoDispose<List<ReportModel>>((ref) async {
  return ref.watch(adminReportsDataSourceProvider).fetchReports();
});

class AdminReportsController {
  AdminReportsController(this._dataSource, this._ref);

  final AdminReportsDataSource _dataSource;
  final Ref _ref;

  Future<void> resolveReport(String reportId) async {
    await _dataSource.updateStatus(
      reportId: reportId,
      status: ReportStatus.resolved,
    );
    _ref.invalidate(adminReportsProvider);
  }

  Future<void> dismissReport(String reportId) async {
    await _dataSource.updateStatus(
      reportId: reportId,
      status: ReportStatus.dismissed,
    );
    _ref.invalidate(adminReportsProvider);
  }
}

final adminReportsControllerProvider = Provider<AdminReportsController>((ref) {
  return AdminReportsController(
    ref.watch(adminReportsDataSourceProvider),
    ref,
  );
});
