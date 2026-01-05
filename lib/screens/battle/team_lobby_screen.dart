/// Team Lobby Screen - Waiting room before battle
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import '../../providers/room_providers.dart';
import '../../providers/battle_providers.dart';
import '../../providers/branch_providers.dart';
import '../../models/room_model.dart';

class TeamLobbyScreen extends ConsumerStatefulWidget {
  final String roomId;

  const TeamLobbyScreen({super.key, required this.roomId});

  @override
  ConsumerState<TeamLobbyScreen> createState() => _TeamLobbyScreenState();
}

class _TeamLobbyScreenState extends ConsumerState<TeamLobbyScreen> {
  bool _isStarting = false;

  @override
  void initState() {
    super.initState();
    // Set current room
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentRoomIdProvider.notifier).state = widget.roomId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final roomAsync = ref.watch(currentRoomProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Lobby'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _leaveRoom,
        ),
      ),
      body: roomAsync.when(
        data: (room) {
          if (room == null) {
            return const Center(child: Text('Room not found'));
          }
          return _buildLobbyContent(room);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildLobbyContent(RoomModel room) {
    final userId = ref.read(currentUserIdProvider) ?? 'user123';
    final isHost = room.isHost(userId);
    final isReady = room.isUserReady(userId);
    final allReady = room.areAllReady();

    return Column(
      children: [
        // Room Code Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          color: AppColors.surface,
          child: Column(
            children: [
              Text(
                'Room Code',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    room.code,
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 8,
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: room.code));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Code copied!')),
                      );
                    },
                  ),
                ],
              ),
              Text(
                'Share this code with your team',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Participants List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: room.participantIds.length,
            itemBuilder: (context, index) {
              final participantId = room.participantIds[index];
              final isParticipantReady = room.isUserReady(participantId);
              final isParticipantHost = room.isHost(participantId);

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isParticipantReady
                        ? AppColors.success
                        : AppColors.textTertiary,
                    child: Icon(
                      isParticipantReady ? Icons.check : Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    participantId == userId ? 'You' : 'Player $index',
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    isParticipantHost ? 'Host' : 'Member',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  trailing: isParticipantReady
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'READY',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.textTertiary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'NOT READY',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              );
            },
          ),
        ),

        // Bottom Actions
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
              // Ready Button (for non-hosts)
              if (!isHost)
                ElevatedButton(
                  onPressed: () => _toggleReady(!isReady),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isReady ? AppColors.warning : AppColors.success,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: Text(isReady ? 'Not Ready' : 'Ready'),
                ),

              // Start Battle Button (for host only)
              if (isHost) ...[
                ElevatedButton(
                  onPressed: allReady && !_isStarting ? _startBattle : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: _isStarting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Start Battle'),
                ),
                if (!allReady)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Waiting for all members to be ready',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
              ],

              const SizedBox(height: 8),

              // Leave Room Button
              OutlinedButton(
                onPressed: _leaveRoom,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: AppColors.error),
                  foregroundColor: AppColors.error,
                ),
                child: const Text('Leave Room'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _toggleReady(bool ready) async {
    try {
      final roomActions = ref.read(roomActionsProvider);
      await roomActions.toggleReady(ready);
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

  Future<void> _startBattle() async {
    setState(() => _isStarting = true);

    try {
      final room = await ref.read(currentRoomProvider.future);
      if (room == null) throw Exception('Room not found');

      // Show countdown
      await _showCountdown();

      // Start battle
      final battleActions = ref.read(battleActionsProvider);
      final battle = await battleActions.startBattle(
        room.id,
        room.participantIds,
      );
      
      // Create branches for each team
      final branchActions = ref.read(branchActionsProvider);
      final problem = await ref.read(currentProblemProvider.future);
      
      // Group participants by team (using room.id as teamId)
      final teams = <String, List<String>>{
        room.id: room.participantIds,
      };
      
      await branchActions.createBranchesForBattle(
        battleId: battle.id,
        teams: teams,
        starterCode: problem?.starterCode ?? '// Start coding here...',
      );

      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/battle/arena',
          arguments: battle.id,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isStarting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _showCountdown() async {
    for (int i = 3; i > 0; i--) {
      if (!mounted) return;
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                '$i',
                style: AppTextStyles.heading1.copyWith(
                  fontSize: 64,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),
      );

      await Future.delayed(const Duration(seconds: 1));
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _leaveRoom() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Room'),
        content: const Text('Are you sure you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Leave'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final roomActions = ref.read(roomActionsProvider);
        await roomActions.leaveRoom();

        if (mounted) {
          Navigator.pop(context);
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
}
