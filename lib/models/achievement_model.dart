/// Achievement and Badge Models
import 'package:equatable/equatable.dart';

class Achievement extends Equatable {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int points;
  final AchievementType type;
  final DateTime unlockedDate;
  final bool isUnlocked;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.points,
    required this.type,
    required this.unlockedDate,
    required this.isUnlocked,
  });

  @override
  List<Object?> get props => [id, title, description, icon, points, type, unlockedDate, isUnlocked];
}

enum AchievementType {
  firstWin,
  tenWins,
  hundred,
  speedDemon,
  perfectSolution,
  easyMastery,
  mediumMastery,
  hardMastery,
  sevenDayStreak,
  thirtyDayStreak,
  bugHunter,
  codesmith,
  teamPlayer,
}

class Badge extends Equatable {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final int rarity; // 1-5 stars

  const Badge({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.rarity,
  });

  @override
  List<Object?> get props => [id, name, emoji, description, rarity];
}
