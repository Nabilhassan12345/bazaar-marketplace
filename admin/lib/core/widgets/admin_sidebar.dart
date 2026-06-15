import 'package:admin/config/theme/admin_theme.dart';
import 'package:flutter/material.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.extended,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool extended;

  static const destinations = <(IconData, String)>[
    (Icons.dashboard_outlined, 'Dashboard'),
    (Icons.inventory_2_outlined, 'Listings'),
    (Icons.people_outline, 'Users'),
    (Icons.flag_outlined, 'Reports'),
  ];

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      extended: extended,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelType: extended ? NavigationRailLabelType.none : NavigationRailLabelType.all,
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: extended
            ? const Text(
                'Bazaar Admin',
                style: TextStyle(
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
