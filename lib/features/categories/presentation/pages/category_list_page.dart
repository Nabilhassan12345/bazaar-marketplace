import 'package:bazaar/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryListPage extends StatelessWidget {
  const CategoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _CategoryTile(icon: Icons.directions_car, label: 'Cars'),
          _CategoryTile(icon: Icons.home_work_outlined, label: 'Houses'),
          _CategoryTile(icon: Icons.shopping_bag_outlined, label: 'Second-hand'),
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
