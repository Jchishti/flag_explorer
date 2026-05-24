import 'package:flutter/material.dart';

import 'package:country_flags/country_flags.dart';

import '../models/country.dart';
import '../models/country_data.dart';
import '../models/regional_org.dart';
import '../widgets/country_card.dart';
import 'country_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  Continent _selected = Continent.africa;

  List<Country> get _countries => countriesFor(_selected);

  void _onContinentTap(Continent c) => setState(() => _selected = c);

  void _openDetail(Country country) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CountryDetailScreen(country: country)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore Countries')),
      body: Column(
        children: [
          // ── Continent picker ──
          SizedBox(
            height: 56,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: Continent.values.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final c = Continent.values[i];
                final isActive = c == _selected;
                return FilterChip(
                  selected: isActive,
                  label: Text(
                    '${c.emoji}  ${c.label}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selectedColor: c.color.withValues(alpha: 0.25),
                  checkmarkColor: c.color,
                  onSelected: (_) => _onContinentTap(c),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // ── Country count ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_countries.length} countries in ${_selected.label}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // ── Country list ──
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // iPad: show master-detail side by side
                if (constraints.maxWidth > 700) {
                  return _WideLayout(
                    countries: _countries,
                    continentColor: _selected.color,
                  );
                }
                final orgs = orgsForContinent(_selected);
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: orgs.length + _countries.length,
                  itemBuilder: (context, i) {
                    // Regional orgs first
                    if (i < orgs.length) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _OrgCard(org: orgs[i]),
                      );
                    }
                    final country = _countries[i - orgs.length];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: CountryCard(
                        country: country,
                        onTap: () => _openDetail(country),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// iPad master-detail layout: list on left, detail on right.
class _WideLayout extends StatefulWidget {
  const _WideLayout({
    required this.countries,
    required this.continentColor,
  });

  final List<Country> countries;
  final Color continentColor;

  @override
  State<_WideLayout> createState() => _WideLayoutState();
}

class _WideLayoutState extends State<_WideLayout> {
  int _selectedIndex = 0;

  @override
  void didUpdateWidget(_WideLayout old) {
    super.didUpdateWidget(old);
    // Reset selection when continent changes.
    if (old.countries != widget.countries) {
      _selectedIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final country = widget.countries.isEmpty
        ? null
        : widget.countries[_selectedIndex.clamp(0, widget.countries.length - 1)];

    return Row(
      children: [
        // Master list (1/3 width)
        SizedBox(
          width: 320,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: widget.countries.length,
            itemBuilder: (context, i) {
              final c = widget.countries[i];
              final isActive = i == _selectedIndex;
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Material(
                  color: isActive
                      ? widget.continentColor.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: CountryCard(
                    country: c,
                    onTap: () => setState(() => _selectedIndex = i),
                  ),
                ),
              );
            },
          ),
        ),
        const VerticalDivider(width: 1),
        // Detail panel
        Expanded(
          child: country == null
              ? const Center(child: Text('Select a country'))
              : CountryDetailPanel(country: country),
        ),
      ],
    );
  }
}

/// Card for a regional organization (EU, AU, etc.).
class _OrgCard extends StatelessWidget {
  const _OrgCard({required this.org});

  final RegionalOrg org;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: org.continent.color.withValues(alpha: 0.06),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showOrgSheet(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (org.flagCode != null)
                CountryFlag.fromCountryCode(
                  org.flagCode!,
                  theme: const ImageTheme(
                    width: 56,
                    height: 38,
                    shape: RoundedRectangle(8),
                  ),
                )
              else
                Container(
                  width: 56,
                  height: 38,
                  decoration: BoxDecoration(
                    color: org.continent.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(org.icon, color: org.continent.color, size: 24),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${org.shortName} — ${org.name}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: org.continent.color,
                      ),
                    ),
                    Text(
                      '${org.memberCount} member countries',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.info_outline, color: org.continent.color, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  void _showOrgSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            if (org.flagCode != null)
              CountryFlag.fromCountryCode(
                org.flagCode!,
                theme: const ImageTheme(
                  width: 120,
                  height: 80,
                  shape: RoundedRectangle(12),
                ),
              ),
            if (org.flagCode == null)
              Icon(org.icon, size: 60, color: org.continent.color),
            const SizedBox(height: 16),
            Text(
              org.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              org.description,
              style: const TextStyle(fontSize: 16, height: 1.4),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
