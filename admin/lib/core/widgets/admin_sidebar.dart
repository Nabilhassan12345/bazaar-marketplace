import 'package:admin/core/l10n/admin_locale_provider.dart';
import 'package:admin/config/theme/admin_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminSidebar extends ConsumerWidget {
  const AdminSidebar({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.extended,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool extended;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.str;
    final destinations = <(IconData, String)>[
      (Icons.dashboard_outlined, s.navDashboard),
      (Icons.inventory_2_outlined, s.navListings),
      (Icons.people_outline, s.navUsers),
      (Icons.flag_outlined, s.navReports),
    ];

    return NavigationRail(
      extended: extended,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelType: extended ? NavigationRailLabelType.none : NavigationRailLabelType.all,
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: extended
            ? Text(
                s.adminTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AdminTheme.primary,
                ),
              )
            : const Icon(Icons.storefront, color: AdminTheme.primary),
      ),
      destinations: [
        for (final (icon, label) in destinations)
          NavigationRailDestination(
            icon: Icon(icon),
            selectedIcon: Icon(icon, color: AdminTheme.primary),
            label: Text(label),
          ),
      ],
    );
  }
}

List<String> adminDestinationLabels(WidgetRef ref) {
  final s = ref.str;
  return [s.navDashboard, s.navListings, s.navUsers, s.navReports];
}
