import 'package:countries_world_map/countries_world_map.dart';
import 'package:flutter/material.dart';

import '../models/country.dart';
import '../models/subdivision.dart';
import '../models/subdivision_data.dart';

/// Maps ISO country codes to the countries_world_map instruction strings.
/// Only countries with available map data are included.
final Map<String, String> _countryMapInstructions = {
  'AD': SMapAndorra.instructions,
  'AO': SMapAngola.instructions,
  'AR': SMapArgentina.instructions,
  'AM': SMapArmenia.instructions,
  'AU': SMapAustralia.instructions,
  'AT': SMapAustria.instructions,
  'AZ': SMapAzerbaijan.instructions,
  'BS': SMapBahamas.instructions,
  'BH': SMapBahrain.instructions,
  'BD': SMapBangladesh.instructions,
  'BY': SMapBelarus.instructions,
  'BE': SMapBelgium.instructions,
  'BT': SMapBhutan.instructions,
  'BO': SMapBolivia.instructions,
  'BW': SMapBotswana.instructions,
  'BR': SMapBrazil.instructions,
  'BN': SMapBrunei.instructions,
  'BG': SMapBulgaria.instructions,
  'BF': SMapBurkinaFaso.instructions,
  'BI': SMapBurundi.instructions,
  'CM': SMapCameroon.instructions,
  'CA': SMapCanada.instructions,
  'CV': SMapCapeVerde.instructions,
  'CF': SMapCentralAfricanRepublic.instructions,
  'TD': SMapChad.instructions,
  'CL': SMapChile.instructions,
  'CN': SMapChina.instructions,
  'CO': SMapColombia.instructions,
  'CG': SMapCongoBrazzaville.instructions,
  'CD': SMapCongoDR.instructions,
  'CR': SMapCostaRica.instructions,
  'HR': SMapCroatia.instructions,
  'CU': SMapCuba.instructions,
  'CY': SMapCyprus.instructions,
  'CZ': SMapCzechRepublic.instructions,
  'DK': SMapDenmark.instructions,
  'DJ': SMapDjibouti.instructions,
  'DO': SMapDominicanRepublic.instructions,
  'EC': SMapEcuador.instructions,
  'EG': SMapEgypt.instructions,
  'SV': SMapElSalvador.instructions,
  'EE': SMapEstonia.instructions,
  'ET': SMapEthiopia.instructions,
  'FI': SMapFinland.instructions,
  'FR': SMapFrance.instructions,
  'GE': SMapGeorgia.instructions,
  'DE': SMapGermany.instructions,
  'GR': SMapGreece.instructions,
  'GT': SMapGuatemala.instructions,
  'GN': SMapGuinea.instructions,
  'HT': SMapHaiti.instructions,
  'HN': SMapHonduras.instructions,
  'HU': SMapHungary.instructions,
  'IN': SMapIndia.instructions,
  'ID': SMapIndonesia.instructions,
  'IR': SMapIran.instructions,
  'IQ': SMapIraq.instructions,
  'IE': SMapIreland.instructions,
  'IL': SMapIsrael.instructions,
  'IT': SMapItaly.instructions,
  'JM': SMapJamaica.instructions,
  'JP': SMapJapan.instructions,
  'KZ': SMapKazakhstan.instructions,
  'KE': SMapKenya.instructions,
  'KG': SMapKyrgyzstan.instructions,
  'LA': SMapLaos.instructions,
  'LV': SMapLatvia.instructions,
  'LI': SMapLiechtenstein.instructions,
  'LT': SMapLithuania.instructions,
  'LU': SMapLuxembourg.instructions,
  'MY': SMapMalaysia.instructions,
  'ML': SMapMali.instructions,
  'MT': SMapMalta.instructions,
  'MX': SMapMexico.instructions,
  'MD': SMapMoldova.instructions,
  'ME': SMapMontenegro.instructions,
  'MA': SMapMorocco.instructions,
  'MZ': SMapMozambique.instructions,
  'MM': SMapMyanmar.instructions,
  'NA': SMapNamibia.instructions,
  'NP': SMapNepal.instructions,
  'NL': SMapNetherlands.instructions,
  'NZ': SMapNewZealand.instructions,
  'NI': SMapNicaragua.instructions,
  'NG': SMapNigeria.instructions,
  'NO': SMapNorway.instructions,
  'OM': SMapOman.instructions,
  'PK': SMapPakistan.instructions,
  'PA': SMapPanama.instructions,
  'PY': SMapParaguay.instructions,
  'PE': SMapPeru.instructions,
  'PH': SMapPhilippines.instructions,
  'PL': SMapPoland.instructions,
  'PT': SMapPortugal.instructions,
  'QA': SMapQatar.instructions,
  'RO': SMapRomania.instructions,
  'RU': SMapRussia.instructions,
  'RW': SMapRwanda.instructions,
  'SA': SMapSaudiArabia.instructions,
  'RS': SMapSerbia.instructions,
  'SL': SMapSierraLeone.instructions,
  'SG': SMapSingapore.instructions,
  'SK': SMapSlovakia.instructions,
  'SI': SMapSlovenia.instructions,
  'ZA': SMapSouthAfrica.instructions,
  'KR': SMapSouthKorea.instructions,
  'ES': SMapSpain.instructions,
  'LK': SMapSriLanka.instructions,
  'SD': SMapSudan.instructions,
  'SE': SMapSweden.instructions,
  'CH': SMapSwitzerland.instructions,
  'SY': SMapSyria.instructions,
  'TJ': SMapTajikistan.instructions,
  'TH': SMapThailand.instructions,
  'TR': SMapTurkey.instructions,
  'UG': SMapUganda.instructions,
  'UA': SMapUkraine.instructions,
  'AE': SMapUnitedArabEmirates.instructions,
  'GB': SMapUnitedKingdom.instructions,
  'US': SMapUnitedStates.instructions,
  'UY': SMapUruguay.instructions,
  'UZ': SMapUzbekistan.instructions,
  'VE': SMapVenezuela.instructions,
  'VN': SMapVietnam.instructions,
  'YE': SMapYemen.instructions,
  'ZM': SMapZambia.instructions,
  'ZW': SMapZimbabwe.instructions,
};

