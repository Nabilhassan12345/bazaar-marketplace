import 'package:bazaar/core/l10n/locale_provider.dart';
import 'package:bazaar/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

class CategoryChips extends ConsumerWidget {
  const CategoryChips({
    required this.selectedCategory,
    required this.onCategorySelected,
    super.key,
  });

  final ListingCategory? selectedCategory;
  final ValueChanged<ListingCategory?> onCategorySelected;

  static const _tabs = <ListingCategory?>[
    null,
    ListingCategory.cars,
    ListingCategory.houses,
    ListingCategory.secondhand,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.str;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = _tabs[index];
          final label = category == null
              ? s.all
              : category.localizedLabel(s);
          final isSelected = selectedCategory == category;

          return ChoiceChip(
            label: Text(label),
            selected: isSelected,
            onSelected: (_) => onCategorySelected(category),
            selectedColor: AppColors.primary,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
            backgroundColor: Colors.grey.shade100,
            side: BorderSide(
              color: isSelected ? AppColors.primary : Colors.grey.shade300,
            ),
          );
        },
      ),
    );
  }
}
