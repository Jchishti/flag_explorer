import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import '../models/country.dart';
import '../services/greeting_service.dart';

class CountryCard extends StatelessWidget {
  const CountryCard({
    super.key,
    required this.country,
    this.onTap,
  });

  final Country country;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Flag
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CountryFlag.fromCountryCode(
                  country.isoCode,
                  theme: const ImageTheme(
                    width: 64,
                    height: 44,
                    shape: RoundedRectangle(8),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      country.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${country.capital}  •  ${country.language}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '"${country.greeting}" (${country.greetingPronunciation})',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: country.continent.color,
                      ),
                    ),
                  ],
                ),
              ),
              // Audio button
              IconButton(
                icon: Icon(
                  Icons.volume_up_rounded,
                  color: country.continent.color,
                  size: 28,
                ),
                tooltip: 'Hear the greeting',
                onPressed: () =>
                    GreetingService.instance.speakGreeting(country),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
