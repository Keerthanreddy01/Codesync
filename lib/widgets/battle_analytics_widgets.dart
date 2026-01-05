/// Battle Analytics UI Components
import 'package:flutter/material.dart';
import 'package:codesync_arena/config/app_colors.dart';
import 'package:codesync_arena/config/app_text_styles.dart';
import 'package:codesync_arena/widgets/ultrahuman_card.dart';
import 'package:codesync_arena/models/battle_metrics_model.dart';

/// Momentum Display Widget
class MomentumBar extends StatelessWidget {
  final MomentumState momentum;

  const MomentumBar({
    super.key,
    required this.momentum,
  });

  @override
  Widget build(BuildContext context) {
    final health = momentum.getMomentumHealth();
    final barColor = _getColorForMomentum(momentum.currentMomentum);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'MOMENTUM',
              style: AppTextStyles.captionBold.copyWith(
                color: AppColors.textTertiary,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              '${momentum.currentMomentum.toStringAsFixed(0)}%',
              style: AppTextStyles.body1.copyWith(
                color: barColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: momentum.currentMomentum / 100,
            minHeight: 8,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
        if (momentum.momentumGains.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: AppColors.success.withOpacity(0.3), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: momentum.momentumGains.take(2).map((gain) {
                return Text(
                  '✓ $gain',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.success,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Color _getColorForMomentum(double momentum) {
    if (momentum < 30) return AppColors.error;
    if (momentum < 60) return AppColors.warning;
    return AppColors.success;
  }
}

/// Branch Risk Score Display
class RiskScoreCard extends StatelessWidget {
  final BranchRiskScore risk;
  final VoidCallback? onMergeTap;

  const RiskScoreCard({
    super.key,
    required this.risk,
    this.onMergeTap,
  });

  @override
  Widget build(BuildContext context) {
    final riskColor = _getColorForRisk(risk.riskLevel);

    return UltrahumanCard(
      borderColor: riskColor.withOpacity(0.3),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getIconForRisk(risk.riskLevel),
                color: riskColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Branch Risk',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      risk.riskLevel.toString().split('.').last.toUpperCase(),
                      style: AppTextStyles.caption.copyWith(
                        color: riskColor,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${risk.overallScore.toStringAsFixed(0)}%',
                style: AppTextStyles.heading3.copyWith(
                  color: riskColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRiskMetric('Edits', risk.frequentEditsScore),
          const SizedBox(height: 8),
          _buildRiskMetric('Test Pass Rate', risk.testPassRatioScore),
          const SizedBox(height: 8),
          _buildRiskMetric('Conflicts', risk.mergeConflictScore),
          if (risk.riskLevel == RiskLevel.high ||
              risk.riskLevel == RiskLevel.critical) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: riskColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: riskColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: riskColor, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Merge with caution - review carefully',
                      style: AppTextStyles.caption.copyWith(
                        color: riskColor,
                      ),
                    ),
                  ),
                  if (onMergeTap != null)
                    InkWell(
                      onTap: onMergeTap,
                      child: Icon(Icons.merge_type, color: riskColor, size: 18),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRiskMetric(String label, double value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value / 100,
            minHeight: 4,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getColorForRisk(_getRiskLevelFromScore(value)),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${value.toStringAsFixed(0)}%',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Color _getColorForRisk(RiskLevel level) {
    switch (level) {
      case RiskLevel.safe:
        return AppColors.success;
      case RiskLevel.low:
        return AppColors.info;
      case RiskLevel.medium:
        return AppColors.warning;
      case RiskLevel.high:
        return AppColors.error;
      case RiskLevel.critical:
        return Colors.red;
    }
  }

  IconData _getIconForRisk(RiskLevel level) {
    switch (level) {
      case RiskLevel.safe:
        return Icons.shield_outlined;
      case RiskLevel.low:
        return Icons.info_outlined;
      case RiskLevel.medium:
        return Icons.warning_amber;
      case RiskLevel.high:
        return Icons.dangerous;
      case RiskLevel.critical:
        return Icons.error;
    }
  }

  RiskLevel _getRiskLevelFromScore(double score) {
    if (score < 20) return RiskLevel.safe;
    if (score < 40) return RiskLevel.low;
    if (score < 60) return RiskLevel.medium;
    if (score < 80) return RiskLevel.high;
    return RiskLevel.critical;
  }
}

/// Typing Velocity Indicator
class TypingVelocityDisplay extends StatelessWidget {
  final TypingVelocity velocity;

  const TypingVelocityDisplay({
    super.key,
    required this.velocity,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.speed,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${velocity.keystrokesPerSecond.toStringAsFixed(1)} keys/sec',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${velocity.linesPerMinute.toStringAsFixed(0)} lines/min',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Team Chemistry Score Display
class TeamChemistryCard extends StatelessWidget {
  final TeamChemistry chemistry;

  const TeamChemistryCard({
    super.key,
    required this.chemistry,
  });

  @override
  Widget build(BuildContext context) {
    return UltrahumanCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TEAM CHEMISTRY',
            style: AppTextStyles.captionBold.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildChemistryMetric(
                  'Balance',
                  chemistry.balanceScore,
                  AppColors.info,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildChemistryMetric(
                  'Collaboration',
                  chemistry.collaborationScore,
                  AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'CODE OWNERSHIP',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 8),
          ...chemistry.codeOwnership.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text(
                    entry.key.substring(0, 3).toUpperCase(),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: FractionallySizedBox(
                        widthFactor: entry.value / 100,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '${entry.value.toStringAsFixed(0)}%',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildChemistryMetric(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value / 100,
            minHeight: 6,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${value.toStringAsFixed(0)}%',
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
