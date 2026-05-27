import 'package:flutter/material.dart';

import '../models/achievement.dart';
import '../services/achievement_service.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = AchievementService.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text('Achievements (${svc.unlockedCount}/${svc.totalCount})'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: allAchievements.length,
        separatorBuilder: (_, _) => const SizedBox(height: 6),
        itemBuilder: (_, i) {
          final a = allAchievements[i];
          final unlocked = svc.isUnlocked(a.id);
          final hidden = a.secret && !unlocked;

          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            color: unlocked ? a.color.withValues(alpha: 0.08) : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: unlocked
                          ? a.color.withValues(alpha: 0.2)
                          : Colors.grey.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      hidden ? Icons.lock : a.icon,
                      color: unlocked ? a.color : Colors.grey,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hidden ? '???' : a.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: unlocked ? a.color : Colors.grey[700],
                          ),
                        ),
                        Text(
                          hidden ? 'Secret achievement' : a.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (unlocked)
                    const Icon(Icons.check_circle, color: Colors.green, size: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
