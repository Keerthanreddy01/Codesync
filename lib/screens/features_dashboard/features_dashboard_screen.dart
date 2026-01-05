/// Features Dashboard - Overview of All Unique Features
import 'package:flutter/material.dart';
import 'package:codesync_arena/config/app_colors.dart';
import 'package:codesync_arena/config/app_text_styles.dart';
import 'package:codesync_arena/widgets/ultrahuman_card.dart';
import '../achievements/achievements_screen.dart';
import '../weekly_challenges/weekly_challenges_screen.dart';
import '../skill_rating/skill_rating_screen.dart';
import '../problem_creator/problem_creator_screen.dart';

class FeaturesDashboardScreen extends StatelessWidget {
  const FeaturesDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'FEATURES',
          style: AppTextStyles.heading3.copyWith(
            color: AppColors.textPrimary,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFeatureTile(
              context,
              emoji: '🏅',
              title: 'Achievements & Badges',
              description: 'Unlock badges, track streaks, and view performance stats',
              features: [
                '🎯 13+ unique achievement types',
                '🔥 Streak tracking system',
                '📊 Performance analytics',
              ],
              color: Colors.amber,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AchievementsScreen()),
              ),
            ),
            const SizedBox(height: 16),
            _buildFeatureTile(
              context,
              emoji: '⚡',
              title: 'Weekly Challenges',
              description: 'Limited-time coding challenges with double rewards',
              features: [
                '📅 New problems every week',
                '🏆 Live leaderboards',
                '💰 Bonus XP rewards',
              ],
              color: Colors.deepOrange,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WeeklyChallengesScreen()),
              ),
            ),
            const SizedBox(height: 16),
            _buildFeatureTile(
              context,
              emoji: '📈',
              title: 'Skill Rating System',
              description: 'ELO-based rating system with rank progression',
              features: [
                '👑 6 rank tiers (Bronze to Grandmaster)',
                '1️⃣ Range: 1200 - 3000 rating',
                '📊 Match history & analytics',
              ],
              color: Colors.blue,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SkillRatingScreen()),
              ),
            ),
            const SizedBox(height: 16),
            _buildFeatureTile(
              context,
              emoji: '✏️',
              title: 'Problem Creator',
              description: 'Design and share custom coding challenges',
              features: [
                '🎨 Create custom problems',
                '🧪 Add multiple test cases',
                '👥 Share with community',
              ],
              color: Colors.purple,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProblemCreatorScreen()),
              ),
            ),
            const SizedBox(height: 32),

            // Feature Highlights
            Text(
              'Why CodeSync Stands Out',
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            UltrahumanCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildHighlight(
                    '🎯',
                    'Comprehensive Achievement System',
                    'Track progress across 13 different achievement types',
                  ),
                  const SizedBox(height: 16),
                  _buildHighlight(
                    '⚡',
                    'Dynamic Weekly Challenges',
                    'Fresh coding challenges every week with community leaderboards',
                  ),
                  const SizedBox(height: 16),
                  _buildHighlight(
                    '📊',
                    'Advanced Analytics',
                    'Track wins, solve times, accuracy, and improvement trends',
                  ),
                  const SizedBox(height: 16),
                  _buildHighlight(
                    '👥',
                    'Community-Driven Content',
                    'Create and share custom problems with the CodeSync community',
                  ),
                  const SizedBox(height: 16),
                  _buildHighlight(
                    '🏆',
                    'Competitive Ranking',
                    'ELO-based rating system with visible rank progression',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTile(
    BuildContext context, {
    required String emoji,
    required String title,
    required String description,
    required List<String> features,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: UltrahumanCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: AppColors.border),
            const SizedBox(height: 12),
            ...features.map(
              (feature) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color.withOpacity(0.2),
                  foregroundColor: color,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: color),
                  ),
                ),
                onPressed: onTap,
                child: const Text(
                  'Explore',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlight(String emoji, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
