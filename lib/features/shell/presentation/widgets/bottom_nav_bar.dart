import 'package:bazaar/config/routes/route_names.dart';
import 'package:bazaar/config/theme/app_colors.dart';
import 'package:bazaar/core/l10n/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.str;
    final items = [
      _NavItem(
        route: RouteNames.home,
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: s.navHome,
      ),
      _NavItem(
        route: RouteNames.search,
        icon: Icons.search_outlined,
        activeIcon: Icons.search,
        label: s.navSearch,
      ),
      _NavItem(
        route: RouteNames.post,
        icon: Icons.add_circle_outline,
        activeIcon: Icons.add_circle,
        label: s.navPost,
      ),
      _NavItem(
        route: RouteNames.favorites,
        icon: Icons.favorite_outline,
        activeIcon: Icons.favorite,
        label: s.navFavorites,
      ),
      _NavItem(
        route: RouteNames.profile,
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: s.navProfile,
      ),
    ];

    final location = GoRouterState.of(context).matchedLocation;
    var selectedIndex = 0;
    for (var i = 0; i < items.length; i++) {
      if (location.startsWith(items[i].route)) {
        selectedIndex = i;
        break;
      }
    }

    return NavigationBar(
      selectedIndex: selectedIndex,
      elevation: 8,
      shadowColor: Colors.black26,
      backgroundColor: AppColors.navBarBackground,
      indicatorColor: AppColors.primary.withValues(alpha: 0.15),
      onDestinationSelected: (index) => context.go(items[index].route),
      destinations: [
        for (final item in items)
          NavigationDestination(
            icon: Icon(item.icon, color: AppColors.textSecondary),
            selectedIcon: Icon(item.activeIcon, color: AppColors.primary),
            label: item.label,
          ),
      ],
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.route,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final String route;
  final IconData icon;
  final IconData activeIcon;
  final String label;
}
