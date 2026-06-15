import 'package:bazaar/config/theme/app_colors.dart';
import 'package:bazaar/core/l10n/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryListPage extends ConsumerWidget {
  const CategoryListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.str;

    return Scaffold(
      appBar: AppBar(title: Text(s.categories)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _CategoryTile(
            icon: Icons.directions_car,
            label: s.categoryCars,
          ),
          _CategoryTile(
            icon: Icons.home_work_outlined,
            label: s.categoryHouses,
          ),
          _CategoryTile(
            icon: Icons.shopping_bag_outlined,
            label: s.categorySecondHand,
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(label),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
