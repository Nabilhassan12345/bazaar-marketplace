import 'package:admin/features/dashboard/data/admin_stats_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adminStatsDataSourceProvider = Provider<AdminStatsDataSource>((ref) {
  return AdminStatsDataSource();
});

final dashboardStatsProvider = StreamProvider<DashboardStats>((ref) async* {
  final dataSource = ref.watch(adminStatsDataSourceProvider);
  yield await dataSource.fetchStats();

  await for (final _ in Stream.periodic(const Duration(seconds: 20))) {
    yield await dataSource.fetchStats();
  }
});
