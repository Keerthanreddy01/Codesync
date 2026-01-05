/// Battle Analytics & Metrics Service
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/battle_metrics_model.dart';
import '../models/decision_event_model.dart';

class BattleAnalyticsService {
  /// Calculate branch risk score
  BranchRiskScore calculateBranchRiskScore({
    required String branchId,
    required int totalCommits,
    required int testPassCount,
    required int testFailCount,
    required int mergeConflicts,
  }) {
    final totalTests = testPassCount + testFailCount;
    final testPassRatio = totalTests > 0 ? testPassCount / totalTests : 1.0;

    // Frequent edits (more commits = higher risk)
    final frequentEditsScore = (totalCommits.clamp(0, 100) / 100) * 100;

    // Low test pass ratio = higher risk
    final testPassRatioScore = (1 - testPassRatio) * 100;

    // Merge conflicts = risk
    final mergeConflictScore = (mergeConflicts.clamp(0, 20) / 20) * 100;

    // Weighted average
    final overallScore = (frequentEditsScore * 0.3 +
            testPassRatioScore * 0.4 +
            mergeConflictScore * 0.3)
        .clamp(0, 100);

    final riskLevel = _getRiskLevel(overallScore.toDouble());

    return BranchRiskScore(
      branchId: branchId,
      overallScore: overallScore.toDouble(),
      frequentEditsScore: frequentEditsScore,
      testPassRatioScore: testPassRatioScore,
      mergeConflictScore: mergeConflictScore,
      riskLevel: riskLevel,
      lastUpdated: DateTime.now(),
    );
  }

  /// Calculate typing velocity
  TypingVelocity calculateTypingVelocity({
    required String userId,
    required int totalKeystrokes,
    required int totalLinesModified,
    required Duration elapsedTime,
  }) {
    final seconds = elapsedTime.inSeconds.toDouble();
    final minutes = seconds / 60;

    final keystrokesPerSecond = seconds > 0 ? totalKeystrokes / seconds : 0.0;
    final linesPerMinute = minutes > 0 ? totalLinesModified / minutes : 0.0;

    return TypingVelocity(
      userId: userId,
      keystrokesPerSecond: keystrokesPerSecond.toDouble(),
      linesPerMinute: linesPerMinute.toDouble(),
      totalKeystrokes: totalKeystrokes,
      totalLinesModified: totalLinesModified,
      measurementTime: DateTime.now(),
    );
  }

  /// Calculate file heatmap
  FileHeatmap calculateFileHeatmap({
    required String fileId,
    required String fileName,
    required Map<int, int> lineModificationCounts,
    required Map<String, int> userContributions,
  }) {
    final avgMods = lineModificationCounts.isNotEmpty
        ? lineModificationCounts.values.fold(0, (a, b) => a + b) /
            lineModificationCounts.length
        : 0.0;

    return FileHeatmap(
      fileId: fileId,
      fileName: fileName,
      lineModificationCounts: lineModificationCounts,
      userContributions: userContributions,
      averageModificationsPerLine: avgMods,
    );
  }

  /// Update momentum based on test results
  MomentumState updateMomentum({
    required MomentumState current,
    required bool testPassed,
    required bool wasCleanMerge,
  }) {
    var newMomentum = current.currentMomentum;
    var consecutivePasses = current.consecutiveTestPasses;
    var consecutiveFailures = current.consecutiveTestFailures;
    var gains = List<String>.from(current.momentumGains);
    var losses = List<String>.from(current.momentumLosses);

    if (testPassed) {
      consecutivePasses++;
      consecutiveFailures = 0;
      newMomentum = (newMomentum + 10).clamp(0, 100);
      gains.add('Test passed: +10');
    } else {
      consecutiveFailures++;
      consecutivePasses = 0;
      newMomentum = (newMomentum - 15).clamp(0, 100);
      losses.add('Test failed: -15');
    }

    if (wasCleanMerge && testPassed) {
      newMomentum = (newMomentum + 5).clamp(0, 100);
      gains.add('Clean merge: +5');
    }

    // Decay momentum over time
    if (DateTime.now().difference(current.lastUpdate).inSeconds > 30) {
      newMomentum = (newMomentum * 0.95).clamp(0, 100);
    }

    // Keep only last 5 events
    if (gains.length > 5) gains.removeAt(0);
    if (losses.length > 5) losses.removeAt(0);

    return MomentumState(
      teamId: current.teamId,
      currentMomentum: newMomentum,
      maxMomentum: current.maxMomentum,
      consecutiveTestPasses: consecutivePasses,
      consecutiveTestFailures: consecutiveFailures,
      lastUpdate: DateTime.now(),
      momentumGains: gains,
      momentumLosses: losses,
    );
  }

