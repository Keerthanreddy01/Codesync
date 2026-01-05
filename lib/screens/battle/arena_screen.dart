/// Arena Screen - Code Battle
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import '../../providers/battle_providers.dart';
import '../../providers/room_providers.dart';
import '../../providers/branch_providers.dart';
import '../../models/branch_model.dart';
import '../../widgets/collaborative_code_editor.dart';
import '../../widgets/member_status_indicator.dart';
import '../../widgets/branch_comparison_view.dart';

class ArenaScreen extends ConsumerStatefulWidget {
  final String battleId;

  const ArenaScreen({super.key, required this.battleId});

  @override
  ConsumerState<ArenaScreen> createState() => _ArenaScreenState();
}

class _ArenaScreenState extends ConsumerState<ArenaScreen> {
  Timer? _timer;
  bool _isRunningTests = false;
  bool _hasSubmitted = false;
  List<TestResult>? _testResults;
  bool _showBranchComparison = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentBattleIdProvider.notifier).state = widget.battleId;
      
      // Get current user's room/team
      final room = ref.read(currentRoomProvider).value;
      if (room != null) {
        // Set branch context for current team (using room.id as teamId)
        ref.read(currentBattleIdForBranchProvider.notifier).state = widget.battleId;
        ref.read(currentBranchIdProvider.notifier).state = room.id;
      }
      
      _startTimer();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
      
      final battle = ref.read(currentBattleProvider).value;
      if (battle != null && battle.getRemainingSeconds() <= 0) {
        _autoSubmit();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final battleAsync = ref.watch(currentBattleProvider);
    final problemAsync = ref.watch(currentProblemProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Battle Arena'),
        automaticallyImplyLeading: false,
        actions: [
          // Branch comparison toggle
          IconButton(
            icon: Icon(
              _showBranchComparison ? Icons.code : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _showBranchComparison = !_showBranchComparison;
              });
            },
            tooltip: _showBranchComparison ? 'Show Code Editor' : 'View All Branches',
          ),
          // Timer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: battleAsync.when(
                data: (battle) {
                  if (battle == null) return const Text('--:--');
                  final remaining = battle.getRemainingSeconds();
                  final minutes = remaining ~/ 60;
                  final seconds = remaining % 60;
                  final color = remaining < 60
                      ? AppColors.error
                      : remaining < 180
                          ? AppColors.warning
                          : AppColors.success;
                  
                  return Text(
                    '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                    style: AppTextStyles.heading3.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
                loading: () => const Text('--:--'),
                error: (_, __) => const Text('--:--'),
              ),
            ),
          ),
        ],
      ),
      body: problemAsync.when(
        data: (problem) {
          if (problem == null) {
            return const Center(child: Text('Loading problem...'));
          }
          return _buildArenaContent(problem);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildArenaContent(problem) {
    final room = ref.watch(currentRoomProvider).value;
    
    if (_showBranchComparison) {
      return const BranchComparisonView();
    }
    
    return Row(
      children: [
        // Problem Description Panel
        Expanded(
          flex: 2,
          child: Container(
            color: AppColors.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Problem Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border(
                      bottom: BorderSide(color: AppColors.border),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              problem.title,
                              style: AppTextStyles.heading3.copyWith(
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getDifficultyColor(problem.difficulty),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              problem.difficulty,
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Problem Description
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          problem.description,
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 8,
                        ),
                        const SizedBox(height: 24),
                        
                        // Test Cases
                        Text(
                          'Test Cases',
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...problem.testCases.where((tc) => !tc.isHidden).map((tc) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    'Input: ${tc.input}',
                                    style: AppTextStyles.body2.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    'Expected: ${tc.expectedOutput}',
                                    style: AppTextStyles.body2.copyWith(
                                      color: AppColors.success,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Code Editor Panel
        Expanded(
          flex: 3,
          child: Column(
            children: [
              // Editor Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border(
                    bottom: BorderSide(color: AppColors.border),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.code, size: 20, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Code Editor',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    if (_hasSubmitted)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'SUBMITTED',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Code Editor
              Expanded(
                flex: 3,
                child: CollaborativeCodeEditor(
                  readOnly: _hasSubmitted,
                ),
              ),

              // Console/Results Panel
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border(
                      top: BorderSide(color: AppColors.border),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'Test Results',
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _testResults == null
                            ? Center(
                                child: Text(
                                  'Run tests to see results',
                                  style: AppTextStyles.body2.copyWith(
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                itemCount: _testResults!.length,
                                itemBuilder: (context, index) {
                                  final result = _testResults![index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: result.passed
                                            ? AppColors.success
                                            : AppColors.error,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          result.passed ? Icons.check_circle : Icons.cancel,
                                          color: result.passed
                                              ? AppColors.success
                                              : AppColors.error,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Test ${index + 1}: ${result.passed ? "PASSED" : "FAILED"}',
                                                style: AppTextStyles.body2.copyWith(
                                                  color: AppColors.textPrimary,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              if (!result.passed) ...[
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Expected: ${result.expectedOutput}',
                                                  style: AppTextStyles.caption.copyWith(
                                                    color: AppColors.textSecondary,
                                                  ),
                                                ),
                                                Text(
                                                  'Got: ${result.actualOutput}',
                                                  style: AppTextStyles.caption.copyWith(
                                                    color: AppColors.error,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              // Action Buttons
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isRunningTests || _hasSubmitted ? null : _runTests,
                        icon: _isRunningTests
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.play_arrow),
                        label: const Text('Run Tests'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _hasSubmitted ? null : _submitSolution,
                        icon: const Icon(Icons.send),
                        label: const Text('Submit Solution'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Right Sidebar - Team Members
        if (room != null)
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                left: BorderSide(color: AppColors.border),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border(
                      bottom: BorderSide(color: AppColors.border),
                    ),
                  ),
                  child: Text(
                    'Your Team',
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: MemberStatusIndicator(
                      battleId: widget.battleId,
                      teamId: room.id,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _runTests() async {
    setState(() {
      _isRunningTests = true;
      _testResults = null;
    });

    try {
      final battleActions = ref.read(battleActionsProvider);
      final branchActions = ref.read(branchActionsProvider);
      final currentUserId = ref.read(currentUserIdProvider) ?? 'user123';
      
      // Update status to testing
      await branchActions.updateStatus(
        userId: currentUserId,
        status: MemberStatus.testing,
        isTyping: false,
      );
      
      final results = await battleActions.runTests();
      
      // Update branch test stats
      final passed = results.where((r) => r.passed).length;
      final failed = results.where((r) => !r.passed).length;
      await branchActions.updateTestStats(passed: passed, failed: failed);

      setState(() {
        _testResults = results;
        _isRunningTests = false;
      });
      
      // Reset status to idle
      await branchActions.updateStatus(
        userId: currentUserId,
        status: MemberStatus.idle,
        isTyping: false,
      );
    } catch (e) {
      setState(() => _isRunningTests = false);
      
      // Reset status on error
      final currentUserId = ref.read(currentUserIdProvider) ?? 'user123';
      final branchActions = ref.read(branchActionsProvider);
      await branchActions.updateStatus(
        userId: currentUserId,
        status: MemberStatus.idle,
        isTyping: false,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _submitSolution() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Solution'),
        content: const Text(
          'Are you sure you want to submit? You cannot edit your code after submission.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Submit'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final userId = ref.read(currentUserIdProvider) ?? 'user123';
        final battleActions = ref.read(battleActionsProvider);
        final branchActions = ref.read(branchActionsProvider);
        
        // Submit the branch (locks it)
        await branchActions.submitBranch(userId);
        
        // Update member status
        await branchActions.updateStatus(
          userId: userId,
          status: MemberStatus.submitted,
          isTyping: false,
        );
        
        // Submit to battle service
        await battleActions.submitSolution(userId);

        setState(() => _hasSubmitted = true);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Solution submitted!'),
              backgroundColor: AppColors.success,
            ),
          );

          // Check if all branches submitted (handled by submitBranch)
          // For now just navigate based on battle completion
          await Future.delayed(const Duration(seconds: 1));
          
          final battle = await ref.read(currentBattleProvider.future);
          if (battle != null && battle.haveAllSubmitted()) {
            await battleActions.completeBattle();
            Navigator.pushReplacementNamed(
              context,
              '/battle/results',
              arguments: widget.battleId,
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _autoSubmit() async {
    if (_hasSubmitted) return;

    try {
      final userId = ref.read(currentUserIdProvider) ?? 'user123';
      final battleActions = ref.read(battleActionsProvider);
      
      await battleActions.submitSolution(userId);

      setState(() => _hasSubmitted = true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Time\'s up! Solution auto-submitted'),
            backgroundColor: AppColors.warning,
          ),
        );

        final battle = await ref.read(currentBattleProvider.future);
        if (battle != null && battle.haveAllSubmitted()) {
          await battleActions.completeBattle();
          Navigator.pushReplacementNamed(
            context,
            '/battle/results',
            arguments: battle.id,
          );
        }
      }
    } catch (e) {
      // Silent fail on auto-submit
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppColors.success;
      case 'medium':
        return AppColors.warning;
      case 'hard':
        return AppColors.error;
      default:
        return AppColors.info;
    }
  }
}
