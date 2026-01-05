/// Solo Practice Screen - Comprehensive Battle Mode
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:codesync_arena/config/app_colors.dart';
import 'package:codesync_arena/config/app_text_styles.dart';
import 'package:codesync_arena/widgets/ultrahuman_card.dart';
import 'package:codesync_arena/widgets/ultrahuman_buttons.dart';
import 'package:codesync_arena/services/battle_analytics_service.dart';
import 'package:codesync_arena/services/feature_flags_service.dart';

class SoloPracticeScreen extends ConsumerStatefulWidget {
  final String problemId;
  final String problemTitle;
  final String problemDescription;
  final int difficultyLevel; // 1-5

  const SoloPracticeScreen({
    super.key,
    required this.problemId,
    required this.problemTitle,
    required this.problemDescription,
    required this.difficultyLevel,
  });

  @override
  ConsumerState<SoloPracticeScreen> createState() => _SoloPracticeScreenState();
}

class _SoloPracticeScreenState extends ConsumerState<SoloPracticeScreen> {
  late DateTime _startTime;
  String _code = '';
  int _keystrokeCount = 0;
  List<bool> _testResults = [];
  bool _submitted = false;
  int _currentTab = 0; // 0: Editor, 1: Analytics, 2: Replay

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final flagsState = ref.watch(featureFlagProvider);
    final analyticsService = ref.watch(battleAnalyticsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Top Status Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                bottom: BorderSide(color: AppColors.border, width: 0.5),
              ),
            ),
            child: _buildStatusBar(analyticsService),
          ),

          // Main Content Area
          Expanded(
            child: IndexedStack(
              index: _currentTab,
              children: [
                // Editor Tab
                _buildEditorTab(),

                // Analytics Tab
                if (flagsState.isEnabled(Feature.advancedJudging))
                  _buildAnalyticsTab(analyticsService),

                // Replay Tab
                if (flagsState.isEnabled(Feature.fullReplayEngine))
                  _buildReplayTab(),
              ],
            ),
          ),

          // Bottom Action Bar
          _buildBottomActionBar(analyticsService, flagsState),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Text(
        widget.problemTitle,
        style: AppTextStyles.heading3.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Text(
              _formatDuration(DateTime.now().difference(_startTime)),
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
                fontFamily: 'JetBrains Mono',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBar(BattleAnalyticsService analyticsService) {
    final velocity = analyticsService.calculateTypingVelocity(
      userId: 'user_solo',
      totalKeystrokes: _keystrokeCount,
      totalLinesModified: _code.split('\n').length,
      elapsedTime: DateTime.now().difference(_startTime),
    );

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DIFFICULTY',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: List.generate(
                  5,
                  (i) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i < widget.difficultyLevel
                          ? AppColors.warning
                          : AppColors.border,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'TYPING SPEED',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${velocity.keystrokesPerSecond.toStringAsFixed(1)} keys/s',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'TEST RESULTS',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${_testResults.where((r) => r).length}/${_testResults.length}',
                style: AppTextStyles.body2.copyWith(
                  color: _testResults.isNotEmpty &&
                          _testResults.where((r) => r).length ==
                              _testResults.length
                      ? AppColors.success
                      : AppColors.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEditorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Problem Description
          UltrahumanCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PROBLEM',
                  style: AppTextStyles.captionBold.copyWith(
                    color: AppColors.textTertiary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.problemDescription,
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Code Editor Placeholder
          UltrahumanCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CODE EDITOR',
                  style: AppTextStyles.captionBold.copyWith(
                    color: AppColors.textTertiary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      _keystrokeCount += 1;
                      _code = value;
                    },
                    maxLines: 12,
                    minLines: 12,
                    style: AppTextStyles.code.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Write your solution here...',
                      hintStyle: AppTextStyles.code.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Test Results
          UltrahumanCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TEST RESULTS',
                  style: AppTextStyles.captionBold.copyWith(
                    color: AppColors.textTertiary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                if (_testResults.isEmpty)
                  Text(
                    'Run tests to see results',
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  )
                else
                  ...List.generate(
                    _testResults.length,
                    (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            _testResults[i]
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: _testResults[i]
                                ? AppColors.success
                                : AppColors.error,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Test Case ${i + 1}',
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab(BattleAnalyticsService analyticsService) {
    final judgment = analyticsService.judgeSubmission(
      code: _code,
      testResults: _testResults,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Judgment Breakdown
          UltrahumanCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'JUDGMENT',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${judgment.totalScore.toStringAsFixed(0)}/100',
                        style: AppTextStyles.button.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildJudgmentMetric('Syntax', judgment.syntaxScore),
                _buildJudgmentMetric('Semantics', judgment.semanticScore),
                _buildJudgmentMetric('Complexity', judgment.complexityScore),
                _buildJudgmentMetric('Style', judgment.styleScore),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.info.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    judgment.explanation,
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.info,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReplayTab() {
    return Center(
      child: UltrahumanCard(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.play_circle_outline,
              size: 64,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Replay Engine Ready',
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your battle will be available for replay after submission',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionBar(
    BattleAnalyticsService analyticsService,
    FeatureFlagState flagsState,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SecondaryButton(
              label: 'Run Tests',
              onPressed: () {
                setState(() {
                  _testResults = [true, false, true, true, false];
                });
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: PrimaryButton(
              label: _submitted ? 'Submitted ✓' : 'Submit',
              onPressed: _submitted
                  ? () {}
                  : () {
                      setState(() {
                        _submitted = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Solution submitted!'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJudgmentMetric(String label, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value / 25,
                minHeight: 8,
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getColorForScore(value),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${value.toStringAsFixed(1)}/25',
            style: AppTextStyles.caption.copyWith(
              color: _getColorForScore(value),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForScore(double score) {
    if (score < 8) return AppColors.error;
    if (score < 16) return AppColors.warning;
    return AppColors.success;
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
