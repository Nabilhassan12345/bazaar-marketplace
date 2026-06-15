import 'package:admin/features/dashboard/presentation/providers/dashboard_stats_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);

    return statsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (stats) {
        final numberFormat = NumberFormat.decimalPattern();

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(dashboardStatsProvider);
            await ref.read(dashboardStatsProvider.future);
          },
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _StatCard(
                    title: 'Total Users',
                    value: numberFormat.format(stats.totalUsers),
                    icon: Icons.people_outline,
                    color: Colors.blue,
                  ),
                  _StatCard(
                    title: 'Total Listings',
                    value: numberFormat.format(stats.totalListings),
                    subtitle:
                        'Pending ${stats.pendingListings} · Approved ${stats.approvedListings} · Rejected ${stats.rejectedListings}',
                    icon: Icons.inventory_2_outlined,
                    color: Colors.indigo,
                  ),
                  _StatCard(
                    title: 'Pending Review',
                    value: numberFormat.format(stats.pendingListings),
                    icon: Icons.hourglass_top,
                    color: Colors.amber.shade800,
                    highlight: stats.pendingListings > 0
                        ? Colors.amber.shade50
                        : null,
                    borderColor: stats.pendingListings > 0
                        ? Colors.amber.shade700
                        : null,
                  ),
                  _StatCard(
                    title: 'Open Reports',
                    value: numberFormat.format(stats.openReports),
                    icon: Icons.flag_outlined,
                    color: Colors.red,
                    highlight:
                        stats.openReports > 0 ? Colors.red.shade50 : null,
                    borderColor:
                        stats.openReports > 0 ? Colors.red.shade700 : null,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.highlight,
    this.borderColor,
  });

  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final Color? highlight;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Card(
        color: highlight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: borderColor ?? Colors.grey.shade200,
            width: borderColor != null ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle!,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
