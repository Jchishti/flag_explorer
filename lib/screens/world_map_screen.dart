import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:interactive_world_map/interactive_world_map.dart';

import '../models/country.dart';
import '../models/country_data.dart';
import '../services/greeting_service.dart';

/// Reverse-resolve the map's internal IDs back to ISO alpha-2.
String _mapIdToIso(String mapId) {
  const reverseOverrides = {'X_FRA': 'FR', 'X_NOR': 'NO'};
  return reverseOverrides[mapId] ?? mapId;
}

/// Map our Continent enum to the UN Geoscheme region sets used by the package.
Set<String> _continentMapIds(Continent continent) {
  return switch (continent) {
    Continent.africa => UnRegion.africa.mapIds(),
    Continent.asia => UnRegion.asia.mapIds(),
    Continent.europe => UnRegion.europe.mapIds(),
    Continent.northAmerica => UnRegion.americas.mapIds(), // includes both
    Continent.southAmerica => UnRegion.americas.mapIds(),
    Continent.oceania => UnRegion.oceania.mapIds(),
  };
}

class WorldMapScreen extends StatefulWidget {
  const WorldMapScreen({super.key});

  @override
  State<WorldMapScreen> createState() => _WorldMapScreenState();
}

class _WorldMapScreenState extends State<WorldMapScreen> {
  final _controller = WorldMapController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onCountryTap(String mapId) {
    final iso = _mapIdToIso(mapId);
    final country = countryByIso(iso);
    if (country == null) return;

    _controller.selectedId = mapId;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _CountrySheet(country: country),
    ).whenComplete(() {
      _controller.selectedId = null;
    });
  }

  void _zoomToContinent(Continent continent) {
    final ids = _continentMapIds(continent);
    _controller.fitToCountries(
      ids,
      options: const FitOptions(
        padding: 24,
        duration: Duration(milliseconds: 400),
        excludeRemoteIslands: true,
        remoteIslandLevel: RemoteIslandLevel.main,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('World Map')),
      body: Column(
        children: [
          // Continent zoom chips
          SizedBox(
            height: 52,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              scrollDirection: Axis.horizontal,
              itemCount: Continent.values.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final c = Continent.values[i];
                return ActionChip(
                  avatar: Text(c.emoji, style: const TextStyle(fontSize: 16)),
                  label: Text(c.label, style: const TextStyle(fontSize: 13)),
                  backgroundColor: c.color.withValues(alpha: 0.15),
                  onPressed: () => _zoomToContinent(c),
                );
              },
            ),
          ),

          // Map
          Expanded(
            child: InteractiveWorldMap(
              controller: _controller,
              selectOnTap: false,
              onCountryTap: _onCountryTap,
              style: const WorldMapStyle(
                landFillColor: Color(0xFFE0E0E0),
                selectedFillColor: Color(0xFF4F8EF7),
                highlightedFillColor: Color(0xFF90CAF9),
                showBorders: true,
                borderColor: Color(0xFFBDBDBD),
                borderWidth: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bottom sheet for tapped country ─────────────────────────────────────────

class _CountrySheet extends StatelessWidget {
  const _CountrySheet({required this.country});

  final Country country;

  @override
  Widget build(BuildContext context) {
    final color = country.continent.color;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Flag + name
          Row(
            children: [
              CountryFlag.fromCountryCode(
                country.isoCode,
                theme: const ImageTheme(
                  width: 64,
                  height: 44,
                  shape: RoundedRectangle(8),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(country.name,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    Text(country.continent.label,
                        style: TextStyle(fontSize: 14, color: color)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Info
          _Row(Icons.location_city, 'Capital', country.capital, color),
          _Row(Icons.translate, 'Language', country.language, color),
          _Row(Icons.chat_bubble_outline, 'Hello',
              '${country.greeting}  (${country.greetingPronunciation})', color),
          const SizedBox(height: 16),

          // Say hello
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: color,
              minimumSize: const Size(180, 48),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            icon: const Icon(Icons.volume_up_rounded, size: 20),
            label: Text('Say "${country.greeting}"'),
            onPressed: () =>
                GreetingService.instance.speakGreeting(country),
          ),

          // Fun fact
          if (country.funFact.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(country.funFact,
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey[700], height: 1.3)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.icon, this.label, this.value, this.color);
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          SizedBox(
            width: 72,
            child: Text(label,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600])),
          ),
          Expanded(
              child: Text(value, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}
