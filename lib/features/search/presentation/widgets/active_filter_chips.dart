import 'package:bazaar/config/theme/app_colors.dart';
import 'package:bazaar/features/search/domain/models/search_filters.dart';
import 'package:flutter/material.dart';

class ActiveFilterChips extends StatelessWidget {
  const ActiveFilterChips({
    required this.filters,
    required this.onRemove,
    super.key,
  });

  final List<ActiveSearchFilter> filters;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    if (filters.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          return InputChip(
            label: Text(filter.label),
            deleteIcon: const Icon(Icons.close, size: 16),
            onDeleted: () => onRemove(filter.id),
            backgroundColor: AppColors.primary.withValues(alpha: 0.08),
            side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
          );
        },
      ),
    );
  }
}
