import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/achievement.dart';

const _prefsKey = 'flag_explorer_achievements';

/// Tracks achievement unlocks with persistence and toast notifications.
class AchievementService {
  AchievementService._();
  static final AchievementService instance = AchievementService._();

  final Set<String> _unlocked = {};
  bool _loaded = false;

  /// Global key for showing overlay toasts from anywhere.
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  Set<String> get unlocked => _unlocked;

  int get unlockedCount => _unlocked.length;
  int get totalCount => allAchievements.length;

  bool isUnlocked(String id) => _unlocked.contains(id);

  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_prefsKey);
    if (list != null) _unlocked.addAll(list);
    _loaded = true;

    // Check time-based achievements on load.
    final hour = DateTime.now().hour;
    if (hour >= 22) unlock('night_owl');
    if (hour < 7) unlock('early_bird');
  }

  /// Unlock an achievement. Shows a toast if newly unlocked.
  Future<bool> unlock(String id) async {
    if (_unlocked.contains(id)) return false;
    final achievement = achievementById[id];
    if (achievement == null) return false;

    _unlocked.add(id);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, _unlocked.toList());

    // Show toast
    _showToast(achievement);
    return true;
  }

  void _showToast(Achievement a) {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;

    final overlay = Overlay.of(ctx);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _AchievementToast(
        achievement: a,
        onDismiss: () => entry.remove(),
      ),
    );
    overlay.insert(entry);
  }
}

/// Animated toast that slides down from the top.
class _AchievementToast extends StatefulWidget {
  const _AchievementToast({
    required this.achievement,
    required this.onDismiss,
  });

  final Achievement achievement;
  final VoidCallback onDismiss;

  @override
  State<_AchievementToast> createState() => _AchievementToastState();
}

class _AchievementToastState extends State<_AchievementToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _controller.reverse().then((_) => widget.onDismiss());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.achievement;
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slide,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: a.color.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: a.color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(a.icon, color: a.color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '🏆 Achievement Unlocked!',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: a.color,
                        ),
                      ),
                      Text(
                        a.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        a.description,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
