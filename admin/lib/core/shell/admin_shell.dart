import 'package:admin/core/widgets/admin_sidebar.dart';
import 'package:admin/features/auth/presentation/providers/admin_auth_providers.dart';
import 'package:admin/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:admin/features/listings/presentation/pages/listings_management_page.dart';
import 'package:admin/features/reports/presentation/pages/reports_page.dart';
import 'package:admin/features/users/presentation/pages/users_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminShell extends ConsumerStatefulWidget {
  const AdminShell({super.key});

  @override
  ConsumerState<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends ConsumerState<AdminShell> {
  var _selectedIndex = 0;

  static const _pages = <Widget>[
    DashboardPage(),
    ListingsManagementPage(),
    UsersPage(),
    ReportsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final extended = constraints.maxWidth >= 900;

        return Scaffold(
          appBar: AppBar(
            title: Text(AdminSidebar.destinations[_selectedIndex].$2),
            actions: [
              IconButton(
                tooltip: 'Sign out',
                icon: const Icon(Icons.logout),
                onPressed: () =>
                    ref.read(adminAuthControllerProvider).signOut(),
              ),
            ],
          ),
          body: Row(
            children: [
              AdminSidebar(
                selectedIndex: _selectedIndex,
                extended: extended,
                onDestinationSelected: (index) {
                  setState(() => _selectedIndex = index);
                },
              ),
              const VerticalDivider(width: 1),
              Expanded(child: _pages[_selectedIndex]),
            ],
          ),
        );
      },
    );
  }
}
