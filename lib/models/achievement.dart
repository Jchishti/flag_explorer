import 'package:flutter/material.dart';

/// A single achievement definition.
class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.secret = false,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  /// Secret achievements are hidden until unlocked.
  final bool secret;
}

/// All achievements in the app.
const List<Achievement> allAchievements = [
  // ─── First steps ───────────────────────────────────────────────────
  Achievement(
    id: 'first_explore',
    title: 'World Opener',
    description: 'View your first country in Explore',
    icon: Icons.explore,
    color: Colors.blue,
  ),
  Achievement(
    id: 'first_quiz',
    title: 'Quiz Rookie',
    description: 'Complete your first quiz question',
    icon: Icons.quiz,
    color: Colors.orange,
  ),
  Achievement(
    id: 'first_color',
    title: 'Young Artist',
    description: 'Color your first flag',
    icon: Icons.palette,
    color: Colors.green,
  ),
  Achievement(
    id: 'first_map_tap',
    title: 'Globe Trotter',
    description: 'Tap a country on the World Map',
    icon: Icons.map,
    color: Colors.purple,
  ),
  Achievement(
    id: 'first_tts',
    title: 'Polyglot Beginner',
    description: 'Listen to "hello" in any language',
    icon: Icons.volume_up,
    color: Colors.teal,
  ),

  // ─── Quiz streaks ──────────────────────────────────────────────────
  Achievement(
    id: 'streak_5',
    title: 'Warming Up',
    description: 'Get a 5-question streak',
    icon: Icons.local_fire_department,
    color: Colors.deepOrange,
  ),
  Achievement(
    id: 'streak_10',
    title: 'On Fire',
    description: 'Get a 10-question streak',
    icon: Icons.local_fire_department,
    color: Colors.deepOrange,
  ),
  Achievement(
    id: 'streak_25',
    title: 'Unstoppable',
    description: 'Get a 25-question streak',
    icon: Icons.local_fire_department,
    color: Colors.red,
  ),
  Achievement(
    id: 'streak_50',
    title: 'Geography Genius',
    description: 'Get a 50-question streak',
    icon: Icons.psychology,
    color: Colors.red,
  ),

  // ─── Country Challenge medals ──────────────────────────────────────
  Achievement(
    id: 'medal_first_bronze',
    title: 'Bronze Beginner',
    description: 'Earn your first bronze medal',
    icon: Icons.emoji_events,
    color: Colors.brown,
  ),
  Achievement(
    id: 'medal_first_silver',
    title: 'Silver Scholar',
    description: 'Earn your first silver medal',
    icon: Icons.emoji_events,
    color: Colors.grey,
  ),
  Achievement(
    id: 'medal_first_gold',
    title: 'Gold Star',
    description: 'Earn your first gold medal',
    icon: Icons.emoji_events,
    color: Colors.amber,
  ),
  Achievement(
    id: 'medal_10_gold',
    title: 'Medal Collector',
    description: 'Earn 10 gold medals',
    icon: Icons.military_tech,
    color: Colors.amber,
  ),
  Achievement(
    id: 'medal_all_continent',
    title: 'Continental Champion',
    description: 'Earn gold on every country in one continent',
    icon: Icons.public,
    color: Colors.amber,
  ),

  // ─── Exploration ───────────────────────────────────────────────────
  Achievement(
    id: 'explore_10',
    title: 'Curious Traveler',
    description: 'Explore 10 different countries',
    icon: Icons.travel_explore,
    color: Colors.blue,
  ),
  Achievement(
    id: 'explore_50',
    title: 'Seasoned Explorer',
    description: 'Explore 50 different countries',
    icon: Icons.travel_explore,
    color: Colors.blue,
  ),
  Achievement(
    id: 'explore_all_continents',
    title: 'World Traveler',
    description: 'Explore at least one country on every continent',
    icon: Icons.flight,
    color: Colors.indigo,
  ),
  Achievement(
    id: 'explore_100',
    title: 'Atlas Master',
    description: 'Explore 100 different countries',
    icon: Icons.auto_awesome,
    color: Colors.indigo,
  ),

  // ─── US State Flags ────────────────────────────────────────────────
  Achievement(
    id: 'us_flag_streak_10',
    title: 'State Flag Spotter',
    description: 'Get a 10-streak on US state flags',
    icon: Icons.flag,
    color: Colors.red,
  ),
  Achievement(
    id: 'us_flag_streak_25',
    title: 'Vexillologist',
    description: 'Get a 25-streak on US state flags',
    icon: Icons.flag,
    color: Colors.red,
  ),
  Achievement(
    id: 'us_speed_20',
    title: 'Speed Demon',
    description: 'Score 20+ in the US State Flag speed round',
    icon: Icons.speed,
    color: Colors.red,
  ),
  Achievement(
    id: 'us_speed_40',
    title: 'Lightning Fast',
    description: 'Score 40+ in the US State Flag speed round',
    icon: Icons.flash_on,
    color: Colors.yellow,
  ),

  // ─── Subdivision quizzes ───────────────────────────────────────────
  Achievement(
    id: 'sub_quiz_5_countries',
    title: 'Deep Diver',
    description: 'Complete state quizzes for 5 different countries',
    icon: Icons.scuba_diving,
    color: Colors.teal,
  ),

  // ─── Teacher mode ──────────────────────────────────────────────────
  Achievement(
    id: 'teacher_10',
    title: 'Classroom Hero',
    description: 'Quiz someone 10 times in teacher mode',
    icon: Icons.school,
    color: Colors.orange,
  ),
  Achievement(
    id: 'teacher_50',
    title: 'Professor',
    description: 'Quiz someone 50 times in teacher mode',
    icon: Icons.school,
    color: Colors.orange,
  ),

  // ─── Map ───────────────────────────────────────────────────────────
  Achievement(
    id: 'map_search',
    title: 'Navigator',
    description: 'Use the search on the World Map',
    icon: Icons.search,
    color: Colors.purple,
  ),
  Achievement(
    id: 'map_all_continents_zoomed',
    title: 'Zoom Master',
    description: 'Zoom to every continent on the map',
    icon: Icons.zoom_in_map,
    color: Colors.purple,
  ),
  Achievement(
    id: 'state_map_viewed',
    title: 'Cartographer',
    description: 'View a country\'s state/province map',
    icon: Icons.zoom_in_map,
    color: Colors.teal,
  ),

  // ─── Fun / secret ──────────────────────────────────────────────────
  Achievement(
    id: 'play_all_modes',
    title: 'Jack of All Trades',
    description: 'Try every quiz mode in the app',
    icon: Icons.star,
    color: Colors.deepPurple,
  ),
  Achievement(
    id: 'night_owl',
    title: 'Night Owl',
    description: 'Use the app after 10 PM',
    icon: Icons.nightlight_round,
    color: Colors.indigo,
    secret: true,
  ),
  Achievement(
    id: 'early_bird',
    title: 'Early Bird',
    description: 'Use the app before 7 AM',
    icon: Icons.wb_sunny,
    color: Colors.orange,
    secret: true,
  ),
  Achievement(
    id: 'antarctica_found',
    title: 'Ice Explorer',
    description: 'Find and tap Antarctica on the map',
    icon: Icons.ac_unit,
    color: Colors.lightBlue,
    secret: true,
  ),
  Achievement(
    id: 'perfect_10',
    title: 'Perfect Score',
    description: 'Get 10/10 on a country with extended facts',
    icon: Icons.diamond,
    color: Colors.cyan,
    secret: true,
  ),
];

/// Lookup by ID.
final Map<String, Achievement> achievementById = {
  for (final a in allAchievements) a.id: a,
};
