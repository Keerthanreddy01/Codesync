/// Branch Comparison View - Side-by-side branches
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import '../../providers/branch_providers.dart';
import '../../models/branch_model.dart';

class BranchComparisonView extends ConsumerWidget {
  const BranchComparisonView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchesAsync = ref.watch(allBranchesProvider);

    return branchesAsync.when(
      data: (branches) {
        if (branches.isEmpty) {
          return Center(
            child: Text(
              'No branches yet',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          );
        }

        return _buildBranchGrid(context, branches);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Text(
          'Error loading branches: $err',
          style: AppTextStyles.body2.copyWith(color: AppColors.error),
        ),
      ),
    );
  }

  Widget _buildBranchGrid(BuildContext context, List<BranchModel> branches) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: branches.length,
      itemBuilder: (context, index) {
        return BranchCard(
          branch: branches[index],
          colorIndex: index,
        );
      },
    );
  }
}

class BranchCard extends StatelessWidget {
  final BranchModel branch;
  final int colorIndex;

  const BranchCard({
    super.key,
    required this.branch,
    required this.colorIndex,
  });

  Color _getBranchColor() {
    final colors = [
      AppColors.primary,
      AppColors.success,
      Colors.purple,
      Colors.orange,
      Colors.red,
      Colors.cyan,
      Colors.pink,
      Colors.teal,
    ];
    return colors[colorIndex % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with branch name
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getBranchColor().withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.source_outlined,
                  color: _getBranchColor(),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    branch.branchName,
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusBadge(),
              ],
            ),
          ),

          // Team members
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Team Members',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                ...branch.members.values.take(4).map((member) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        _buildMemberStatusIcon(member.status),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            member.username,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (member.isTyping)
                          Icon(
                            Icons.edit,
                            size: 12,
                            color: AppColors.primary,
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),

          // Statistics
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(
                  Icons.format_list_numbered,
                  '${branch.stats.lineCount}',
                  'Lines',
                ),
                _buildStatItem(
                  Icons.play_circle_outline,
                  '${branch.stats.testRuns}',
                  'Tests',
                ),
                _buildStatItem(
                  Icons.people,
                  '${branch.getActiveMembers()}',
                  'Active',
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Code preview
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: SingleChildScrollView(
                child: Text(
                  branch.code.isEmpty ? '// No code yet...' : branch.code,
                  style: AppTextStyles.code.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                  maxLines: 8,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
          ),

          // Expand button
          TextButton(
            onPressed: () {
              _showBranchDetail(context, branch);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'View Full Code',
                  style: AppTextStyles.caption.copyWith(
                    color: _getBranchColor(),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward,
                  size: 14,
                  color: _getBranchColor(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color color;
    String text;
    
    switch (branch.status) {
      case BranchStatus.active:
        color = AppColors.success;
        text = 'ACTIVE';
        break;
      case BranchStatus.submitted:
        color = AppColors.primary;
        text = 'SUBMITTED';
        break;
      case BranchStatus.judging:
        color = AppColors.warning;
        text = 'JUDGING';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMemberStatusIcon(MemberStatus status) {
    IconData icon;
    Color color;

    switch (status) {
      case MemberStatus.idle:
        icon = Icons.circle;
        color = AppColors.textTertiary;
        break;
      case MemberStatus.typing:
        icon = Icons.edit;
        color = AppColors.primary;
        break;
      case MemberStatus.testing:
        icon = Icons.play_circle_filled;
        color = AppColors.info;
        break;
      case MemberStatus.submitted:
        icon = Icons.check_circle;
        color = AppColors.success;
        break;
    }

    return Icon(icon, size: 12, color: color);
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textTertiary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  void _showBranchDetail(BuildContext context, BranchModel branch) {
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
                  Icon(
                    Icons.source_outlined,
                    color: _getBranchColor(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      branch.branchName,
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      branch.code.isEmpty ? '// No code yet...' : branch.code,
                      style: AppTextStyles.code.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
