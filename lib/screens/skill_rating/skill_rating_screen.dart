/// Skill Rating and Performance Analytics
import 'package:flutter/material.dart';
import 'package:codesync_arena/config/app_colors.dart';
import 'package:codesync_arena/config/app_text_styles.dart';
import 'package:codesync_arena/widgets/ultrahuman_card.dart';

class SkillRatingScreen extends StatefulWidget {
  const SkillRatingScreen({super.key});

  @override
  State<SkillRatingScreen> createState() => _SkillRatingScreenState();
}

class _SkillRatingScreenState extends State<SkillRatingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'SKILL RATING',
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
          children: [
            // Rating Overview
            UltrahumanCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    'Current Rating',
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Large Rating Display
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withOpacity(0.6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '2145',
                            style: TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Platinum II',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Rating Tier Bar
                  _buildRatingTierBar(),
                  const SizedBox(height: 24),
                  // Next Rank Info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Next Rank: Diamond',
                              style: AppTextStyles.body1.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '155 points needed',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '📈',
                          style: const TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recent Matches
            UltrahumanCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Matches',
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildMatchResult('vs ShadowCoder', true, '+18'),
                  const SizedBox(height: 12),
                  _buildMatchResult('vs AlgoMaster', false, '-12'),
                  const SizedBox(height: 12),
                  _buildMatchResult('vs ByteNinja', true, '+25'),
                  const SizedBox(height: 12),
                  _buildMatchResult('vs CodeWizard', true, '+15'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Statistics
            UltrahumanCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Performance Metrics',
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildMetricBar('Win Rate', '67%', 0.67),
                  const SizedBox(height: 16),
                  _buildMetricBar('Accuracy', '89%', 0.89),
                  const SizedBox(height: 16),
                  _buildMetricBar('Solve Rate', '94%', 0.94),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Rank Distribution
            UltrahumanCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rank Distribution',
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildRankTile('Bronze', '🥉', 12),
                  const SizedBox(height: 8),
                  _buildRankTile('Silver', '⚪', 28),
                  const SizedBox(height: 8),
                  _buildRankTile('Gold', '🟡', 35),
                  const SizedBox(height: 8),
                  _buildRankTile('Platinum', '💜', 18),
                  const SizedBox(height: 8),
                  _buildRankTile('Diamond', '💎', 6),
                  const SizedBox(height: 8),
                  _buildRankTile('Grandmaster', '👑', 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingTierBar() {
    final tiers = [
      ('Bronze', Colors.orange[800]),
      ('Silver', Colors.grey[300]),
      ('Gold', Colors.amber),
      ('Platinum', Colors.purple[300]),
      ('Diamond', Colors.cyan),
      ('Grandmaster', Colors.red),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rating Range: 1200 - 3000',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: tiers.map((t) => t.$2!).toList(),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: '71.5%'.contains('%')
                      ? MediaQuery.of(context).size.width * 0.715
                      : 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 3,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '1200',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            Text(
              '2145 (You)',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '3000',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMatchResult(String opponent, bool won, String rating) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: won ? Colors.green.withOpacity(0.5) : Colors.red.withOpacity(0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                won ? '✅' : '❌',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    opponent,
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    won ? 'Victory' : 'Defeat',
                    style: AppTextStyles.caption.copyWith(
                      color: won ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: (won
                      ? Colors.green
                      : Colors.red)
                  .withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              rating,
              style: TextStyle(
                color: won ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBar(String label, String percentage, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              percentage,
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.primary,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildRankTile(String rank, String emoji, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 12),
            Text(
              rank,
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '$count players',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