/// Whether a detailed state/province map is available for this country.
bool hasCountryMap(String isoCode) =>
    _countryMapInstructions.containsKey(isoCode.toUpperCase());

class CountryMapScreen extends StatefulWidget {
  const CountryMapScreen({
    super.key,
    required this.country,
  });

  final Country country;

  @override
  State<CountryMapScreen> createState() => _CountryMapScreenState();
}

class _CountryMapScreenState extends State<CountryMapScreen> {
  String? _selectedId;
  String? _selectedName;

  late final List<Subdivision>? _subs = subdivisionsFor(widget.country.isoCode);

  void _onRegionTap(String id, String name, TapUpDetails _) {
    setState(() {
      _selectedId = id;
      _selectedName = name;
    });
  }

  /// Find the matching subdivision from our data.
  Subdivision? _findSub(String name) {
    final subs = _subs;
    if (subs == null) return null;
    for (final s in subs) {
      if (s.name.toLowerCase() == name.toLowerCase()) return s;
    }
    for (final s in subs) {
      if (s.name.toLowerCase().contains(name.toLowerCase()) ||
          name.toLowerCase().contains(s.name.toLowerCase())) {
        return s;
      }
    }
    return null;
  }

  /// Find which province/state the national capital is in.
  String? _capitalProvince() {
    final subs = _subs;
    if (subs == null) return null;
    final natCapital = widget.country.capital.toLowerCase();
    for (final s in subs) {
      if (s.capital.toLowerCase() == natCapital) return s.name;
    }
    // Partial match
    for (final s in subs) {
      if (s.capital.toLowerCase().contains(natCapital) ||
          natCapital.contains(s.capital.toLowerCase())) {
        return s.name;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.country.continent.color;
    final instructions = _countryMapInstructions[widget.country.isoCode]!;

    // Highlight selected region.
    final colors = <String, Color>{};
    if (_selectedId != null) {
      colors[_selectedId!] = color.withValues(alpha: 0.5);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.country.name} Map'),
        backgroundColor: color.withValues(alpha: 0.12),
      ),
      body: Column(
        children: [
          // Country summary header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            color: color.withValues(alpha: 0.06),
            child: _buildCountrySummary(color),
          ),

          // Map
          Expanded(
            child: InteractiveViewer(
              maxScale: 8,
              minScale: 0.5,
              child: SimpleMap(
                instructions: instructions,
                defaultColor: Colors.grey.shade200,
                colors: colors,
                countryBorder: CountryBorder(
                  color: Colors.grey.shade500,
                  width: 1,
                ),
                callback: _onRegionTap,
              ),
            ),
          ),

          // Info panel at bottom
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: _selectedName != null
                ? _buildInfoPanel(color)
                : Text(
                    'Tap a state or province to learn more',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountrySummary(Color color) {
    final subCount = _subs?.length;
    final capProvince = _capitalProvince();
    final subLabel = widget.country.isoCode == 'US'
        ? 'states'
        : widget.country.isoCode == 'GB'
            ? 'nations'
            : 'provinces / regions';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (subCount != null)
          Text(
            '$subCount $subLabel',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        const SizedBox(height: 2),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Capital: ${widget.country.capital}',
                style: TextStyle(
                    fontSize: 14, color: Colors.grey[700]),
              ),
              if (capProvince != null)
                TextSpan(
                  text: '  (in $capProvince)',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoPanel(Color color) {
    final sub = _findSub(_selectedName!);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _selectedName!,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        if (sub != null) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_city, size: 18, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                'Capital: ${sub.capital}',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ],
          ),
          // US-specific details
          if (sub.hasStateInfo) ...[
            const SizedBox(height: 4),
            Text(
              '#${sub.orderAdmitted} state • Admitted ${sub.yearAdmitted}',
              style: TextStyle(fontSize: 14, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              '🐦 ${sub.stateBird}  •  🌲 ${sub.stateTree}',
              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
            ),
          ],
        ],
      ],
    );
  }
}
