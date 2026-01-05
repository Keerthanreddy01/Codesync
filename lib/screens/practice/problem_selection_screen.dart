/// Problem Selection Screen for Solo Practice
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import '../../widgets/ultrahuman_card.dart';
import 'solo_practice_screen.dart';

class ProblemSelectionScreen extends ConsumerWidget {
  const ProblemSelectionScreen({super.key});

  static const problems = [
    {
      'id': 'two-sum',
      'title': 'Two Sum',
      'description': 'Find two numbers that add up to a target value',
      'difficulty': 1,
      'timeEstimate': '15 min',
    },
    {
      'id': 'reverse-string',
      'title': 'Reverse String',
      'description': 'Reverse a string in-place',
      'difficulty': 1,
      'timeEstimate': '10 min',
    },
    {
      'id': 'valid-parentheses',
      'title': 'Valid Parentheses',
      'description': 'Check if parentheses are properly balanced',
      'difficulty': 2,
      'timeEstimate': '20 min',
    },
    {
      'id': 'merge-sorted-lists',
      'title': 'Merge Two Sorted Lists',
      'description': 'Merge two sorted linked lists into one',
      'difficulty': 2,
      'timeEstimate': '25 min',
    },
    {
      'id': 'binary-search',
      'title': 'Binary Search',
      'description': 'Find target value in sorted array',
      'difficulty': 2,
      'timeEstimate': '20 min',
    },
    {
      'id': 'longest-substring',
      'title': 'Longest Substring Without Repeating Characters',
      'description': 'Find the length of the longest substring',
      'difficulty': 3,
      'timeEstimate': '30 min',
    },
    {
      'id': 'three-sum',
      'title': 'Three Sum',
      'description': 'Find all triplets that sum to zero',
      'difficulty': 3,
      'timeEstimate': '35 min',
    },
    {
      'id': 'max-subarray',
      'title': 'Maximum Subarray',
      'description': 'Find contiguous subarray with largest sum',
      'difficulty': 3,
      'timeEstimate': '25 min',
    },
    {
      'id': 'coin-change',
      'title': 'Coin Change',
      'description': 'Find minimum coins needed to make amount',
      'difficulty': 4,
      'timeEstimate': '40 min',
    },
    {
      'id': 'word-break',
      'title': 'Word Break',
      'description': 'Check if string can be segmented into dictionary words',
      'difficulty': 4,
      'timeEstimate': '35 min',
    },
    {
      'id': 'lru-cache',
      'title': 'LRU Cache',
      'description': 'Implement Least Recently Used cache',
      'difficulty': 4,
      'timeEstimate': '45 min',
    },
    {
      'id': 'median-two-arrays',
      'title': 'Median of Two Sorted Arrays',
      'description': 'Find median of two sorted arrays',
      'difficulty': 5,
      'timeEstimate': '50 min',
    },
    {
      'id': 'regular-expression',
      'title': 'Regular Expression Matching',
      'description': 'Implement regex with . and * support',
      'difficulty': 5,
      'timeEstimate': '60 min',
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Select Problem',
          style: AppTextStyles.heading3.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: problems.length,
        itemBuilder: (context, index) {
          final problem = problems[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildProblemCard(context, problem),
          );
        },
      ),
    );
  }

  Widget _buildProblemCard(BuildContext context, Map<String, dynamic> problem) {
    final difficulty = problem['difficulty'] as int;
    Color difficultyColor;
    String difficultyText;

    if (difficulty <= 2) {
      difficultyColor = AppColors.success;
      difficultyText = 'Easy';
    } else if (difficulty == 3) {
      difficultyColor = AppColors.warning;
      difficultyText = 'Medium';
    } else {
      difficultyColor = AppColors.error;
      difficultyText = 'Hard';
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SoloPracticeScreen(
              problemId: problem['id'] as String,
              problemTitle: problem['title'] as String,
              problemDescription: problem['description'] as String,
              difficultyLevel: difficulty,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: UltrahumanCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Difficulty indicator
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: difficultyColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          problem['title'] as String,
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: difficultyColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          difficultyText,
                          style: AppTextStyles.caption.copyWith(
                            color: difficultyColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    problem['description'] as String,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        problem['timeEstimate'] as String,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      ...List.generate(
                        5,
                        (i) => Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i < difficulty
                                ? difficultyColor
                                : AppColors.border,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Arrow
            const SizedBox(width: 12),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
