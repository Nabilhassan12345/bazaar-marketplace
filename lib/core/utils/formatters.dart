import 'package:intl/intl.dart';
import 'package:marketplace_shared/constants/market_geography.dart';
import 'package:marketplace_shared/l10n/app_language.dart';

abstract final class Formatters {
  static String formatPrice(double amount, {AppLanguage language = AppLanguage.fr}) {
    final hasCents = amount % 1 != 0;
    final locale = switch (language) {
      AppLanguage.fr => 'fr_FR',
      AppLanguage.ar => 'ar_SD',
      AppLanguage.en => 'en_US',
    };
    final symbol = switch (language) {
      AppLanguage.ar => 'ج.س',
      _ => 'FCFA',
    };
    return NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: hasCents ? 0 : 0,
    ).format(amount);
  }

  static String formatCityLabel(String? cityValue, String languageCode) {
    return MarketGeography.localityLabel(cityValue, languageCode);
  }

  static String formatFullLocation(
    String? localityId, {
    String languageCode = 'fr',
  }) {
    return MarketGeography.fullLocationLabel(
      localityId,
      languageCode: languageCode,
      includeDistrict: true,
      includeCountry: false,
    );
  }
}
