// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'battle_metrics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BranchRiskScore _$BranchRiskScoreFromJson(Map<String, dynamic> json) =>
    BranchRiskScore(
      branchId: json['branchId'] as String,
      overallScore: (json['overallScore'] as num).toDouble(),
      frequentEditsScore: (json['frequentEditsScore'] as num).toDouble(),
      testPassRatioScore: (json['testPassRatioScore'] as num).toDouble(),
      mergeConflictScore: (json['mergeConflictScore'] as num).toDouble(),
      riskLevel: $enumDecode(_$RiskLevelEnumMap, json['riskLevel']),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$BranchRiskScoreToJson(BranchRiskScore instance) =>
    <String, dynamic>{
      'branchId': instance.branchId,
      'overallScore': instance.overallScore,
      'frequentEditsScore': instance.frequentEditsScore,
      'testPassRatioScore': instance.testPassRatioScore,
      'mergeConflictScore': instance.mergeConflictScore,
      'riskLevel': _$RiskLevelEnumMap[instance.riskLevel]!,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

const _$RiskLevelEnumMap = {
  RiskLevel.safe: 'safe',
  RiskLevel.low: 'low',
  RiskLevel.medium: 'medium',
  RiskLevel.high: 'high',
  RiskLevel.critical: 'critical',
};

TypingVelocity _$TypingVelocityFromJson(Map<String, dynamic> json) =>
    TypingVelocity(
      userId: json['userId'] as String,
      keystrokesPerSecond: (json['keystrokesPerSecond'] as num).toDouble(),
      linesPerMinute: (json['linesPerMinute'] as num).toDouble(),
      totalKeystrokes: (json['totalKeystrokes'] as num).toInt(),
      totalLinesModified: (json['totalLinesModified'] as num).toInt(),
      measurementTime: DateTime.parse(json['measurementTime'] as String),
    );

Map<String, dynamic> _$TypingVelocityToJson(TypingVelocity instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'keystrokesPerSecond': instance.keystrokesPerSecond,
      'linesPerMinute': instance.linesPerMinute,
      'totalKeystrokes': instance.totalKeystrokes,
      'totalLinesModified': instance.totalLinesModified,
      'measurementTime': instance.measurementTime.toIso8601String(),
    };

FileHeatmap _$FileHeatmapFromJson(Map<String, dynamic> json) => FileHeatmap(
      fileId: json['fileId'] as String,
      fileName: json['fileName'] as String,
      lineModificationCounts:
          (json['lineModificationCounts'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), (e as num).toInt()),
      ),
      userContributions:
          Map<String, int>.from(json['userContributions'] as Map),
      averageModificationsPerLine:
          (json['averageModificationsPerLine'] as num).toDouble(),
    );

Map<String, dynamic> _$FileHeatmapToJson(FileHeatmap instance) =>
    <String, dynamic>{
      'fileId': instance.fileId,
      'fileName': instance.fileName,
      'lineModificationCounts': instance.lineModificationCounts
          .map((k, e) => MapEntry(k.toString(), e)),
      'userContributions': instance.userContributions,
      'averageModificationsPerLine': instance.averageModificationsPerLine,
    };

MomentumState _$MomentumStateFromJson(Map<String, dynamic> json) =>
    MomentumState(
      teamId: json['teamId'] as String,
      currentMomentum: (json['currentMomentum'] as num).toDouble(),
      maxMomentum: (json['maxMomentum'] as num).toDouble(),
      consecutiveTestPasses: (json['consecutiveTestPasses'] as num).toInt(),
      consecutiveTestFailures: (json['consecutiveTestFailures'] as num).toInt(),
      lastUpdate: DateTime.parse(json['lastUpdate'] as String),
      momentumGains: (json['momentumGains'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      momentumLosses: (json['momentumLosses'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$MomentumStateToJson(MomentumState instance) =>
    <String, dynamic>{
      'teamId': instance.teamId,
      'currentMomentum': instance.currentMomentum,
      'maxMomentum': instance.maxMomentum,
      'consecutiveTestPasses': instance.consecutiveTestPasses,
      'consecutiveTestFailures': instance.consecutiveTestFailures,
      'lastUpdate': instance.lastUpdate.toIso8601String(),
      'momentumGains': instance.momentumGains,
      'momentumLosses': instance.momentumLosses,
    };

TeamChemistry _$TeamChemistryFromJson(Map<String, dynamic> json) =>
    TeamChemistry(
      teamId: json['teamId'] as String,
      codeOwnership: (json['codeOwnership'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      mergeParticipation:
          Map<String, int>.from(json['mergeParticipation'] as Map),
      idleTime: Map<String, int>.from(json['idleTime'] as Map),
      balanceScore: (json['balanceScore'] as num).toDouble(),
      collaborationScore: (json['collaborationScore'] as num).toDouble(),
      calculatedAt: DateTime.parse(json['calculatedAt'] as String),
    );

Map<String, dynamic> _$TeamChemistryToJson(TeamChemistry instance) =>
    <String, dynamic>{
      'teamId': instance.teamId,
      'codeOwnership': instance.codeOwnership,
      'mergeParticipation': instance.mergeParticipation,
      'idleTime': instance.idleTime,
      'balanceScore': instance.balanceScore,
      'collaborationScore': instance.collaborationScore,
      'calculatedAt': instance.calculatedAt.toIso8601String(),
    };

JudgmentBreakdown _$JudgmentBreakdownFromJson(Map<String, dynamic> json) =>
    JudgmentBreakdown(
      syntaxScore: (json['syntaxScore'] as num).toDouble(),
      semanticScore: (json['semanticScore'] as num).toDouble(),
      complexityScore: (json['complexityScore'] as num).toDouble(),
      styleScore: (json['styleScore'] as num).toDouble(),
      totalScore: (json['totalScore'] as num).toDouble(),
      explanation: json['explanation'] as String,
      evaluatedAt: DateTime.parse(json['evaluatedAt'] as String),
    );

Map<String, dynamic> _$JudgmentBreakdownToJson(JudgmentBreakdown instance) =>
    <String, dynamic>{
      'syntaxScore': instance.syntaxScore,
      'semanticScore': instance.semanticScore,
      'complexityScore': instance.complexityScore,
      'styleScore': instance.styleScore,
      'totalScore': instance.totalScore,
      'explanation': instance.explanation,
      'evaluatedAt': instance.evaluatedAt.toIso8601String(),
    };

CodeDNAProfile _$CodeDNAProfileFromJson(Map<String, dynamic> json) =>
    CodeDNAProfile(
      userId: json['userId'] as String,
      detectedPatterns: (json['detectedPatterns'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      patternFrequency: Map<String, int>.from(json['patternFrequency'] as Map),
      favoriteAlgorithmTypes: (json['favoriteAlgorithmTypes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      averageComplexity: (json['averageComplexity'] as num).toDouble(),
      analyzedAt: DateTime.parse(json['analyzedAt'] as String),
    );

Map<String, dynamic> _$CodeDNAProfileToJson(CodeDNAProfile instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'detectedPatterns': instance.detectedPatterns,
      'patternFrequency': instance.patternFrequency,
      'favoriteAlgorithmTypes': instance.favoriteAlgorithmTypes,
      'averageComplexity': instance.averageComplexity,
      'analyzedAt': instance.analyzedAt.toIso8601String(),
    };
