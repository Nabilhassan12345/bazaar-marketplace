import 'package:bazaar/config/routes/route_names.dart';
import 'package:bazaar/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  static const _items = [
    _NavItem(
      route: RouteNames.home,
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
    ),
    _NavItem(
      route: RouteNames.search,
      icon: Icons.search_outlined,
      activeIcon: Icons.search,
      label: 'Search',
    ),
    _NavItem(
      route: RouteNames.post,
      icon: Icons.add_circle_outline,
      activeIcon: Icons.add_circle,
      label: 'Post',
    ),
    _NavItem(
      route: RouteNames.favorites,
      icon: Icons.favorite_outline,
      activeIcon: Icons.favorite,
      label: 'Favorites',
    ),
    _NavItem(
      route: RouteNames.profile,
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  int _selectedIndex(String location) {
    for (var i = 0; i < _items.length; i++) {
      if (location.startsWith(_items[i].route)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final selectedIndex = _selectedIndex(location);

    return NavigationBar(
      selectedIndex: selectedIndex,
      elevation: 8,
      shadowColor: Colors.black26,
      backgroundColor: AppColors.navBarBackground,
      indicatorColor: AppColors.primary.withValues(alpha: 0.15),
      onDestinationSelected: (index) => context.go(_items[index].route),
      destinations: [
        for (final item in _items)
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
