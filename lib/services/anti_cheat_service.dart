/// Anti-Cheat Detection Service
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum FairPlayStatus {
  clean,
  warning,
  flagged,
  locked,
}

class AntiCheatResult {
  final FairPlayStatus status;
  final List<String> violations;
  final double suspicionScore; // 0-100
  final Map<String, dynamic> details;

  AntiCheatResult({
    required this.status,
    required this.violations,
    required this.suspicionScore,
    required this.details,
  });

  bool get isClean => status == FairPlayStatus.clean;
  bool get isFlagged => status == FairPlayStatus.flagged;
}

class AntiCheatService {
  /// Detect paste burst (large code insertion in short time)
  AntiCheatResult detectPasteBurst({
    required String code,
    required Duration insertionTime,
    required int existingCodeLength,
  }) {
    final insertedLength = code.length - existingCodeLength;
    final charsPerSecond =
        insertionTime.inSeconds > 0 ? insertedLength / insertionTime.inSeconds : 0;

    final violations = <String>[];
    var suspicionScore = 0.0;

    // Threshold: normal typing is 5-8 chars/second, paste is 50+
    if (charsPerSecond > 40) {
      violations.add('Large code insertion in short time');
      suspicionScore += 30;
    }

    if (insertedLength > 500 && insertionTime.inSeconds < 5) {
      violations.add('Extremely fast paste detected');
      suspicionScore += 40;
    }

    return AntiCheatResult(
      status: _getStatusFromScore(suspicionScore),
      violations: violations,
      suspicionScore: suspicionScore.clamp(0, 100),
      details: {
        'charsPerSecond': charsPerSecond,
        'insertedLength': insertedLength,
        'insertionTime': insertionTime.inSeconds,
      },
    );
  }

  /// Compare token similarity across team submissions
  AntiCheatResult compareTokenSimilarity({
    required String submission1,
    required String submission2,
  }) {
    final tokens1 = _tokenize(submission1);
    final tokens2 = _tokenize(submission2);
    final similarity = _calculateSimilarity(tokens1, tokens2);

    final violations = <String>[];
    var suspicionScore = 0.0;

    // If similarity is too high (>85%), might be copying
    if (similarity > 0.85) {
      violations.add('Code structure too similar to team submission');
      suspicionScore = (similarity - 0.85) * 200; // Scale to 0-30
    }

    return AntiCheatResult(
      status: _getStatusFromScore(suspicionScore),
      violations: violations,
      suspicionScore: suspicionScore.clamp(0, 100),
      details: {
        'similarity': similarity,
        'tokens1Count': tokens1.length,
        'tokens2Count': tokens2.length,
      },
    );
  }

  /// Detect abnormal speed vs complexity
  AntiCheatResult detectAbnormalSpeedVsComplexity({
    required String code,
    required Duration completionTime,
    required int testsPassed,
  }) {
    final complexity = _estimateComplexity(code);
    final expectedTime = _estimateExpectedTime(complexity);
    final speedFactor = expectedTime.inSeconds > 0
        ? completionTime.inSeconds / expectedTime.inSeconds
        : 1.0;

    final violations = <String>[];
    var suspicionScore = 0.0;

    // If solved much faster than expected for complexity, suspicious
    if (speedFactor < 0.3) {
      violations.add('Solved too quickly for complexity level');
      suspicionScore += 25;
    }

    // All tests passing on first try with complex code
    if (testsPassed > 0 && complexity > 0.7 && speedFactor < 0.5) {
      violations.add('Perfect submission unusually fast for problem difficulty');
      suspicionScore += 20;
    }

    return AntiCheatResult(
      status: _getStatusFromScore(suspicionScore),
      violations: violations,
      suspicionScore: suspicionScore.clamp(0, 100),
      details: {
        'complexity': complexity,
        'expectedTime': expectedTime.inSeconds,
        'actualTime': completionTime.inSeconds,
        'speedFactor': speedFactor,
        'testsPassed': testsPassed,
      },
    );
  }

