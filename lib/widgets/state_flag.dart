import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

/// Renders a subdivision flag. Uses bundled PNGs for US states (`us-XX`),
/// falls back to the country_flags package for other codes (e.g. `gb-eng`).
class StateFlag extends StatelessWidget {
  const StateFlag({
    super.key,
    required this.flagCode,
    this.width = 48,
    this.height = 32,
    this.borderRadius = 6,
  });

  final String flagCode;
  final double width;
  final double height;
  final double borderRadius;

  bool get _isUsState => flagCode.startsWith('us-');

  @override
  Widget build(BuildContext context) {
    if (_isUsState) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.asset(
          'assets/state_flags/$flagCode.png',
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _placeholder(),
        ),
      );
    }

    // For non-US (e.g. gb-eng, gb-sct) use country_flags package.
    return CountryFlag.fromCountryCode(
      flagCode,
      theme: ImageTheme(
        width: width,
        height: height,
        shape: RoundedRectangle(borderRadius),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: const Icon(Icons.flag, color: Colors.grey, size: 18),
    );
  }
}
