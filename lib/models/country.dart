import 'package:flutter/material.dart';

enum Continent {
  africa('Africa', '🌍', Colors.orange),
  asia('Asia', '🌏', Colors.red),
  europe('Europe', '🌍', Colors.blue),
  northAmerica('North America', '🌎', Colors.green),
  southAmerica('South America', '🌎', Colors.teal),
  oceania('Oceania', '🌏', Colors.purple);

  const Continent(this.label, this.emoji, this.color);

  final String label;
  final String emoji;
  final Color color;
}

class Country {
  const Country({
    required this.name,
    required this.isoCode,
    required this.capital,
    required this.continent,
    required this.language,
    required this.greeting,
    required this.greetingPronunciation,
    required this.ttsLocale,
    this.funFact = '',
  });

  final String name;
  final String isoCode; // ISO 3166-1 alpha-2
  final String capital;
  final Continent continent;
  final String language;
  final String greeting; // "Hello" in the local language
  final String greetingPronunciation; // Phonetic hint for the child
  final String ttsLocale; // BCP 47 locale for flutter_tts
  final String funFact;
}
