/// Achievements Screen - Badges, Streaks, Milestones
import 'package:flutter/material.dart';
import 'package:codesync_arena/config/app_colors.dart';
import 'package:codesync_arena/config/app_text_styles.dart';
import 'package:codesync_arena/widgets/ultrahuman_card.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'ACHIEVEMENTS',
          style: AppTextStyles.heading3.copyWith(
            color: AppColors.textPrimary,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textTertiary,
          tabs: const [
            Tab(text: 'Badges'),
            Tab(text: 'Streaks'),
            Tab(text: 'Stats'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBadgesTab(),
          _buildStreaksTab(),
          _buildStatsTab(),
        ],
      ),
    );
  }

  Widget _buildBadgesTab() {
    final badges = [
      ('🎯', 'First Win', 'Win your first battle'),
      ('⚡', 'Speed Demon', 'Solve 3 problems under 5 mins'),
      ('✨', 'Perfect Code', 'All test cases pass'),
      ('🔥', '7-Day Streak', 'Code 7 days in a row'),
      ('👑', 'Master Solver', 'Solve 50 problems'),
      ('🧠', 'Algorithm Expert', 'Solve all hard problems'),
      ('🤝', 'Team Player', 'Win 5 team battles'),
      ('🐛', 'Bug Hunter', 'Fix 10 broken solutions'),
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        final (emoji, title, description) = badges[index];
        final isUnlocked = index < 4; // First 4 are unlocked

        return GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$emoji $title\n$description')),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: isUnlocked ? AppColors.surface : AppColors.surface.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isUnlocked ? AppColors.primary : AppColors.border,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 40),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
                if (!isUnlocked)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Icon(
                      Icons.lock,
                      color: AppColors.textTertiary,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStreaksTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Current Streak
          UltrahumanCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  '🔥 Current Streak',
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '12',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'days in a row',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                LinearProgressIndicator(
                  value: 0.75,
                  minHeight: 8,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Next milestone: 30 days',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Streak Records
          UltrahumanCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Streak Records',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildStreakItem('Longest Streak', '45 days', '🏆'),
                const SizedBox(height: 12),
                _buildStreakItem('Problems This Week', '18 solved', '⚡'),
                const SizedBox(height: 12),
                _buildStreakItem('Battles Won', '23 total', '🎯'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakItem(String label, String value, String icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        Text(
          value,
          style: AppTextStyles.heading3.copyWith(
            color: AppColors.primary,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Overall Stats
          UltrahumanCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overall Performance',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatBox('87', 'Problems\nSolved', AppColors.primary),
                    _buildStatBox('2045', 'Total\nPoints', Colors.amber),
                    _buildStatBox('23', 'Battles\nWon', Colors.green),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Skill Breakdown
          UltrahumanCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Difficulty Breakdown',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDifficultyBar('Easy', 45, 45, Colors.green),
                const SizedBox(height: 12),
                _buildDifficultyBar('Medium', 32, 40, Colors.amber),
                const SizedBox(height: 12),
                _buildDifficultyBar('Hard', 10, 25, Colors.red),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Speed Stats
          UltrahumanCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Speed Metrics',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildMetricRow('Avg. Time per Problem', '8:42 mins'),
                const SizedBox(height: 12),
                _buildMetricRow('Fastest Solution', '2:15 mins'),
                const SizedBox(height: 12),
                _buildMetricRow('Success Rate', '94.2%'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String number, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultyBar(String label, int solved, int total, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '$solved/$total',
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: solved / total,
            minHeight: 6,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.body2.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.heading3.copyWith(
            color: AppColors.primary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
