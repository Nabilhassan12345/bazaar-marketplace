import 'package:bazaar/config/theme/app_colors.dart';
import 'package:bazaar/core/l10n/locale_provider.dart';
import 'package:bazaar/core/widgets/market_location_picker.dart';
import 'package:bazaar/features/search/domain/models/search_filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

class SearchFilterSheet extends ConsumerStatefulWidget {
  const SearchFilterSheet({
    required this.initialFilters,
    required this.onApply,
    required this.onClearAll,
    super.key,
  });

  final SearchFilters initialFilters;
  final ValueChanged<SearchFilters> onApply;
  final VoidCallback onClearAll;

  @override
  ConsumerState<SearchFilterSheet> createState() => _SearchFilterSheetState();
}

class _SearchFilterSheetState extends ConsumerState<SearchFilterSheet> {
  late ListingCategory? _category;
  late String? _city;
  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;
  late SearchSortOption _sort;

  @override
  void initState() {
    super.initState();
    _category = widget.initialFilters.category;
    _city = widget.initialFilters.city;
    _sort = widget.initialFilters.sort;
    _minPriceController = TextEditingController(
      text: widget.initialFilters.minPrice?.toStringAsFixed(0) ?? '',
    );
    _maxPriceController = TextEditingController(
      text: widget.initialFilters.maxPrice?.toStringAsFixed(0) ?? '',
    );
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  double? _parsePrice(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return double.tryParse(trimmed);
  }

  void _apply() {
    widget.onApply(
      SearchFilters(
        category: _category,
        city: _city,
        minPrice: _parsePrice(_minPriceController.text),
        maxPrice: _parsePrice(_maxPriceController.text),
        sort: _sort,
      ),
    );
    Navigator.pop(context);
  }

  void _clearAll() {
    widget.onClearAll();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.str;
    final languageCode = ref.watch(localeProvider).code;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              s.filters,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              s.category,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SegmentedButton<ListingCategory?>(
              segments: [
                ButtonSegment(value: null, label: Text(s.all)),
                ButtonSegment(
                  value: ListingCategory.cars,
                  label: Text(s.categoryCars),
                ),
                ButtonSegment(
                  value: ListingCategory.houses,
                  label: Text(s.categoryHouses),
                ),
                ButtonSegment(
                  value: ListingCategory.secondhand,
                  label: Text(s.categorySecondHand),
                ),
              ],
              selected: {_category},
              onSelectionChanged: (selection) {
                setState(() => _category = selection.first);
              },
            ),
            const SizedBox(height: 20),
            MarketLocalityFilterDropdown(
              value: _city,
              languageCode: languageCode,
              label: s.city,
              allowNull: true,
              nullLabel: s.allCities,
              onChanged: (value) => setState(() => _city = value),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minPriceController,
                    decoration: InputDecoration(
                      labelText: s.minPrice,
                      prefixText: 'FCFA ',
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _maxPriceController,
                    decoration: InputDecoration(
                      labelText: s.maxPrice,
                      prefixText: 'FCFA ',
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              s.sortBy,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            RadioGroup<SearchSortOption>(
              groupValue: _sort,
              onChanged: (value) {
                if (value != null) setState(() => _sort = value);
              },
              child: Column(
                children: [
                  for (final option in SearchSortOption.values)
                    RadioListTile<SearchSortOption>(
                      title: Text(option.localizedLabel(s)),
                      value: option,
                      contentPadding: EdgeInsets.zero,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _apply,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text(s.applyFilters),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _clearAll,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text(s.clearFilters),
            ),
          ],
        ),
      ),
    );
  }
}

void showSearchFilterSheet({
  required BuildContext context,
  required SearchFilters initialFilters,
  required ValueChanged<SearchFilters> onApply,
  required VoidCallback onClearAll,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => SearchFilterSheet(
      initialFilters: initialFilters,
      onApply: onApply,
      onClearAll: onClearAll,
    ),
  );
}
