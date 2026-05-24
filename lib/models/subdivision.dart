/// A state, province, region, or territory within a country.
class Subdivision {
  const Subdivision({
    required this.name,
    required this.capital,
    this.flagCode,
  });

  final String name;
  final String capital;

  /// ISO 3166-2 code for use with country_flags package (e.g. 'us-ca').
  /// Null if no flag is available.
  final String? flagCode;
}
