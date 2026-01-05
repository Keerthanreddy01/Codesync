/// Battle Metrics & Analytics Models
import 'package:json_annotation/json_annotation.dart';

part 'battle_metrics_model.g.dart';

/// Risk levels for branch scoring
enum RiskLevel {
  @JsonValue('safe')
  safe,
  @JsonValue('low')
  low,
  @JsonValue('medium')
  medium,
  @JsonValue('high')
  high,
  @JsonValue('critical')
  critical,
}

/// Branch risk score breakdown
@JsonSerializable()
class BranchRiskScore {
  final String branchId;
  final double overallScore; // 0-100
  final double frequentEditsScore; // 0-100
  final double testPassRatioScore; // 0-100
  final double mergeConflictScore; // 0-100
  final RiskLevel riskLevel;
  final DateTime lastUpdated;

  BranchRiskScore({
    required this.branchId,
    required this.overallScore,
    required this.frequentEditsScore,
    required this.testPassRatioScore,
    required this.mergeConflictScore,
    required this.riskLevel,
    required this.lastUpdated,
  });

  factory BranchRiskScore.fromJson(Map<String, dynamic> json) =>
      _$BranchRiskScoreFromJson(json);
  Map<String, dynamic> toJson() => _$BranchRiskScoreToJson(this);
}

/// Typing velocity metrics
@JsonSerializable()
class TypingVelocity {
  final String userId;
  final double keystrokesPerSecond;
  final double linesPerMinute;
  final int totalKeystrokes;
  final int totalLinesModified;
  final DateTime measurementTime;

  TypingVelocity({
    required this.userId,
    required this.keystrokesPerSecond,
    required this.linesPerMinute,
    required this.totalKeystrokes,
    required this.totalLinesModified,
    required this.measurementTime,
  });

  factory TypingVelocity.fromJson(Map<String, dynamic> json) =>
      _$TypingVelocityFromJson(json);
  Map<String, dynamic> toJson() => _$TypingVelocityToJson(this);
}

/// File-level heatmap data
@JsonSerializable()
class FileHeatmap {
  final String fileId;
  final String fileName;
  final Map<int, int> lineModificationCounts; // line number -> modification count
  final Map<String, int> userContributions; // userId -> count
  final double averageModificationsPerLine;

  FileHeatmap({
    required this.fileId,
    required this.fileName,
    required this.lineModificationCounts,
    required this.userContributions,
    required this.averageModificationsPerLine,
  });

  factory FileHeatmap.fromJson(Map<String, dynamic> json) =>
      _$FileHeatmapFromJson(json);
  Map<String, dynamic> toJson() => _$FileHeatmapToJson(this);
}

/// Momentum system state
@JsonSerializable()
class MomentumState {
  final String teamId;
  final double currentMomentum; // 0-100
  final double maxMomentum;
  final int consecutiveTestPasses;
  final int consecutiveTestFailures;
  final DateTime lastUpdate;
  final List<String> momentumGains; // Recent positive events
  final List<String> momentumLosses; // Recent negative events

  MomentumState({
    required this.teamId,
    required this.currentMomentum,
    required this.maxMomentum,
    required this.consecutiveTestPasses,
    required this.consecutiveTestFailures,
    required this.lastUpdate,
    required this.momentumGains,
    required this.momentumLosses,
  });

  factory MomentumState.fromJson(Map<String, dynamic> json) =>
      _$MomentumStateFromJson(json);
  Map<String, dynamic> toJson() => _$MomentumStateToJson(this);

  /// Check if momentum is building
  bool isBuildingMomentum() => consecutiveTestPasses > 0;

  /// Get momentum health
  double getMomentumHealth() => (currentMomentum / maxMomentum) * 100;
}

/// Team chemistry metrics
@JsonSerializable()
class TeamChemistry {
  final String teamId;
  final Map<String, double> codeOwnership; // userId -> percentage
  final Map<String, int> mergeParticipation; // userId -> count
  final Map<String, int> idleTime; // userId -> seconds
  final double balanceScore; // 0-100 (how evenly distributed work is)
  final double collaborationScore; // 0-100
  final DateTime calculatedAt;

  TeamChemistry({
    required this.teamId,
    required this.codeOwnership,
    required this.mergeParticipation,
    required this.idleTime,
    required this.balanceScore,
    required this.collaborationScore,
    required this.calculatedAt,
  });

  factory TeamChemistry.fromJson(Map<String, dynamic> json) =>
      _$TeamChemistryFromJson(json);
  Map<String, dynamic> toJson() => _$TeamChemistryToJson(this);
}

/// Advanced judgment criteria
@JsonSerializable()
class JudgmentBreakdown {
  final double syntaxScore; // 0-25
  final double semanticScore; // 0-25
  final double complexityScore; // 0-25
  final double styleScore; // 0-25
  final double totalScore; // 0-100
  final String explanation;
  final DateTime evaluatedAt;

  JudgmentBreakdown({
    required this.syntaxScore,
    required this.semanticScore,
    required this.complexityScore,
    required this.styleScore,
    required this.totalScore,
    required this.explanation,
    required this.evaluatedAt,
  });

  factory JudgmentBreakdown.fromJson(Map<String, dynamic> json) =>
      _$JudgmentBreakdownFromJson(json);
  Map<String, dynamic> toJson() => _$JudgmentBreakdownToJson(this);
}

/// Code DNA profile (solution patterns)
@JsonSerializable()
class CodeDNAProfile {
  final String userId;
  final List<String> detectedPatterns; // recursion, dp, greedy, etc
  final Map<String, int> patternFrequency;
  final List<String> favoriteAlgorithmTypes;
  final double averageComplexity;
  final DateTime analyzedAt;

  CodeDNAProfile({
    required this.userId,
    required this.detectedPatterns,
    required this.patternFrequency,
    required this.favoriteAlgorithmTypes,
    required this.averageComplexity,
    required this.analyzedAt,
  });

  factory CodeDNAProfile.fromJson(Map<String, dynamic> json) =>
      _$CodeDNAProfileFromJson(json);
  Map<String, dynamic> toJson() => _$CodeDNAProfileToJson(this);
}
