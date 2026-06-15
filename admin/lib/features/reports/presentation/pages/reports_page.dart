import 'package:admin/core/l10n/admin_locale_provider.dart';
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
    final s = ref.str;
    final reportsAsync = ref.watch(adminReportsProvider);
    final controller = ref.read(adminReportsControllerProvider);

    return reportsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${s.failedToLoadReports}: $error'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => ref.invalidate(adminReportsProvider),
              child: Text(s.retry),
            ),
          ],
        ),
      ),
      data: (reports) {
        final openReports = reports
            .where((report) => report.status == ReportStatus.open)
            .toList();

        if (openReports.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.flag_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  s.noOpenReports,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
            columns: [
              DataColumn2(label: Text(s.type), size: ColumnSize.S),
              DataColumn2(label: Text(s.reportReason), size: ColumnSize.S),
              DataColumn2(label: Text(s.subject), size: ColumnSize.L),
              DataColumn2(label: Text(s.details), size: ColumnSize.L),
              DataColumn2(label: Text(s.date), size: ColumnSize.S),
              DataColumn2(label: Text(s.actions), size: ColumnSize.M),
            ],
            rows: openReports.map((report) {
              final subject = report.type == ReportSubjectType.listing
                  ? s.reportSubjectListing(report.listingId ?? '-')
                  : s.reportSubjectUser(report.reportedUserId ?? '-');

              return DataRow2(
                cells: [
                  DataCell(Text(s.reportSubjectTypeLabel(report.type.value))),
                  DataCell(Text(report.reason.localizedLabel(s))),
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
                          child: Text(s.resolve),
                        ),
                        TextButton(
                          onPressed: () =>
                              controller.dismissReport(report.id),
                          child: Text(s.dismiss),
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
