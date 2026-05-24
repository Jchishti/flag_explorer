import 'dart:ui';

/// A single colorable region within a flag.
class FlagRegion {
  const FlagRegion({
    required this.label,
    required this.rect,
    required this.correctColor,
  });

  /// Human-readable label (e.g. "top stripe", "circle").
  final String label;

  /// Normalized rect (0..1 in both axes) within the flag canvas.
  final Rect rect;

  /// The correct color for this region.
  final Color correctColor;
}

/// A simplified flag template with rectangular colorable regions.
class FlagTemplate {
  const FlagTemplate({
    required this.countryName,
    required this.isoCode,
    required this.regions,
  });

  final String countryName;
  final String isoCode;
  final List<FlagRegion> regions;
}