  /// Calculate team chemistry post-battle
  TeamChemistry calculateTeamChemistry({
    required String teamId,
    required Map<String, int> codeContributions,
    required Map<String, int> mergeCount,
    required Map<String, int> idleSeconds,
  }) {
    final totalCode =
        codeContributions.values.fold(0, (a, b) => a + b).toDouble();
    final totalMerges = mergeCount.values.fold(0, (a, b) => a + b).toDouble();

    // Calculate ownership percentages
    final ownership = <String, double>{};
    codeContributions.forEach((userId, count) {
      ownership[userId] = totalCode > 0 ? (count / totalCode) * 100 : 0;
    });

    // Calculate balance (how evenly distributed work is)
    final balanceScore = ownership.isNotEmpty
        ? _calculateBalanceScore(ownership.values.toList()).toDouble()
        : 0.0;

    // Calculate collaboration (participation in merges)
    final collaborationScore = _calculateCollaborationScore(
      mergeCount: mergeCount,
      totalContributors: codeContributions.length,
    );

    return TeamChemistry(
      teamId: teamId,
      codeOwnership: ownership,
      mergeParticipation: mergeCount,
      idleTime: idleSeconds,
      balanceScore: balanceScore,
      collaborationScore: collaborationScore,
      calculatedAt: DateTime.now(),
    );
  }

  /// Create judgment breakdown for submission
  JudgmentBreakdown judgeSubmission({
    required String code,
    required List<bool> testResults,
  }) {
    // Syntax check (basic)
    final syntaxScore = _checkSyntax(code) ? 25.0 : 0.0;

    // Semantic check (logic)
    final semanticScore = _checkSemantics(code) ? 25.0 : 10.0;

    // Complexity estimation
    final complexityScore = _estimateComplexity(code);

    // Style check
    final styleScore = _checkStyle(code);

    // Test results weight
    final testScore = testResults.isNotEmpty
        ? (testResults.where((r) => r).length / testResults.length) * 25
        : 0.0;

    final totalScore =
        (syntaxScore + semanticScore + complexityScore + styleScore) * 0.8 +
            testScore * 0.2;

    return JudgmentBreakdown(
      syntaxScore: syntaxScore,
      semanticScore: semanticScore,
      complexityScore: complexityScore,
      styleScore: styleScore,
      totalScore: totalScore.clamp(0, 100),
      explanation: _generateExplanation(
        syntax: syntaxScore > 0,
        semantic: semanticScore > 10,
        testsPassed: testResults.where((r) => r).length,
      ),
      evaluatedAt: DateTime.now(),
    );
  }

  // Private helper methods
  RiskLevel _getRiskLevel(double score) {
    if (score < 20) return RiskLevel.safe;
    if (score < 40) return RiskLevel.low;
    if (score < 60) return RiskLevel.medium;
    if (score < 80) return RiskLevel.high;
    return RiskLevel.critical;
  }

  double _calculateBalanceScore(List<double> percentages) {
    if (percentages.isEmpty) return 0;
    final ideal = 100 / percentages.length;
    final variance =
        percentages.map((p) => (p - ideal).abs()).fold(0.0, (a, b) => a + b) /
            percentages.length;
    return (100 - variance).clamp(0, 100);
  }

