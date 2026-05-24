import 'dart:ui';

import 'flag_template.dart';

// Helper: horizontal tricolor (top / middle / bottom thirds).
FlagTemplate _hTricolor(String name, String iso, Color c1, Color c2, Color c3) {
  return FlagTemplate(countryName: name, isoCode: iso, regions: [
    FlagRegion(label: 'Top stripe', rect: const Rect.fromLTWH(0, 0, 1, 1 / 3), correctColor: c1),
    FlagRegion(label: 'Middle stripe', rect: const Rect.fromLTWH(0, 1 / 3, 1, 1 / 3), correctColor: c2),
    FlagRegion(label: 'Bottom stripe', rect: const Rect.fromLTWH(0, 2 / 3, 1, 1 / 3), correctColor: c3),
  ]);
}

// Helper: vertical tricolor (left / center / right thirds).
FlagTemplate _vTricolor(String name, String iso, Color c1, Color c2, Color c3) {
  return FlagTemplate(countryName: name, isoCode: iso, regions: [
    FlagRegion(label: 'Left stripe', rect: const Rect.fromLTWH(0, 0, 1 / 3, 1), correctColor: c1),
    FlagRegion(label: 'Center stripe', rect: const Rect.fromLTWH(1 / 3, 0, 1 / 3, 1), correctColor: c2),
    FlagRegion(label: 'Right stripe', rect: const Rect.fromLTWH(2 / 3, 0, 1 / 3, 1), correctColor: c3),
  ]);
}

// Helper: horizontal bicolor (top half / bottom half).
FlagTemplate _hBicolor(String name, String iso, Color c1, Color c2) {
  return FlagTemplate(countryName: name, isoCode: iso, regions: [
    FlagRegion(label: 'Top half', rect: const Rect.fromLTWH(0, 0, 1, 0.5), correctColor: c1),
    FlagRegion(label: 'Bottom half', rect: const Rect.fromLTWH(0, 0.5, 1, 0.5), correctColor: c2),
  ]);
}

// Common flag colors (approximate official values).
const _red = Color(0xFFCE1126);
const _white = Color(0xFFFFFFFF);
const _blue = Color(0xFF002395);
const _green = Color(0xFF009246);
const _black = Color(0xFF000000);
const _yellow = Color(0xFFFFD100);
const _orange = Color(0xFFFF9933);
const _skyBlue = Color(0xFF75AADB);

/// Curated list of ~20 flags with simple rectangular geometry.
final List<FlagTemplate> allFlagTemplates = [
  // ── Horizontal tricolors ──
  _hTricolor('Germany', 'DE', _black, _red, _yellow),
  _hTricolor('Netherlands', 'NL', _red, _white, const Color(0xFF003DA5)),
  _hTricolor('Russia', 'RU', _white, _blue, _red),
  _hTricolor('India', 'IN', _orange, _white, _green),
  _hTricolor('Egypt', 'EG', _red, _white, _black),
  _hTricolor('Colombia', 'CO', _yellow, _blue, _red),
  _hTricolor('Ethiopia', 'ET', _green, _yellow, _red),
  _hTricolor('Peru', 'PE', _red, _white, _red),

  // ── Vertical tricolors ──
  _vTricolor('France', 'FR', _blue, _white, _red),
  _vTricolor('Italy', 'IT', _green, _white, _red),
  _vTricolor('Nigeria', 'NG', _green, _white, _green),
  _vTricolor('Mexico', 'MX', _green, _white, _red),
  _vTricolor('Chile', 'CL', _white, _white, _red), // simplified

  // ── Horizontal bicolors ──
  _hBicolor('Poland', 'PL', _white, _red),
  _hBicolor('Indonesia', 'ID', _red, _white),
  _hBicolor('Ukraine', 'UA', const Color(0xFF005BBB), _yellow),

  // ── Special: Nordic cross (Sweden) ──
  FlagTemplate(countryName: 'Sweden', isoCode: 'SE', regions: [
    // Background
    FlagRegion(label: 'Background', rect: const Rect.fromLTWH(0, 0, 1, 1), correctColor: const Color(0xFF006AA7)),
    // Horizontal bar of cross
    FlagRegion(label: 'Cross horizontal', rect: const Rect.fromLTWH(0, 0.35, 1, 0.30), correctColor: _yellow),
    // Vertical bar of cross
    FlagRegion(label: 'Cross vertical', rect: const Rect.fromLTWH(0.28, 0, 0.18, 1), correctColor: _yellow),
  ]),

  // ── Special: Argentina (three horizontal stripes, sky blue) ──
  _hTricolor('Argentina', 'AR', _skyBlue, _white, _skyBlue),

  // ── Special: Japan (white bg + center red circle drawn separately) ──
  FlagTemplate(countryName: 'Japan', isoCode: 'JP', regions: [
    FlagRegion(label: 'Background', rect: const Rect.fromLTWH(0, 0, 1, 1), correctColor: _white),
    // Circle is handled specially by the painter — stored as a small centered rect
    FlagRegion(label: 'Sun circle', rect: const Rect.fromLTWH(0.3, 0.15, 0.4, 0.7), correctColor: _red),
  ]),

  // ── Special: Bangladesh (green bg + center red circle) ──
  FlagTemplate(countryName: 'Bangladesh', isoCode: 'BD', regions: [
    FlagRegion(label: 'Background', rect: const Rect.fromLTWH(0, 0, 1, 1), correctColor: const Color(0xFF006A4E)),
    FlagRegion(label: 'Sun circle', rect: const Rect.fromLTWH(0.28, 0.13, 0.40, 0.74), correctColor: _red),
  ]),
];
