/// Weekly Challenges - Time-Limited Competitive Problems
import 'package:flutter/material.dart';
import 'package:codesync_arena/config/app_colors.dart';
import 'package:codesync_arena/config/app_text_styles.dart';
import 'package:codesync_arena/widgets/ultrahuman_card.dart';

class WeeklyChallengesScreen extends StatefulWidget {
  const WeeklyChallengesScreen({super.key});

  @override
  State<WeeklyChallengesScreen> createState() => _WeeklyChallengesScreenState();
}

class _WeeklyChallengesScreenState extends State<WeeklyChallengesScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final challenges = [
      {
        'title': 'Reverse Binary String',
        'difficulty': 'Medium',
        'reward': '500 XP',
        'timeLeft': '5 days 14 hrs',
        'participants': 1240,
        'topScore': 98,
        'description': 'Reverse a binary representation of a number.',
      },
      {
        'title': 'Optimal Path Sum',
        'difficulty': 'Hard',
        'reward': '800 XP',
        'timeLeft': '2 days 8 hrs',
        'participants': 892,
        'topScore': 95,
        'description': 'Find the path with maximum sum in a matrix.',
      },
      {
        'title': 'String Compression',
        'difficulty': 'Easy',
        'reward': '300 XP',
        'timeLeft': 'Ends soon',
        'participants': 2156,
        'topScore': 100,
        'description': 'Compress a string by counting consecutive characters.',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'WEEKLY CHALLENGES',
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
            // Active Challenge Carousel
            SizedBox(
              height: 280,
              child: PageView.builder(
                onPageChanged: (index) {
                  setState(() => selectedIndex = index);
                },
                itemCount: challenges.length,
                itemBuilder: (context, index) {
                  final challenge = challenges[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _buildChallengeCard(challenge),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Carousel Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                challenges.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == selectedIndex
                        ? AppColors.primary
                        : AppColors.border,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Leaderboard
            Text(
              'This Week\'s Leaderboard',
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildLeaderboard(),
            const SizedBox(height: 24),

            // Challenge Tips
            UltrahumanCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 Challenge Tips',
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTip('Optimize for both time and space complexity'),
                  const SizedBox(height: 8),
                  _buildTip('Write clean, readable code for bonus points'),
                  const SizedBox(height: 8),
                  _buildTip('Test edge cases before final submission'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeCard(Map<String, dynamic> challenge) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Solving: ${challenge['title']}')),
        );
      },
      child: UltrahumanCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(challenge['difficulty'])
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getDifficultyColor(challenge['difficulty']),
                    ),
                  ),
                  child: Text(
                    challenge['difficulty'],
                    style: AppTextStyles.caption.copyWith(
                      color: _getDifficultyColor(challenge['difficulty']),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  challenge['title'],
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  challenge['description'],
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reward',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                        Text(
                          challenge['reward'],
                          style: AppTextStyles.heading3.copyWith(
                            color: Colors.amber,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Time Left',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                        Text(
                          challenge['timeLeft'],
                          style: AppTextStyles.body2.copyWith(
                            color: challenge['timeLeft'] == 'Ends soon'
                                ? Colors.red
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Start Challenge',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboard() {
    final leaderboard = [
      ('🥇', 'ShadowCoder', 98, '${DateTime.now().subtract(const Duration(hours: 2)).toString().split(' ')[1].substring(0, 5)}'),
      ('🥈', 'AlgoMaster', 96, '${DateTime.now().subtract(const Duration(hours: 4)).toString().split(' ')[1].substring(0, 5)}'),
      ('🥉', 'ByteNinja', 94, '${DateTime.now().subtract(const Duration(hours: 6)).toString().split(' ')[1].substring(0, 5)}'),
      ('4️⃣', 'CodeWizard', 92, '${DateTime.now().subtract(const Duration(hours: 8)).toString().split(' ')[1].substring(0, 5)}'),
      ('5️⃣', 'You', 87, 'Just now'),
    ];

    return Column(
      children: leaderboard
          .map((entry) {
            final (medal, name, score, time) = entry;
            final isUser = name == 'You';

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primary.withOpacity(0.1) : AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isUser ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    medal,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          time,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '$score',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.primary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            );
          })
          .toList(),
    );
  }

  Widget _buildTip(String tip) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            tip,
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.amber;
      case 'hard':
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }
}
