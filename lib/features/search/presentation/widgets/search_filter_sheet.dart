import 'package:bazaar/config/theme/app_colors.dart';
import 'package:bazaar/core/constants/us_cities.dart';
import 'package:bazaar/features/search/domain/models/search_filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

class SearchFilterSheet extends StatefulWidget {
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
  State<SearchFilterSheet> createState() => _SearchFilterSheetState();
}

class _SearchFilterSheetState extends State<SearchFilterSheet> {
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
            const Text(
              'Filters',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Category',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SegmentedButton<ListingCategory?>(
              segments: const [
                ButtonSegment(value: null, label: Text('All')),
                ButtonSegment(
                  value: ListingCategory.cars,
                  label: Text('Cars'),
                ),
                ButtonSegment(
                  value: ListingCategory.houses,
                  label: Text('Houses'),
                ),
                ButtonSegment(
                  value: ListingCategory.secondhand,
                  label: Text('2nd-hand'),
                ),
              ],
              selected: {_category},
              onSelectionChanged: (selection) {
                setState(() => _category = selection.first);
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String?>(
              key: ValueKey(_city),
              initialValue: _city,
              decoration: const InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('All cities'),
                ),
                ...UsCities.all.map(
                  (city) => DropdownMenuItem<String?>(
                    value: city,
                    child: Text(city),
                  ),
                ),
              ],
              onChanged: (value) => setState(() => _city = value),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Min price',
                      prefixText: '\$ ',
                      border: OutlineInputBorder(),
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
                    decoration: const InputDecoration(
                      labelText: 'Max price',
                      prefixText: '\$ ',
                      border: OutlineInputBorder(),
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
            const Text(
              'Sort by',
              style: TextStyle(fontWeight: FontWeight.w600),
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
                      title: Text(option.label),
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
              child: const Text('Apply Filters'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _clearAll,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Clear All'),
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
