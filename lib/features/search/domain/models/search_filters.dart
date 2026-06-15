import 'package:marketplace_shared/marketplace_shared.dart';

enum SearchSortOption {
  newest,
  priceLowToHigh,
  priceHighToLow;

  String localizedLabel(BazaarStrings strings) => switch (this) {
        SearchSortOption.newest => strings.sortNewest,
        SearchSortOption.priceLowToHigh => strings.sortPriceLowToHigh,
        SearchSortOption.priceHighToLow => strings.sortPriceHighToLow,
      };

  @Deprecated('Use localizedLabel')
  String get label => switch (this) {
        SearchSortOption.newest => 'Newest first',
        SearchSortOption.priceLowToHigh => 'Price: low to high',
        SearchSortOption.priceHighToLow => 'Price: high to low',
      };
}

class SearchFilters {
  const SearchFilters({
    this.category,
    this.city,
    this.minPrice,
    this.maxPrice,
    this.sort = SearchSortOption.newest,
  });

  static const empty = SearchFilters();

  final ListingCategory? category;
  final String? city;
  final double? minPrice;
  final double? maxPrice;
  final SearchSortOption sort;

  bool get hasPriceRange => minPrice != null || maxPrice != null;

  int get activeCount {
    var count = 0;
    if (category != null) count++;
    if (city != null) count++;
    if (minPrice != null) count++;
    if (maxPrice != null) count++;
    if (sort != SearchSortOption.newest) count++;
    return count;
  }

  List<ActiveSearchFilter> localizedActiveFilters(
    BazaarStrings strings,
    String languageCode,
  ) {
    final filters = <ActiveSearchFilter>[];
    if (category != null) {
      filters.add(
        ActiveSearchFilter(
          id: 'category',
          label: category!.localizedLabel(strings),
        ),
      );
    }
    if (city != null) {
      filters.add(
        ActiveSearchFilter(
          id: 'city',
          label: MarketGeography.localityLabel(city, languageCode),
        ),
      );
    }
    if (minPrice != null) {
      filters.add(
        ActiveSearchFilter(
          id: 'minPrice',
          label: strings.minPriceChip(minPrice!),
        ),
      );
    }
    if (maxPrice != null) {
      filters.add(
        ActiveSearchFilter(
          id: 'maxPrice',
          label: strings.maxPriceChip(maxPrice!),
        ),
      );
    }
    if (sort != SearchSortOption.newest) {
      filters.add(
        ActiveSearchFilter(
          id: 'sort',
          label: sort.localizedLabel(strings),
        ),
      );
    }
    return filters;
  }

  @Deprecated('Use localizedActiveFilters')
  List<ActiveSearchFilter> get activeFilters {
    final filters = <ActiveSearchFilter>[];
    if (category != null) {
      filters.add(
        ActiveSearchFilter(
          id: 'category',
          label: category!.label,
        ),
      );
    }
    if (city != null) {
      filters.add(ActiveSearchFilter(id: 'city', label: city!));
    }
    if (minPrice != null) {
      filters.add(
        ActiveSearchFilter(
          id: 'minPrice',
          label: 'Min \$${minPrice!.toStringAsFixed(0)}',
        ),
      );
    }
    if (maxPrice != null) {
      filters.add(
        ActiveSearchFilter(
          id: 'maxPrice',
          label: 'Max \$${maxPrice!.toStringAsFixed(0)}',
        ),
      );
    }
    if (sort != SearchSortOption.newest) {
      filters.add(ActiveSearchFilter(id: 'sort', label: sort.label));
    }
    return filters;
  }

  SearchFilters copyWith({
    ListingCategory? category,
    bool clearCategory = false,
    String? city,
    bool clearCity = false,
    double? minPrice,
    bool clearMinPrice = false,
    double? maxPrice,
    bool clearMaxPrice = false,
    SearchSortOption? sort,
  }) {
    return SearchFilters(
      category: clearCategory ? null : (category ?? this.category),
      city: clearCity ? null : (city ?? this.city),
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      sort: sort ?? this.sort,
    );
  }

  SearchFilters removeFilter(String filterId) {
    return switch (filterId) {
      'category' => copyWith(clearCategory: true),
      'city' => copyWith(clearCity: true),
      'minPrice' => copyWith(clearMinPrice: true),
      'maxPrice' => copyWith(clearMaxPrice: true),
      'sort' => copyWith(sort: SearchSortOption.newest),
      _ => this,
    };
  }
}

class ActiveSearchFilter {
  const ActiveSearchFilter({required this.id, required this.label});

  final String id;
  final String label;
}