  /// Comprehensive cheat detection
  AntiCheatResult detectCheating({
    required String code,
    required Duration completionTime,
    required int keystrokeCount,
    required String? previousSubmission,
    required int testsPassed,
  }) {
    final allViolations = <String>[];
    var totalScore = 0.0;

    // Check paste burst
    final pasteResult = detectPasteBurst(
      code: code,
      insertionTime: completionTime,
      existingCodeLength: previousSubmission?.length ?? 0,
    );
    allViolations.addAll(pasteResult.violations);
    totalScore += pasteResult.suspicionScore * 0.2;

    // Check token similarity
    if (previousSubmission != null) {
      final similarityResult = compareTokenSimilarity(
        submission1: code,
        submission2: previousSubmission,
      );
      allViolations.addAll(similarityResult.violations);
      totalScore += similarityResult.suspicionScore * 0.3;
    }

    // Check speed vs complexity
    final speedResult = detectAbnormalSpeedVsComplexity(
      code: code,
      completionTime: completionTime,
      testsPassed: testsPassed,
    );
    allViolations.addAll(speedResult.violations);
    totalScore += speedResult.suspicionScore * 0.5;

    totalScore = totalScore.clamp(0, 100);

    return AntiCheatResult(
      status: _getStatusFromScore(totalScore),
      violations: allViolations.toSet().toList(), // Remove duplicates
      suspicionScore: totalScore,
      details: {
        'pasteScore': pasteResult.suspicionScore,
        'similarityScore':
            previousSubmission != null ? pasteResult.suspicionScore : 0,
        'speedScore': speedResult.suspicionScore,
        'keystrokeCount': keystrokeCount,
      },
    );
  }

  // Private methods
  FairPlayStatus _getStatusFromScore(double score) {
    if (score < 20) return FairPlayStatus.clean;
    if (score < 50) return FairPlayStatus.warning;
    if (score < 75) return FairPlayStatus.flagged;
    return FairPlayStatus.locked;
  }

  List<String> _tokenize(String code) {
    // Simple tokenization - split by whitespace and symbols
    return code.replaceAll(RegExp(r'[{}()\[\];:,]'), ' ').split(RegExp(r'\s+'))
        .where((token) => token.isNotEmpty)
        .toList();
  }

  double _calculateSimilarity(List<String> tokens1, List<String> tokens2) {
    if (tokens1.isEmpty || tokens2.isEmpty) return 0;

    final common =
        tokens1.where((t) => tokens2.contains(t)).length;
    return common / max(tokens1.length, tokens2.length);
  }

  double _estimateComplexity(String code) {
    // Estimate based on control flow and nesting
    final loops = RegExp(r'\b(for|while|do)\b').allMatches(code).length;
    final conditions =
        RegExp(r'\b(if|else|switch)\b').allMatches(code).length;
    final recursion = RegExp(r'(\w+)\s*\(.*\1.*\)').hasMatch(code) ? 1 : 0;

    final score = ((loops * 0.2 + conditions * 0.15 + recursion * 0.3) /
            (code.length / 100))
        .clamp(0, 1);
    return score;
  }

  Duration _estimateExpectedTime(double complexity) {
    // Estimate time based on complexity (in minutes)
    // Easy: 2 min, Medium: 5 min, Hard: 15 min
    if (complexity < 0.3) {
      return const Duration(minutes: 2);
    } else if (complexity < 0.6) {
      return const Duration(minutes: 5);
    } else {
      return const Duration(minutes: 15);
    }
  }
}

// Riverpod provider
final antiCheatServiceProvider = Provider((ref) {
  return AntiCheatService();
});

final cheatDetectionProvider = FutureProvider.family<
    AntiCheatResult,
    ({
      String code,
      Duration completionTime,
      int keystrokeCount,
      String? previousSubmission,
      int testsPassed,
    })>((ref, params) async {
  final service = ref.watch(antiCheatServiceProvider);
  return service.detectCheating(
    code: params.code,
    completionTime: params.completionTime,
    keystrokeCount: params.keystrokeCount,
    previousSubmission: params.previousSubmission,
    testsPassed: params.testsPassed,
  );
});
