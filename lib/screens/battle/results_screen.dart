/// Results Screen - Battle Results
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import '../../providers/battle_providers.dart';
import '../../providers/room_providers.dart';

class ResultsScreen extends ConsumerWidget {
  final String battleId;

  const ResultsScreen({super.key, required this.battleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Set battle ID
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentBattleIdProvider.notifier).state = battleId;
    });

    final battleAsync = ref.watch(currentBattleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Battle Results'),
        automaticallyImplyLeading: false,
      ),
      body: battleAsync.when(
        data: (battle) {
          if (battle == null) {
            return const Center(child: Text('Battle not found'));
          }
          return _buildResultsContent(context, ref, battle);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildResultsContent(BuildContext context, WidgetRef ref, battle) {
    // Calculate winner
    final sortedParticipants = battle.participantIds.toList()
      ..sort((a, b) {
        final scoreA = battle.scores[a] ?? 0;
        final scoreB = battle.scores[b] ?? 0;
        return scoreB.compareTo(scoreA);
      });

    final winnerId = sortedParticipants.first;
    final winnerScore = battle.scores[winnerId] ?? 0;

    return Column(
      children: [
        // Winner Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.8),
                AppColors.secondary.withOpacity(0.8),
              ],
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.emoji_events,
                size: 80,
                color: Colors.amber,
              ),
              const SizedBox(height: 16),
              Text(
                'Battle Complete!',
                style: AppTextStyles.heading2.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Winner: Player ${sortedParticipants.indexOf(winnerId) + 1}',
                style: AppTextStyles.heading3.copyWith(
                  color: Colors.white,
                ),
              ),
              Text(
                'Score: $winnerScore points',
                style: AppTextStyles.body1.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),

        // Leaderboard
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sortedParticipants.length,
            itemBuilder: (context, index) {
              final participantId = sortedParticipants[index];
              final score = battle.scores[participantId] ?? 0;
              final hasSubmitted = battle.hasUserSubmitted(participantId);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: index == 0
                        ? Colors.amber
                        : index == 1
                            ? Colors.grey[400]
                            : index == 2
                                ? Colors.brown[300]
                                : AppColors.primary,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    'Player ${index + 1}',
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    hasSubmitted ? 'Submitted' : 'Did not submit',
                    style: AppTextStyles.caption.copyWith(
                      color: hasSubmitted
                          ? AppColors.success
                          : AppColors.textTertiary,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$score',
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        'points',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
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
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _viewCodeDiff(context, battle),
                      icon: const Icon(Icons.code),
                      label: const Text('View Code Diff'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _rematch(context, ref, battle),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Rematch'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => _backToHome(context, ref),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _viewCodeDiff(BuildContext context, battle) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Code Submissions',
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: battle.participantIds.length,
                  itemBuilder: (context, index) {
                    final participantId = battle.participantIds[index];
                    final code = battle.submissions[participantId] ?? 'No submission';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Player ${index + 1}',
                              style: AppTextStyles.body1.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              code,
                              style: AppTextStyles.code.copyWith(
                                color: AppColors.textSecondary,
                              ),
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
    );
  }

  Future<void> _rematch(BuildContext context, WidgetRef ref, battle) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rematch'),
        content: const Text(
          'Start a new battle with the same players?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Start Rematch'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // Create new room with same participants
        final roomActions = ref.read(roomActionsProvider);
        final newRoom = await roomActions.createRoom();

        // Navigate to lobby
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/room/lobby',
          (route) => false,
          arguments: newRoom.id,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('New room created! Code: ${newRoom.code}'),
            backgroundColor: AppColors.success,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _backToHome(BuildContext context, WidgetRef ref) {
    // Clear state
    ref.read(currentBattleIdProvider.notifier).state = null;
    ref.read(currentRoomIdProvider.notifier).state = null;

    // Navigate to home
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) => false,
    );
  }
}
