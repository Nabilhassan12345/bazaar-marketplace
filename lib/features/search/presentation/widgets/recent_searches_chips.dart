import 'package:bazaar/config/theme/app_colors.dart';
import 'package:bazaar/core/l10n/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentSearchesChips extends ConsumerWidget {
  const RecentSearchesChips({
    required this.searches,
    required this.onTap,
    required this.onRemove,
    super.key,
  });

  final List<String> searches;
  final ValueChanged<String> onTap;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (searches.isEmpty) {
      return const SizedBox.shrink();
    }

    final s = ref.str;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text(
            s.recentSearches,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final search in searches)
                InputChip(
                  label: Text(search),
                  onPressed: () => onTap(search),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => onRemove(search),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
