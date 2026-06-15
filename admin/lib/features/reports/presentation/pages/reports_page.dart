import 'package:admin/features/reports/presentation/providers/admin_reports_provider.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(adminReportsProvider);
    final controller = ref.read(adminReportsControllerProvider);

    return reportsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Failed to load reports: $error'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => ref.invalidate(adminReportsProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (reports) {
        final openReports = reports
            .where((report) => report.status == ReportStatus.open)
            .toList();

        if (openReports.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.flag_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No open reports',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: DataTable2(
            columnSpacing: 12,
            horizontalMargin: 12,
            minWidth: 900,
            headingRowColor: WidgetStateProperty.all(Colors.grey.shade100),
            columns: const [
              DataColumn2(label: Text('Type'), size: ColumnSize.S),
              DataColumn2(label: Text('Reason'), size: ColumnSize.S),
              DataColumn2(label: Text('Subject'), size: ColumnSize.L),
              DataColumn2(label: Text('Details'), size: ColumnSize.L),
              DataColumn2(label: Text('Date'), size: ColumnSize.S),
              DataColumn2(label: Text('Actions'), size: ColumnSize.M),
            ],
            rows: openReports.map((report) {
              final subject = report.type == ReportSubjectType.listing
                  ? 'Listing ${report.listingId ?? '-'}'
                  : 'User ${report.reportedUserId ?? '-'}';

              return DataRow2(
                cells: [
                  DataCell(Text(report.type.value)),
                  DataCell(Text(report.reason.label)),
                  DataCell(
                    Text(
                      subject,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(
                    Text(
                      report.details ?? '-',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(
                    Text(DateFormat.yMMMd().format(report.createdAt)),
                  ),
                  DataCell(
                    Row(
                      children: [
                        TextButton(
                          onPressed: () =>
                              controller.resolveReport(report.id),
                          child: const Text('Resolve'),
                        ),
                        TextButton(
                          onPressed: () =>
                              controller.dismissReport(report.id),
                          child: const Text('Dismiss'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
