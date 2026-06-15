import 'package:marketplace_shared/l10n/bazaar_strings.dart';

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

  String localizedLabel(BazaarStrings strings) => switch (this) {
        ListingCategory.cars => strings.categoryCars,
        ListingCategory.houses => strings.categoryHouses,
        ListingCategory.secondhand => strings.categorySecondHand,
      };

  static ListingCategory fromValue(String value) => switch (value) {
        'cars' => ListingCategory.cars,
        'houses' => ListingCategory.houses,
        'secondhand' => ListingCategory.secondhand,
        _ => ListingCategory.secondhand,
      };
}
