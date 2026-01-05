/// Mock Battle Service - For testing without Firebase
import '../models/battle_model.dart';
import '../models/problem_model.dart';

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

class MockBattleService {
  // In-memory storage
  static final Map<String, BattleModel> _battles = {};
  static final Map<String, ProblemModel> _problems = {};

  MockBattleService() {
    _initializeMockProblems();
  }

  void _initializeMockProblems() {
    if (_problems.isEmpty) {
      // Add sample problems
      _problems['problem_1'] = ProblemModel(
        id: 'problem_1',
        title: 'Two Sum',
        description: 'Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target.',
        difficulty: 'Easy',
        starterCode: '''int[] twoSum(int[] nums, int target) {
  // Write your code here
  return new int[]{};
}''',
        testCases: [
          TestCase(
            input: '[2,7,11,15], target = 9',
            expectedOutput: '[0,1]',
            isHidden: false,
          ),
          TestCase(
            input: '[3,2,4], target = 6',
            expectedOutput: '[1,2]',
            isHidden: false,
          ),
          TestCase(
            input: '[3,3], target = 6',
            expectedOutput: '[0,1]',
            isHidden: true,
          ),
        ],
      );

      _problems['problem_2'] = ProblemModel(
        id: 'problem_2',
        title: 'Reverse String',
        description: 'Write a function that reverses a string. The input string is given as an array of characters.',
        difficulty: 'Easy',
        starterCode: '''void reverseString(char[] s) {
  // Write your code here
}''',
        testCases: [
          TestCase(
            input: '["h","e","l","l","o"]',
            expectedOutput: '["o","l","l","e","h"]',
            isHidden: false,
          ),
          TestCase(
            input: '["H","a","n","n","a","h"]',
            expectedOutput: '["h","a","n","n","a","H"]',
            isHidden: false,
          ),
        ],
      );
    }
  }

  /// Create battle
  Future<BattleModel> createBattle({
    required String roomId,
    required List<String> participantIds,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Get random problem
    final problems = _problems.values.toList();
    final problem = problems[DateTime.now().millisecond % problems.length];

    final battleId = 'battle_${DateTime.now().millisecondsSinceEpoch}';
    final battle = BattleModel.create(
      id: battleId,
      roomId: roomId,
      problemId: problem.id,
      participantIds: participantIds,
      timeLimitSeconds: 15 * 60, // 15 minutes default
    );

    _battles[battleId] = battle;
    print('Mock Battle Created: $battleId with problem: ${problem.title}');

    return battle;
  }

  /// Get battle
  Future<BattleModel?> getBattle(String battleId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _battles[battleId];
  }

  /// Stream battle (simulated)
  Stream<BattleModel?> streamBattle(String battleId) async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      yield _battles[battleId];
    }
  }

  /// Get problem
  Future<ProblemModel?> getProblem(String problemId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _problems[problemId];
  }

  /// Submit solution
  Future<void> submitSolution({
    required String battleId,
    required String userId,
    required String code,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final battle = _battles[battleId];
    if (battle == null) throw Exception('Battle not found');

    final updatedSubmissions = {...battle.submissions, userId: code};
    final updatedScores = {...battle.scores, userId: 0}; // Mock score

    _battles[battleId] = battle.copyWith(
      submissions: updatedSubmissions,
      scores: updatedScores,
    );

    print('Solution submitted by $userId');
  }

  /// Complete battle
  Future<void> completeBattle(String battleId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final battle = _battles[battleId];
    if (battle == null) throw Exception('Battle not found');

    _battles[battleId] = battle.copyWith(
      status: BattleStatus.completed,
      endTime: DateTime.now(),
    );

    print('Battle $battleId completed');
  }

  /// Run tests (mock)
  Future<List<TestResult>> runTests({
    required String battleId,
    required String code,
  }) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate test execution

    final battle = _battles[battleId];
    if (battle == null) throw Exception('Battle not found');

    final problem = _problems[battle.problemId];
    if (problem == null) throw Exception('Problem not found');

    // Mock test results (randomly pass/fail for demo)
    final random = DateTime.now().millisecond;
    final results = problem.testCases.asMap().entries.map((entry) {
      final index = entry.key;
      final testCase = entry.value;
      final passed = (random + index) % 3 != 0; // ~66% pass rate

      return TestResult(
        input: testCase.input,
        expectedOutput: testCase.expectedOutput,
        actualOutput: passed ? testCase.expectedOutput : 'Wrong output',
        passed: passed,
      );
    }).toList();

    print('Tests run: ${results.where((r) => r.passed).length}/${results.length} passed');
    return results;
  }

  /// Update score
  Future<void> updateScore({
    required String battleId,
    required String userId,
    required int score,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final battle = _battles[battleId];
    if (battle == null) throw Exception('Battle not found');

    final updatedScores = {...battle.scores, userId: score};
    _battles[battleId] = battle.copyWith(scores: updatedScores);
  }

  /// Clear all battles (for testing)
  static void clearAll() {
    _battles.clear();
    print('All mock battles cleared');
  }
}
