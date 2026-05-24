import 'package:countries_world_map/countries_world_map.dart';
import 'package:flutter/material.dart';

import '../models/country.dart';
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

  void _onRegionTap(String id, String name, TapUpDetails _) {
    setState(() {
      _selectedId = id;
      _selectedName = name;
    });
  }

  /// Try to find the capital from our subdivision data using the tapped name.
  String? _findCapital(String name) {
    final subs = subdivisionsFor(widget.country.isoCode);
    if (subs == null) return null;
    // Try exact match first, then contains match.
    for (final s in subs) {
      if (s.name.toLowerCase() == name.toLowerCase()) return s.capital;
    }
    for (final s in subs) {
      if (s.name.toLowerCase().contains(name.toLowerCase()) ||
          name.toLowerCase().contains(s.name.toLowerCase())) {
        return s.capital;
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

  Widget _buildInfoPanel(Color color) {
    final capital = _findCapital(_selectedName!);
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
        if (capital != null) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_city, size: 18, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                'Capital: $capital',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
