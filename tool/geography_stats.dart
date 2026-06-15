// ignore_for_file: avoid_print
import 'package:marketplace_shared/constants/market_geography.dart';

void main() {
  final bfRegions = MarketGeography.regionsForCountry(MarketCountries.burkinaFaso);
  final ciRegions = MarketGeography.regionsForCountry(MarketCountries.coteDivoire);
  final sdRegions = MarketGeography.regionsForCountry(MarketCountries.sudan);

  final bfDistricts =
      MarketGeography.districts.where((d) => d.countryCode == MarketCountries.burkinaFaso);
  final ciDistricts =
      MarketGeography.districts.where((d) => d.countryCode == MarketCountries.coteDivoire);
  final sdDistricts =
      MarketGeography.districts.where((d) => d.countryCode == MarketCountries.sudan);

  final bfLocalities =
      MarketGeography.localities.where((l) => l.countryCode == MarketCountries.burkinaFaso);
  final ciLocalities =
      MarketGeography.localities.where((l) => l.countryCode == MarketCountries.coteDivoire);
  final sdLocalities =
      MarketGeography.localities.where((l) => l.countryCode == MarketCountries.sudan);

  print('Burkina Faso: ${bfRegions.length} regions, ${bfDistricts.length} provinces, ${bfLocalities.length} communes');
  print("Côte d'Ivoire: ${ciRegions.length} districts, ${ciDistricts.length} départements, ${ciLocalities.length} localities");
  print('Sudan: ${sdRegions.length} states, ${sdDistricts.length} districts, ${sdLocalities.length} localities');
  print('Total: ${MarketGeography.regions.length} regions, ${MarketGeography.districts.length} districts, ${MarketGeography.localities.length} localities');
}
