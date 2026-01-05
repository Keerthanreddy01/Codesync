/// Battle Service - Firebase operations for battles
import 'package:firebase_database/firebase_database.dart';
import '../models/battle_model.dart';
import '../models/problem_model.dart';

class BattleService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  DatabaseReference get _battlesRef => _database.ref('battles');
  DatabaseReference get _problemsRef => _database.ref('problems');

  /// Create new battle
  Future<BattleModel> createBattle({
    required String roomId,
    required String problemId,
    required List<String> participantIds,
    int timeLimitSeconds = 600,
  }) async {
    try {
      final battleRef = _battlesRef.push();
      
      final battle = BattleModel.create(
        id: battleRef.key!,
        roomId: roomId,
        problemId: problemId,
        participantIds: participantIds,
        timeLimitSeconds: timeLimitSeconds,
      );

      await battleRef.set(battle.toJson());
      return battle;
    } catch (e) {
      throw Exception('Failed to create battle: $e');
    }
  }

  /// Get battle by ID
  Future<BattleModel?> getBattle(String battleId) async {
    try {
      final snapshot = await _battlesRef.child(battleId).once();
      if (snapshot.snapshot.value == null) return null;

      final data = snapshot.snapshot.value as Map<dynamic, dynamic>;
      return BattleModel.fromJson(Map<String, dynamic>.from(data));
    } catch (e) {
      throw Exception('Failed to get battle: $e');
    }
  }

  /// Stream battle updates
  Stream<BattleModel?> streamBattle(String battleId) {
    return _battlesRef.child(battleId).onValue.map((event) {
      if (event.snapshot.value == null) return null;
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      return BattleModel.fromJson(Map<String, dynamic>.from(data));
    });
  }

  /// Submit solution
  Future<void> submitSolution(String battleId, String userId, String code) async {
    try {
      await _battlesRef.child(battleId).update({
        'submissions/$userId': code,
        'submittedStatus/$userId': true,
      });
    } catch (e) {
      throw Exception('Failed to submit solution: $e');
    }
  }

  /// Update score
  Future<void> updateScore(String battleId, String userId, int score) async {
    try {
      await _battlesRef.child(battleId).child('scores').update({
        userId: score,
      });
    } catch (e) {
      throw Exception('Failed to update score: $e');
    }
  }

  /// Complete battle
  Future<void> completeBattle(String battleId) async {
    try {
      await _battlesRef.child(battleId).update({
        'status': BattleStatus.completed.name,
        'endTime': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to complete battle: $e');
    }
  }

  /// Get random problem
  Future<ProblemModel> getRandomProblem() async {
    try {
      final snapshot = await _problemsRef.once();
      
      if (snapshot.snapshot.value == null) {
        // Return default problem if none exist
        return _getDefaultProblem();
      }

      final problemsMap = snapshot.snapshot.value as Map<dynamic, dynamic>;
      final problems = problemsMap.entries.toList()..shuffle();
      
      final problemData = problems.first.value as Map<dynamic, dynamic>;
      return ProblemModel.fromJson(Map<String, dynamic>.from(problemData));
    } catch (e) {
      // Return default problem on error
      return _getDefaultProblem();
    }
  }

  /// Get problem by ID
  Future<ProblemModel?> getProblem(String problemId) async {
    try {
      final snapshot = await _problemsRef.child(problemId).once();
      if (snapshot.snapshot.value == null) return null;

      final data = snapshot.snapshot.value as Map<dynamic, dynamic>;
      return ProblemModel.fromJson(Map<String, dynamic>.from(data));
    } catch (e) {
      throw Exception('Failed to get problem: $e');
    }
  }

  /// Default problem for testing
  ProblemModel _getDefaultProblem() {
    return ProblemModel(
      id: 'default_001',
      title: 'Two Sum',
      description: 'Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target.',
      difficulty: 'Easy',
      testCases: [
        TestCase(
          input: '[2,7,11,15], 9',
          expectedOutput: '[0,1]',
        ),
        TestCase(
          input: '[3,2,4], 6',
          expectedOutput: '[1,2]',
        ),
        TestCase(
          input: '[3,3], 6',
          expectedOutput: '[0,1]',
        ),
      ],
      starterCode: '''
List<int> twoSum(List<int> nums, int target) {
  // Your code here
  return [];
}
''',
      tags: ['Array', 'Hash Table'],
    );
  }
}
