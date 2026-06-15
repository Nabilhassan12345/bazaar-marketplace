import 'package:marketplace_shared/constants/geography/geography_burkina_faso.dart';
import 'package:marketplace_shared/constants/geography/geography_cote_divoire.dart';
import 'package:marketplace_shared/constants/geography/geography_sudan.dart';
import 'package:marketplace_shared/constants/localized_name.dart';
import 'package:marketplace_shared/l10n/app_language.dart';

/// Country codes served by Bazaar.
abstract final class MarketCountries {
  static const burkinaFaso = 'BF';
  static const coteDivoire = 'CI';
  static const sudan = 'SD';

  static const all = [burkinaFaso, coteDivoire, sudan];

  static String name(String countryCode, String languageCode) {
    return switch (countryCode) {
      burkinaFaso => const LocalizedName(
          en: 'Burkina Faso',
          fr: 'Burkina Faso',
          ar: 'بوركينا فاسو',
        ).forLanguage(languageCode),
      coteDivoire => const LocalizedName(
          en: "Côte d'Ivoire",
          fr: "Côte d'Ivoire",
          ar: 'ساحل العاج',
        ).forLanguage(languageCode),
      sudan => const LocalizedName(
          en: 'Sudan',
          fr: 'Soudan',
          ar: 'السودان',
        ).forLanguage(languageCode),
      _ => countryCode,
    };
  }
}

/// Top-level region (BF région, CI district, SD state).
class MarketRegion {
  const MarketRegion({
    required this.id,
    required this.countryCode,
    required this.names,
  });

  final String id;
  final String countryCode;
  final LocalizedName names;

  String label(String languageCode) => names.forLanguage(languageCode);
}

/// Mid-level district (BF province, CI département, SD locality group).
class MarketDistrict {
  const MarketDistrict({
    required this.id,
    required this.regionId,
    required this.countryCode,
    required this.names,
  });

  final String id;
  final String regionId;
  final String countryCode;
  final LocalizedName names;

  String label(String languageCode) => names.forLanguage(languageCode);
}

/// City, commune, or town — stored in Firestore `city` field as [id].
class MarketLocality {
  const MarketLocality({
    required this.id,
    required this.districtId,
    required this.regionId,
    required this.countryCode,
    required this.names,
    this.isCapital = false,
  });

  final String id;
  final String districtId;
  final String regionId;
  final String countryCode;
  final LocalizedName names;
  final bool isCapital;

  String label(String languageCode) => names.forLanguage(languageCode);

  /// Legacy display value (French name) for older listings.
  String get legacyCityValue => names.fr;
}

/// Full geographic registry for BF, CI, and Sudan.
abstract final class MarketGeography {
  static final List<MarketRegion> regions = [
    ...GeographyBurkinaFaso.regions,
    ...GeographyCoteDivoire.regions,
    ...GeographySudan.regions,
  ];

  static final List<MarketDistrict> districts = [
    ...GeographyBurkinaFaso.districts,
    ...GeographyCoteDivoire.districts,
    ...GeographySudan.districts,
  ];

  static final List<MarketLocality> localities = [
    ...GeographyBurkinaFaso.localities,
    ...GeographyCoteDivoire.localities,
    ...GeographySudan.localities,
  ];

  static List<MarketRegion> regionsForCountry(String countryCode) =>
      regions.where((r) => r.countryCode == countryCode).toList();

  static List<MarketDistrict> districtsForRegion(String regionId) =>
      districts.where((d) => d.regionId == regionId).toList();

  static List<MarketLocality> localitiesForDistrict(String districtId) =>
      localities.where((l) => l.districtId == districtId).toList();

  static MarketLocality? localityById(String? id) {
    if (id == null || id.isEmpty) return null;
    for (final loc in localities) {
      if (loc.id == id) return loc;
    }
    // Legacy: match by French/English display name from old listings.
    final lower = id.toLowerCase();
    for (final loc in localities) {
      if (loc.names.fr.toLowerCase() == lower ||
          loc.names.en.toLowerCase() == lower ||
          loc.legacyCityValue.toLowerCase() == lower) {
        return loc;
      }
    }
    return null;
  }

  static MarketDistrict? districtById(String? id) {
    if (id == null) return null;
    for (final d in districts) {
      if (d.id == id) return d;
    }
    return null;
  }

  static MarketRegion? regionById(String? id) {
    if (id == null) return null;
    for (final r in regions) {
      if (r.id == id) return r;
    }
    return null;
  }

  static String localityLabel(String? id, String languageCode) {
    return localityById(id)?.label(languageCode) ?? id ?? '';
  }

  static String fullLocationLabel(
    String? localityId, {
    String languageCode = 'fr',
    bool includeDistrict = true,
    bool includeRegion = false,
    bool includeCountry = false,
  }) {
    final loc = localityById(localityId);
    if (loc == null) return localityId ?? '';

    final parts = <String>[loc.label(languageCode)];
    if (includeDistrict) {
      final district = districtById(loc.districtId);
      if (district != null) parts.add(district.label(languageCode));
    }
    if (includeRegion) {
      final region = regionById(loc.regionId);
      if (region != null) parts.add(region.label(languageCode));
    }
    if (includeCountry) {
      parts.add(MarketCountries.name(loc.countryCode, languageCode));
    }
    return parts.join(', ');
  }

  /// Backward-compatible alias used by older code paths.
  static List<MarketLocality> get allLocalities => localities;
}

/// @deprecated Use [MarketGeography] and [MarketLocality].
class MarketCity {
  const MarketCity({
    required this.value,
    required this.countryCode,
    required this.en,
    required this.fr,
    required this.ar,
  });

  final String value;
  final String countryCode;
  final String en;
  final String fr;
  final String ar;

  factory MarketCity.fromLocality(MarketLocality loc) => MarketCity(
        value: loc.id,
        countryCode: loc.countryCode,
        en: loc.names.en,
        fr: loc.names.fr,
        ar: loc.names.ar,
      );

  String label(String languageCode) => switch (AppLanguage.fromCode(languageCode)) {
        AppLanguage.fr => fr,
        AppLanguage.ar => ar,
        AppLanguage.en => en,
      };
}

/// @deprecated Use [MarketGeography].
abstract final class MarketCities {
  static List<MarketCity> get all =>
      MarketGeography.localities.map(MarketCity.fromLocality).toList();

  static List<String> get values => all.map((c) => c.value).toList();

  static MarketCity? byValue(String? value) {
    final loc = MarketGeography.localityById(value);
    return loc == null ? null : MarketCity.fromLocality(loc);
  }

  static String labelFor(String? value, String languageCode) =>
      MarketGeography.localityLabel(value, languageCode);

  static List<MarketCity> forCountry(String countryCode) => MarketGeography
      .localities
      .where((l) => l.countryCode == countryCode)
      .map(MarketCity.fromLocality)
      .toList();
}