  double _calculateCollaborationScore({
    required Map<String, int> mergeCount,
    required int totalContributors,
  }) {
    final participatingInMerges = mergeCount.values.where((c) => c > 0).length;
    return (participatingInMerges / totalContributors.clamp(1, 100)) * 100;
  }

  bool _checkSyntax(String code) {
    // Basic syntax check (implementation simplified)
    return !code.contains('{{') && !code.contains('}}');
  }

  bool _checkSemantics(String code) {
    // Basic semantic check
    return code.isNotEmpty && code.length > 10;
  }

  double _estimateComplexity(String code) {
    // Simple complexity estimation
    final loopCount = RegExp(r'(for|while|do)').allMatches(code).length;
    final conditionCount = RegExp(r'(if|else)').allMatches(code).length;
    final score = (loopCount * 3 + conditionCount * 2).clamp(0, 25).toDouble();
    return score;
  }

  double _checkStyle(String code) {
    // Check for proper formatting, naming conventions
    final hasProperIndentation = !code.contains('\t');
    final hasComments =
        code.contains('//') || code.contains('/*') || code.contains('*');
    final score = (hasProperIndentation ? 12 : 0) + (hasComments ? 13 : 5);
    return score.toDouble();
  }

  String _generateExplanation({
    required bool syntax,
    required bool semantic,
    required int testsPassed,
  }) {
    var parts = <String>[];
    if (!syntax) parts.add('Fix syntax errors');
    if (!semantic) parts.add('Review logic');
    if (testsPassed == 0) parts.add('No tests passing yet');
    return parts.isEmpty ? 'Good submission!' : parts.join('. ');
  }
}

// Riverpod providers
final battleAnalyticsProvider = Provider((ref) {
  return BattleAnalyticsService();
});

final branchRiskScoreProvider =
    StateNotifierProvider.family<BranchRiskNotifier, BranchRiskScore?, String>(
        (ref, branchId) {
  return BranchRiskNotifier(branchId, ref.watch(battleAnalyticsProvider));
});

final momentumProvider = StateNotifierProvider.family<MomentumNotifier,
    MomentumState, String>((ref, teamId) {
  return MomentumNotifier(
    teamId,
    ref.watch(battleAnalyticsProvider),
  );
});

class BranchRiskNotifier extends StateNotifier<BranchRiskScore?> {
  final String branchId;
  final BattleAnalyticsService analytics;

  BranchRiskNotifier(this.branchId, this.analytics) : super(null);

  void updateRisk({
    required int totalCommits,
    required int testPassCount,
    required int testFailCount,
    required int mergeConflicts,
  }) {
    state = analytics.calculateBranchRiskScore(
      branchId: branchId,
      totalCommits: totalCommits,
      testPassCount: testPassCount,
      testFailCount: testFailCount,
      mergeConflicts: mergeConflicts,
    );
  }
}

class MomentumNotifier extends StateNotifier<MomentumState> {
  final String teamId;
  final BattleAnalyticsService analytics;

  MomentumNotifier(
    this.teamId,
    this.analytics,
  ) : super(
    MomentumState(
      teamId: teamId,
      currentMomentum: 50,
      maxMomentum: 100,
      consecutiveTestPasses: 0,
      consecutiveTestFailures: 0,
      lastUpdate: DateTime.now(),
      momentumGains: [],
      momentumLosses: [],
    ),
  );

  void onTestResult({required bool passed, bool wasCleanMerge = false}) {
    state = analytics.updateMomentum(
      current: state,
      testPassed: passed,
      wasCleanMerge: wasCleanMerge,
    );
  }

  void reset() {
    state = MomentumState(
      teamId: teamId,
      currentMomentum: 50,
      maxMomentum: 100,
      consecutiveTestPasses: 0,
      consecutiveTestFailures: 0,
      lastUpdate: DateTime.now(),
      momentumGains: [],
      momentumLosses: [],
    );
  }
}
