/// Extended facts for a country, used for richer quizzes and detail views.
class ExtendedFacts {
  const ExtendedFacts({
    required this.population,
    required this.areaSqKm,
    required this.currency,
    required this.landmark,
    required this.funFacts,
    this.nationalAnimal,
    this.nationalDish,
  });

  /// Approximate population as a readable string (e.g. "331 million").
  final String population;

  /// Area in square kilometers as a readable string.
  final String areaSqKm;

  /// Currency name (e.g. "US Dollar (USD)").
  final String currency;

  /// A famous landmark or natural wonder.
  final String landmark;

  /// Multiple fun facts (aim for 3+).
  final List<String> funFacts;

  /// National animal, if notable.
  final String? nationalAnimal;

  /// A famous national dish.
  final String? nationalDish;
}
