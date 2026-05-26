import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _prefsKey = 'flag_explorer_players';
const _activeKey = 'flag_explorer_active_player';

/// A single player profile with best streaks per category.
class Player {
  Player({required this.name, Map<String, int>? bestStreaks})
      : bestStreaks = bestStreaks ?? {};

  final String name;

  /// Best streak keyed by a category tag (e.g. 'capital', 'flag', 'us_speed').
  final Map<String, int> bestStreaks;

  int bestFor(String category) => bestStreaks[category] ?? 0;

  /// Returns true if this is a new record.
  bool recordStreak(String category, int streak) {
    if (streak > bestFor(category)) {
      bestStreaks[category] = streak;
      return true;
    }
    return false;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'bestStreaks': bestStreaks,
      };

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        name: json['name'] as String,
        bestStreaks: (json['bestStreaks'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, v as int)) ??
            {},
      );
}

/// Manages player profiles persisted to SharedPreferences.
class PlayerService extends ChangeNotifier {
  PlayerService._();
  static final PlayerService instance = PlayerService._();

  List<Player> _players = [];
  Player? _active;
  bool _loaded = false;

  List<Player> get players => _players;
  Player? get active => _active;

  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null) {
      final list = (jsonDecode(raw) as List)
          .map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList();
      _players = list;
    }
    final activeName = prefs.getString(_activeKey);
    if (activeName != null) {
      _active = _players.where((p) => p.name == activeName).firstOrNull;
    }
    // Create a default player if none exist.
    if (_players.isEmpty) {
      _players.add(Player(name: 'Player 1'));
      _active = _players.first;
      await _save();
    }
    _active ??= _players.first;
    _loaded = true;
    notifyListeners();
  }

  Future<void> addPlayer(String name) async {
    if (_players.any((p) => p.name == name)) return;
    _players.add(Player(name: name));
    await _save();
    notifyListeners();
  }

  Future<void> switchTo(Player player) async {
    _active = player;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeKey, player.name);
    notifyListeners();
  }

  /// Record a streak for the active player. Returns true if new record.
  Future<bool> recordStreak(String category, int streak) async {
    if (_active == null) return false;
    final isNew = _active!.recordStreak(category, streak);
    if (isNew) await _save();
    notifyListeners();
    return isNew;
  }

  /// Get the active player's best for a category.
  int bestFor(String category) => _active?.bestFor(category) ?? 0;

  /// All players sorted by best for a given category (leaderboard).
  List<Player> leaderboard(String category) {
    final sorted = List<Player>.from(_players);
    sorted.sort(
        (a, b) => b.bestFor(category).compareTo(a.bestFor(category)));
    return sorted;
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(_players.map((p) => p.toJson()).toList());
    await prefs.setString(_prefsKey, json);
    if (_active != null) {
      await prefs.setString(_activeKey, _active!.name);
    }
  }
}
