import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import '../models/subdivision.dart';

class SubdivisionsScreen extends StatelessWidget {
  const SubdivisionsScreen({
    super.key,
    required this.countryName,
    required this.subdivisions,
    required this.color,
  });

  final String countryName;
  final List<Subdivision> subdivisions;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$countryName — States & Provinces'),
        backgroundColor: color.withValues(alpha: 0.12),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: subdivisions.length,
        separatorBuilder: (_, _) => const SizedBox(height: 6),
        itemBuilder: (_, i) {
          final s = subdivisions[i];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Flag (if available)
                  if (s.flagCode != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: CountryFlag.fromCountryCode(
                        s.flagCode!,
                        theme: const ImageTheme(
                          width: 48,
                          height: 32,
                          shape: RoundedRectangle(6),
                        ),
                      ),
                    ),
                  // Name + details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                s.name,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (s.hasStateInfo)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '#${s.orderAdmitted} • ${s.yearAdmitted}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: color,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Capital: ${s.capital}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (s.stateBird != null) ...
                          [
                            const SizedBox(height: 2),
                            Text(
                              '🐦 ${s.stateBird}  •  🌲 ${s.stateTree}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
