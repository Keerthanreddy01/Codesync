/// Battle Providers - State Management
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/battle_model.dart';
import '../models/problem_model.dart';
import '../services/battle_service.dart';
import '../services/mock_battle_service.dart';

// Use mock service for now (until Firebase is configured)
const bool USE_MOCK = true;

// Battle Service Provider
final battleServiceProvider = Provider<dynamic>((ref) {
  return USE_MOCK ? MockBattleService() : BattleService();
});

// Current Battle ID Provider
final currentBattleIdProvider = StateProvider<String?>((ref) => null);

// Current Battle Stream Provider
final currentBattleProvider = StreamProvider<BattleModel?>((ref) {
  final battleId = ref.watch(currentBattleIdProvider);
  if (battleId == null) return Stream.value(null);

  final service = ref.watch(battleServiceProvider);
  return service.streamBattle(battleId);
});

// Current Problem Provider
final currentProblemProvider = FutureProvider<ProblemModel?>((ref) async {
  final battle = await ref.watch(currentBattleProvider.future);
  if (battle == null) return null;

  final service = ref.watch(battleServiceProvider);
  return service.getProblem(battle.problemId);
});

// Code Editor Provider
final codeEditorProvider = StateProvider<String>((ref) => '');

// Battle Actions Provider
final battleActionsProvider = Provider<BattleActions>((ref) => BattleActions(ref));

/// Battle Actions Class
class BattleActions {
  final Ref ref;

  BattleActions(this.ref);

  /// Start battle
  Future<BattleModel> startBattle(String roomId, List<String> participantIds) async {
    final service = ref.read(battleServiceProvider);
    
    // Get random problem
    final problem = await service.getRandomProblem();
    
    // Create battle
    final battle = await service.createBattle(
      roomId: roomId,
      problemId: problem.id,
      participantIds: participantIds,
      timeLimitSeconds: 600,
    );

    // Set current battle
    ref.read(currentBattleIdProvider.notifier).state = battle.id;
    
    // Set starter code in editor
    ref.read(codeEditorProvider.notifier).state = problem.starterCode;

    return battle;
  }

  /// Submit solution
  Future<void> submitSolution(String userId) async {
    final battleId = ref.read(currentBattleIdProvider);
    final code = ref.read(codeEditorProvider);
    
    if (battleId == null) {
      throw Exception('No active battle');
    }

    if (code.trim().isEmpty) {
      throw Exception('Code cannot be empty');
    }

    final service = ref.read(battleServiceProvider);
    await service.submitSolution(battleId, userId, code);
  }

  /// Run tests (simulated)
  Future<List<TestResult>> runTests() async {
    final code = ref.read(codeEditorProvider);
    final problem = await ref.read(currentProblemProvider.future);
    
    if (problem == null) {
      throw Exception('No problem loaded');
    }

    // Simulate test execution
    await Future.delayed(const Duration(seconds: 2));
    
    // Return mock results
    return problem.testCases.map((tc) {
      // Simple mock: pass 80% of tests randomly
      final passed = DateTime.now().millisecond % 5 != 0;
      return TestResult(
        input: tc.input,
        expectedOutput: tc.expectedOutput,
        actualOutput: passed ? tc.expectedOutput : 'Wrong output',
        passed: passed,
      );
    }).toList();
  }

  /// Complete battle
  Future<void> completeBattle() async {
    final battleId = ref.read(currentBattleIdProvider);
    if (battleId == null) return;

    final service = ref.read(battleServiceProvider);
    await service.completeBattle(battleId);
  }
}

class TestResult {
  final String input;
  final String expectedOutput;
  final String actualOutput;
  final bool passed;

  TestResult({
    required this.input,
    required this.expectedOutput,
    required this.actualOutput,
    required this.passed,
  });
}
