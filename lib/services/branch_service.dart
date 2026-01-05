/// Branch Service - Git-style branch operations
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import '../models/branch_model.dart';

class BranchService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  DatabaseReference _branchesRef(String battleId) =>
      _database.ref('battles/$battleId/branches');

  /// Create branch for team when battle starts
  Future<BranchModel> createBranch({
    required String battleId,
    required String teamId,
    required String teamName,
    required String starterCode,
    required List<String> memberIds,
  }) async {
    try {
      final branchRef = _branchesRef(battleId).child(teamId);

      final branch = BranchModel.create(
        id: teamId,
        battleId: battleId,
        teamId: teamId,
        teamName: teamName,
        starterCode: starterCode,
        memberIds: memberIds,
      );

      await branchRef.set(branch.toJson());
      return branch;
    } catch (e) {
      throw Exception('Failed to create branch: $e');
    }
  }

  /// Get branch by team ID
  Future<BranchModel?> getBranch(String battleId, String teamId) async {
    try {
      final snapshot = await _branchesRef(battleId).child(teamId).once();
      if (snapshot.snapshot.value == null) return null;

      final data = snapshot.snapshot.value as Map<dynamic, dynamic>;
      return BranchModel.fromJson(Map<String, dynamic>.from(data));
    } catch (e) {
      throw Exception('Failed to get branch: $e');
    }
  }

  /// Get all branches in battle
  Future<List<BranchModel>> getAllBranches(String battleId) async {
    try {
      final snapshot = await _branchesRef(battleId).once();
      if (snapshot.snapshot.value == null) return [];

      final branchesMap = snapshot.snapshot.value as Map<dynamic, dynamic>;
      return branchesMap.values
          .map((data) => BranchModel.fromJson(Map<String, dynamic>.from(data as Map)))
          .toList();
    } catch (e) {
      throw Exception('Failed to get branches: $e');
    }
  }

  /// Stream branch updates (real-time)
  Stream<BranchModel?> streamBranch(String battleId, String teamId) {
    return _branchesRef(battleId).child(teamId).onValue.map((event) {
      if (event.snapshot.value == null) return null;
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      return BranchModel.fromJson(Map<String, dynamic>.from(data));
    });
  }

  /// Stream all branches (real-time)
  Stream<List<BranchModel>> streamAllBranches(String battleId) {
    return _branchesRef(battleId).onValue.map((event) {
      if (event.snapshot.value == null) return [];
      final branchesMap = event.snapshot.value as Map<dynamic, dynamic>;
      return branchesMap.values
          .map((data) => BranchModel.fromJson(Map<String, dynamic>.from(data as Map)))
          .toList();
    });
  }

  /// Update code (debounced sync)
  Future<void> updateCode({
    required String battleId,
    required String teamId,
    required String code,
    required String userId,
  }) async {
    try {
      final lineCount = code.split('\n').length;
      
      await _branchesRef(battleId).child(teamId).update({
        'code': code,
        'lastEditor': userId,
        'stats/lineCount': lineCount,
        'stats/lastEdit': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to update code: $e');
    }
  }

  /// Update member cursor position
  Future<void> updateCursor({
    required String battleId,
    required String teamId,
    required String userId,
    required int position,
    required int line,
  }) async {
    try {
      await _branchesRef(battleId)
          .child(teamId)
          .child('members/$userId')
          .update({
        'cursorPosition': position,
        'cursorLine': line,
        'lastActivity': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Silent fail for cursor updates
    }
  }

  /// Update member status
  Future<void> updateMemberStatus({
    required String battleId,
    required String teamId,
    required String userId,
    required MemberStatus status,
    bool? isTyping,
  }) async {
    try {
      final updates = <String, dynamic>{
        'status': status.name,
        'lastActivity': DateTime.now().toIso8601String(),
      };
      
      if (isTyping != null) {
        updates['isTyping'] = isTyping;
      }

      await _branchesRef(battleId)
          .child(teamId)
          .child('members/$userId')
          .update(updates);
    } catch (e) {
      // Silent fail for status updates
    }
  }

  /// Update test run statistics
  Future<void> updateTestStats({
    required String battleId,
    required String teamId,
    required int passed,
    required int failed,
  }) async {
    try {
      final snapshot = await _branchesRef(battleId)
          .child(teamId)
          .child('stats/testRuns')
          .once();
      
      final currentRuns = snapshot.snapshot.value as int? ?? 0;

      await _branchesRef(battleId).child(teamId).child('stats').update({
        'testRuns': currentRuns + 1,
        'testsPassed': passed,
        'testsFailed': failed,
      });
    } catch (e) {
      throw Exception('Failed to update test stats: $e');
    }
  }

  /// Submit branch (lock for editing)
  Future<void> submitBranch({
    required String battleId,
    required String teamId,
    required String userId,
  }) async {
    try {
      await _branchesRef(battleId).child(teamId).update({
        'status': BranchStatus.submitted.name,
        'submittedAt': DateTime.now().toIso8601String(),
      });

      // Update all members to submitted status
      final branch = await getBranch(battleId, teamId);
      if (branch != null) {
        for (final memberId in branch.members.keys) {
          await updateMemberStatus(
            battleId: battleId,
            teamId: teamId,
            userId: memberId,
            status: MemberStatus.submitted,
          );
        }
      }
    } catch (e) {
      throw Exception('Failed to submit branch: $e');
    }
  }

  /// Check if all branches submitted
  Future<bool> areAllBranchesSubmitted(String battleId) async {
    try {
      final branches = await getAllBranches(battleId);
      return branches.isNotEmpty &&
          branches.every((b) => b.status == BranchStatus.submitted);
    } catch (e) {
      return false;
    }
  }

  /// Get branch color for visualization
  String getBranchColor(int index) {
    final colors = [
      '#3B82F6', // Blue
      '#10B981', // Green
      '#8B5CF6', // Purple
      '#F59E0B', // Orange
      '#EF4444', // Red
      '#06B6D4', // Cyan
      '#EC4899', // Pink
      '#14B8A6', // Teal
    ];
    return colors[index % colors.length];
  }
}
