import 'package:flutter/material.dart';
import 'package:marketplace_shared/constants/market_geography.dart';

/// Cascading location picker: Country → Region → District → City/Commune.
class MarketLocationPicker extends StatefulWidget {
  const MarketLocationPicker({
    required this.languageCode,
    required this.countryCode,
    required this.regionId,
    required this.districtId,
    required this.localityId,
    required this.onCountryChanged,
    required this.onRegionChanged,
    required this.onDistrictChanged,
    required this.onLocalityChanged,
    this.countryLabel,
    this.regionLabel,
    this.districtLabel,
    this.localityLabel,
    super.key,
  });

  final String languageCode;
  final String? countryCode;
  final String? regionId;
  final String? districtId;
  final String? localityId;
  final ValueChanged<String?> onCountryChanged;
  final ValueChanged<String?> onRegionChanged;
  final ValueChanged<String?> onDistrictChanged;
  final ValueChanged<String?> onLocalityChanged;
  final String? countryLabel;
  final String? regionLabel;
  final String? districtLabel;
  final String? localityLabel;

  @override
  State<MarketLocationPicker> createState() => _MarketLocationPickerState();
}

class _MarketLocationPickerState extends State<MarketLocationPicker> {
  @override
  Widget build(BuildContext context) {
    final regions = widget.countryCode == null
        ? <MarketRegion>[]
        : MarketGeography.regionsForCountry(widget.countryCode!);

    final districts = widget.regionId == null
        ? <MarketDistrict>[]
        : MarketGeography.districtsForRegion(widget.regionId!);

    final localities = widget.districtId == null
        ? <MarketLocality>[]
        : MarketGeography.localitiesForDistrict(widget.districtId!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String?>(
          key: ValueKey('country-${widget.countryCode}'),
          initialValue: widget.countryCode,
          decoration: InputDecoration(
            labelText: widget.countryLabel,
            border: const OutlineInputBorder(),
          ),
          isExpanded: true,
          items: [
            for (final code in MarketCountries.all)
              DropdownMenuItem(
                value: code,
                child: Text(MarketCountries.name(code, widget.languageCode)),
              ),
          ],
          onChanged: (value) {
            widget.onCountryChanged(value);
            widget.onRegionChanged(null);
            widget.onDistrictChanged(null);
            widget.onLocalityChanged(null);
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String?>(
          key: ValueKey('region-${widget.regionId}'),
          initialValue: widget.regionId,
          decoration: InputDecoration(
            labelText: widget.regionLabel,
            border: const OutlineInputBorder(),
          ),
          isExpanded: true,
          items: [
            for (final region in regions)
              DropdownMenuItem(
                value: region.id,
                child: Text(region.label(widget.languageCode)),
              ),
          ],
          onChanged: widget.countryCode == null
              ? null
              : (value) {
                  widget.onRegionChanged(value);
                  widget.onDistrictChanged(null);
                  widget.onLocalityChanged(null);
                },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String?>(
          key: ValueKey('district-${widget.districtId}'),
          initialValue: widget.districtId,
          decoration: InputDecoration(
            labelText: widget.districtLabel,
            border: const OutlineInputBorder(),
          ),
          isExpanded: true,
          items: [
            for (final district in districts)
              DropdownMenuItem(
                value: district.id,
                child: Text(district.label(widget.languageCode)),
              ),
          ],
          onChanged: widget.regionId == null
              ? null
              : (value) {
                  widget.onDistrictChanged(value);
                  widget.onLocalityChanged(null);
                },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String?>(
          key: ValueKey('locality-${widget.localityId}'),
          initialValue: widget.localityId,
          decoration: InputDecoration(
            labelText: widget.localityLabel,
            border: const OutlineInputBorder(),
          ),
          isExpanded: true,
          items: [
            for (final locality in localities)
              DropdownMenuItem(
                value: locality.id,
                child: Text(locality.label(widget.languageCode)),
              ),
          ],
          onChanged: widget.districtId == null ? null : widget.onLocalityChanged,
        ),
      ],
    );
  }
}

/// Flat searchable locality picker (all countries) for filters.
class MarketLocalityFilterDropdown extends StatelessWidget {
  const MarketLocalityFilterDropdown({
    required this.value,
    required this.languageCode,
    required this.onChanged,
    this.label,
    this.allowNull = false,
    this.nullLabel,
    super.key,
  });

  final String? value;
  final String languageCode;
  final ValueChanged<String?> onChanged;
  final String? label;
  final bool allowNull;
  final String? nullLabel;

  @override
  Widget build(BuildContext context) {
    final items = <DropdownMenuItem<String?>>[];
    if (allowNull) {
      items.add(DropdownMenuItem(value: null, child: Text(nullLabel ?? '—')));
    }

    for (final country in MarketCountries.all) {
      final countryName = MarketCountries.name(country, languageCode);
      for (final loc in MarketGeography.localities
          .where((l) => l.countryCode == country)) {
        final region = MarketGeography.regionById(loc.regionId);
        final district = MarketGeography.districtById(loc.districtId);
        final subtitle = [
          district?.label(languageCode),
          region?.label(languageCode),
          countryName,
        ].whereType<String>().join(' · ');

        items.add(
          DropdownMenuItem(
            value: loc.id,
            child: Text(
              '${loc.label(languageCode)} — $subtitle',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      }
    }

    return DropdownButtonFormField<String?>(
      key: ValueKey(value),
      initialValue: MarketGeography.localityById(value)?.id ?? value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      isExpanded: true,
      items: items,
      onChanged: onChanged,
    );
  }
}
