import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import '../models/country.dart';
import '../models/subdivision_data.dart';
import '../services/greeting_service.dart';
import 'subdivision_quiz_screen.dart';
import 'subdivisions_screen.dart';

/// Full-screen detail (phone layout).
class CountryDetailScreen extends StatelessWidget {
  const CountryDetailScreen({super.key, required this.country});

  final Country country;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(country.name),
        backgroundColor: country.continent.color.withValues(alpha: 0.15),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: CountryDetailPanel(country: country),
      ),
    );
  }
}

/// Embeddable detail panel, used by both phone and iPad layouts.
class CountryDetailPanel extends StatelessWidget {
  const CountryDetailPanel({super.key, required this.country});

  final Country country;

  @override
  Widget build(BuildContext context) {
    final color = country.continent.color;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // ── Large flag ──
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CountryFlag.fromCountryCode(
                  country.isoCode,
                  theme: const ImageTheme(
                    width: 240,
                    height: 160,
                    shape: RoundedRectangle(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Country name ──
            Text(
              country.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              country.continent.label,
              style: TextStyle(fontSize: 16, color: color),
            ),
            const SizedBox(height: 24),

            // ── Info rows ──
            _InfoRow(
              icon: Icons.location_city,
              label: 'Capital',
              value: country.capital,
              color: color,
            ),
            _InfoRow(
              icon: Icons.translate,
              label: 'Language',
              value: country.language,
              color: color,
            ),
            _InfoRow(
              icon: Icons.chat_bubble_outline,
              label: 'Hello',
              value: '${country.greeting}  (${country.greetingPronunciation})',
              color: color,
            ),
            const SizedBox(height: 24),

            // ── Say hello button ──
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: color,
                minimumSize: const Size(200, 56),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.volume_up_rounded, size: 24),
              label: Text('Say "${country.greeting}"'),
              onPressed: () =>
                  GreetingService.instance.speakGreeting(country),
            ),
            const SizedBox(height: 24),

            // ── Fun fact ──
            // ── Subdivisions buttons ──
            if (hasSubdivisions(country.isoCode))
              Builder(builder: (context) {
                final subs = subdivisionsFor(country.isoCode)!;
                final hasFlags = subs.any((s) => s.flagCode != null);
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 48),
                              side: BorderSide(color: color),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: Icon(Icons.list_alt, color: color, size: 20),
                            label: Text(
                              'States & Provinces',
                              style: TextStyle(color: color, fontSize: 14),
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SubdivisionsScreen(
                                  countryName: country.name,
                                  subdivisions: subs,
                                  color: color,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: color,
                              minimumSize: const Size(0, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.quiz, size: 20),
                            label: const Text(
                              'State Quiz',
                              style: TextStyle(fontSize: 14),
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SubdivisionQuizScreen(
                                  countryName: country.name,
                                  subdivisions: subs,
                                  color: color,
                                  hasFlags: hasFlags,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              }),

            if (country.funFact.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb_outline, color: color, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        country.funFact,
                        style: const TextStyle(fontSize: 16, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
