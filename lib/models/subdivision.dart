/// A state, province, region, or territory within a country.
class Subdivision {
  const Subdivision({
    required this.name,
    required this.capital,
    this.flagCode,
    this.stateBird,
    this.stateBirdArticle,
    this.stateTree,
    this.stateTreeArticle,
    this.orderAdmitted,
    this.yearAdmitted,
  });

  final String name;
  final String capital;

  /// ISO 3166-2 code for use with country_flags package (e.g. 'us-ca').
  /// Null if no flag is available.
  final String? flagCode;

  // ── US-specific fields (null for non-US subdivisions) ──

  /// Official state bird.
  final String? stateBird;

  /// Wikipedia article title for the state bird (for image lookup).
  final String? stateBirdArticle;

  /// Official state tree.
  final String? stateTree;

  /// Wikipedia article title for the state tree (for image lookup).
  final String? stateTreeArticle;

  /// Order of admission to the Union (1-50).
  final int? orderAdmitted;

  /// Year admitted to the Union.
  final int? yearAdmitted;

  /// Whether this subdivision has extended US state info.
  bool get hasStateInfo => orderAdmitted != null;
}
