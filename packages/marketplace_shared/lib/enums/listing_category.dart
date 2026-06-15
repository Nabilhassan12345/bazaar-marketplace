enum ListingCategory {
  cars,
  houses,
  secondhand;

  String get value => name;

  String get label => switch (this) {
        ListingCategory.cars => 'Cars',
        ListingCategory.houses => 'Houses',
        ListingCategory.secondhand => 'Second-hand',
      };

  static ListingCategory fromValue(String value) => switch (value) {
        'cars' => ListingCategory.cars,
        'houses' => ListingCategory.houses,
        'secondhand' => ListingCategory.secondhand,
        _ => ListingCategory.secondhand,
      };
}
