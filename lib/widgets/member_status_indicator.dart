/// Member Status Indicator - Shows real-time member activity
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../models/branch_model.dart';
import '../providers/branch_providers.dart';

class MemberStatusIndicator extends ConsumerWidget {
  final String battleId;
  final String teamId;
  final bool compact;

  const MemberStatusIndicator({
    super.key,
    required this.battleId,
    required this.teamId,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Set battle and team context
    ref.read(currentBattleIdForBranchProvider.notifier).state = battleId;
    ref.read(currentBranchIdProvider.notifier).state = teamId;

    final branchAsync = ref.watch(currentBranchProvider);

    return branchAsync.when(
      data: (branch) {
        if (branch == null) {
          return const SizedBox.shrink();
        }

        final members = branch.members.values.toList();

        if (compact) {
          return _buildCompactView(members);
        }

        return _buildFullView(members);
      },
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildCompactView(List<BranchMember> members) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: members.map((member) {
        return Padding(
          padding: const EdgeInsets.only(right: 4),
          child: _buildStatusDot(member),
        );
      }).toList(),
    );
  }

  Widget _buildFullView(List<BranchMember> members) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Team Members',
          style: AppTextStyles.body2.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...members.map((member) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildMemberRow(member),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildMemberRow(BranchMember member) {
    return Row(
      children: [
        _buildStatusIndicator(member),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member.username,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _getStatusText(member),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (member.isTyping) _buildTypingAnimation(),
      ],
    );
  }

  Widget _buildStatusIndicator(BranchMember member) {
    final isActive = member.isActive();
    final color = _getStatusColor(member.status);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer ring for active/typing
        if (isActive || member.isTyping)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 2,
              ),
            ),
          ),
        // Inner circle
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.2),
          ),
          child: Center(
            child: _getStatusIcon(member.status),
          ),
        ),
        // Pulsing dot for typing
        if (member.isTyping) _buildPulsingDot(color),
      ],
    );
  }

  Widget _buildStatusDot(BranchMember member) {
    final color = _getStatusColor(member.status);
    
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: member.isTyping
          ? Center(
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildPulsingDot(Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.5, end: 1.0),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
        );
      },
      onEnd: () {
        // Animation loops automatically via TweenAnimationBuilder
      },
    );
  }

  Widget _buildTypingAnimation() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTypingDot(0),
        const SizedBox(width: 2),
        _buildTypingDot(200),
        const SizedBox(width: 2),
        _buildTypingDot(400),
      ],
    );
  }

  Widget _buildTypingDot(int delayMs) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(MemberStatus status) {
    switch (status) {
      case MemberStatus.idle:
        return AppColors.textTertiary;
      case MemberStatus.typing:
        return AppColors.primary;
      case MemberStatus.testing:
        return AppColors.info;
      case MemberStatus.submitted:
        return AppColors.success;
    }
  }

  Icon _getStatusIcon(MemberStatus status) {
    IconData icon;
    Color color;

    switch (status) {
      case MemberStatus.idle:
        icon = Icons.person;
        color = AppColors.textTertiary;
        break;
      case MemberStatus.typing:
        icon = Icons.edit;
        color = AppColors.primary;
        break;
      case MemberStatus.testing:
        icon = Icons.play_circle_outline;
        color = AppColors.info;
        break;
      case MemberStatus.submitted:
        icon = Icons.check_circle;
        color = AppColors.success;
        break;
    }

    return Icon(icon, size: 16, color: color);
  }

  String _getStatusText(BranchMember member) {
    if (member.isTyping) {
      return 'Typing...';
    }

    switch (member.status) {
      case MemberStatus.idle:
        final secondsAgo = DateTime.now().difference(member.lastActivity).inSeconds;
        if (secondsAgo < 60) {
          return 'Active';
        } else if (secondsAgo < 300) {
          return '${secondsAgo ~/ 60}m ago';
        } else {
          return 'Idle';
        }
      case MemberStatus.typing:
        return 'Typing...';
      case MemberStatus.testing:
        return 'Running tests';
      case MemberStatus.submitted:
        return 'Submitted';
    }
  }
}
