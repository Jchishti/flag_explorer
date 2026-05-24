import 'package:flutter/material.dart';

import 'country.dart';

/// A regional organization (EU, AU, ASEAN, etc.) shown per continent.
class RegionalOrg {
  const RegionalOrg({
    required this.name,
    required this.shortName,
    required this.continent,
    this.flagCode,
    required this.memberCount,
    required this.description,
    required this.icon,
  });

  final String name;
  final String shortName;
  final Continent continent;

  /// ISO code for country_flags package (e.g. 'EU'). Null if not supported.
  final String? flagCode;

  final int memberCount;
  final String description;
  final IconData icon;
}

const List<RegionalOrg> allRegionalOrgs = [
  RegionalOrg(
    name: 'European Union',
    shortName: 'EU',
    continent: Continent.europe,
    flagCode: 'EU',
    memberCount: 27,
    description: '27 European countries working together. The EU flag has 12 gold stars in a circle on a blue background.',
    icon: Icons.stars,
  ),
  RegionalOrg(
    name: 'African Union',
    shortName: 'AU',
    continent: Continent.africa,
    flagCode: null, // not in country_flags package
    memberCount: 55,
    description: '55 African countries united. The AU flag is green with a gold map of Africa surrounded by 55 stars.',
    icon: Icons.public,
  ),
  RegionalOrg(
    name: 'ASEAN',
    shortName: 'ASEAN',
    continent: Continent.asia,
    flagCode: null,
    memberCount: 11,
    description: '11 Southeast Asian countries. The ASEAN flag is blue with a red circle containing 10 golden rice stalks.',
    icon: Icons.rice_bowl,
  ),
  RegionalOrg(
    name: 'Pacific Islands Forum',
    shortName: 'PIF',
    continent: Continent.oceania,
    flagCode: null,
    memberCount: 18,
    description: '18 Pacific island countries and territories working together on regional issues.',
    icon: Icons.water,
  ),
];

/// Returns regional orgs for a given continent.
List<RegionalOrg> orgsForContinent(Continent continent) =>
    allRegionalOrgs.where((o) => o.continent == continent).toList();
