import 'package:flutter/material.dart';

import 'achievements_screen.dart';
import 'explore_screen.dart';
import 'flag_coloring_screen.dart';
import 'quiz_screen.dart';
import 'country_challenge_screen.dart';
import 'state_flag_challenge_screen.dart';
import 'world_map_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(
                'Flag Explorer',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Discover the world!',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 16),
              // Achievements button
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AchievementsScreen()),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.emoji_events, size: 20, color: Colors.amber),
                      SizedBox(width: 6),
                      Text('Achievements',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 600;
                    return GridView.count(
                      crossAxisCount: isWide ? 4 : 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: isWide ? 1.0 : 1.1,
                      children: [
                        _NavCard(
                          icon: Icons.flag,
                          label: 'US State\nFlags',
                          color: Colors.red,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const StateFlagChallengeScreen(),
                            ),
                          ),
                        ),
                        _NavCard(
                          icon: Icons.explore,
                          label: 'Explore',
                          color: Colors.blue,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ExploreScreen(),
                            ),
                          ),
                        ),
                        _NavCard(
                          icon: Icons.quiz,
                          label: 'Quiz Me!',
                          color: Colors.orange,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const QuizScreen(),
                            ),
                          ),
                        ),
                        _NavCard(
                          icon: Icons.palette,
                          label: 'Color Flags',
                          color: Colors.green,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FlagColoringScreen(),
                            ),
                          ),
                        ),
                        _NavCard(
                          icon: Icons.emoji_events,
                          label: 'Country\nChallenge',
                          color: Colors.amber,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const CountryChallengeScreen(),
                            ),
                          ),
                        ),
                        _NavCard(
                          icon: Icons.map,
                          label: 'World Map',
                          color: Colors.purple,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const WorldMapScreen(),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              // Version + changelog
              GestureDetector(
                onTap: () => _showChangelog(context),
                child: Text(
                  'v1.5.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangelog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text('What\'s New',
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              ..._changelogEntries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.version,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700])),
                        const SizedBox(height: 4),
                        ...e.notes.map((n) => Padding(
                              padding: const EdgeInsets.only(left: 8, top: 2),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ',
                                      style: TextStyle(fontSize: 14)),
                                  Expanded(
                                    child: Text(n,
                                        style:
                                            const TextStyle(fontSize: 14)),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Changelog ───────────────────────────────────────────────────────────────

class _ChangelogEntry {
  const _ChangelogEntry(this.version, this.notes);
  final String version;
  final List<String> notes;
}

const _changelogEntries = [
  _ChangelogEntry('v1.5.0 — May 27, 2026', [
    '🏆 Achievement system! 30+ unlockable achievements with animated toast notifications',
    '🎯 Country Challenge: Mario Kart-style per-country quizzes with bronze/silver/gold medals',
    '📚 Extended facts for 50 countries: population, currency, landmarks, national animals, dishes, 3-4 fun facts each',
    '🔍 Country search on World Map — search by name, capital, or code',
    '👤 Player profiles — switch between players, persistent best streaks per player',
    '🃏 No-repeat quiz — shuffled deck cycles through all countries before repeating',
    '🌍 Added Antarctica, South Georgia, and Kurdistan',
  ]),
  _ChangelogEntry('v1.4.0 — May 26, 2026', [
    '🔊 Read-aloud buttons on quiz questions and answer options (TTS)',
    '🗺️ Country drill-down maps with state/province boundaries (~135 countries)',
    'Tap state on map → see flag, capital, bird, tree (US), admission info',
    'Country map summary header: subdivision count, capital location',
  ]),
  _ChangelogEntry('v1.3.0 — May 24, 2026', [
    '🇺🇸 US State Flag Challenge: 3 modes — Name That State, Pick The Flag, Speed Round (60s)',
    '🐦 US state details: state bird, state tree, admission order & year for all 50 states',
    '🖼️ Wikipedia bird/tree images loaded dynamically in state detail sheet',
    '🏳️ Bundled 50 US state flag PNGs (fixed broken rendering)',
    'State flag shown on map when tapping US states, with tap-to-expand detail sheet',
  ]),
  _ChangelogEntry('v1.2.0 — May 24, 2026', [
    '📍 36 countries with states/provinces data (~700 entries)',
    '📝 Per-country subdivision quiz with streak tracking',
    '🗺️ Subdivisions list with flags (US states, UK nations)',
    'Regional organizations: EU (with flag), African Union, ASEAN, Pacific Islands Forum',
    'Flag quiz fix: country names hidden until answer is revealed',
  ]),
  _ChangelogEntry('v1.1.0 — May 23, 2026', [
    '🌐 195 countries with flags, capitals, languages, greetings, and fun facts',
    '🎮 Quiz: teacher mode + solo streak mode, 4 categories',
    '🎨 Flag coloring: 20 templates with tap-to-fill',
    '🗺️ Interactive world map with continent zoom',
    '🔈 Text-to-speech greetings in 40+ languages',
  ]),
  _ChangelogEntry('v1.0.0 — May 23, 2026', [
    '🚀 Initial release: Explore, Quiz, Color Flags, World Map',
    'Built for an 8-year-old who loves flags!',
  ]),
];

class _NavCard extends StatelessWidget {
  const _NavCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
