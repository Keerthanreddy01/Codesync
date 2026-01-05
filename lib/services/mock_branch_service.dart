/// Mock Branch Service - For testing without Firebase
import '../models/branch_model.dart';

class MockBranchService {
  // In-memory storage
  static final Map<String, Map<String, BranchModel>> _battles = {};

  /// Create branch
  Future<BranchModel> createBranch({
    required String battleId,
    required String teamId,
    required String teamName,
    required String starterCode,
    required List<String> memberIds,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final branchId = '${battleId}_$teamId';
    final branch = BranchModel.create(
      id: branchId,
      battleId: battleId,
      teamId: teamId,
      teamName: teamName,
      starterCode: starterCode,
      memberIds: memberIds,
    );

    _battles[battleId] ??= {};
    _battles[battleId]![teamId] = branch;

    print('Mock Branch Created: $teamName (Team: $teamId)');
    return branch;
  }

  /// Get branch
  Future<BranchModel?> getBranch(String battleId, String teamId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _battles[battleId]?[teamId];
  }

  /// Stream branch (simulated)
  Stream<BranchModel?> streamBranch(String battleId, String teamId) async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      yield _battles[battleId]?[teamId];
    }
  }

  /// Stream all branches in battle
  Stream<List<BranchModel>> streamAllBranches(String battleId) async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      final branches = _battles[battleId]?.values.toList() ?? [];
      yield branches;
    }
  }

  /// Get all branches
  Future<List<BranchModel>> getAllBranches(String battleId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _battles[battleId]?.values.toList() ?? [];
  }

  /// Update code
  Future<void> updateCode({
    required String battleId,
    required String teamId,
    required String code,
    required String userId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final branch = _battles[battleId]?[teamId];
    if (branch == null) return;

    final lineCount = code.split('\n').length;
    final updatedStats = branch.stats.copyWith(
      lineCount: lineCount,
      lastEdit: DateTime.now(),
    );

    _battles[battleId]![teamId] = branch.copyWith(
      code: code,
      lastEditor: userId,
      stats: updatedStats,
    );
  }

  /// Update cursor position
  Future<void> updateCursor({
    required String battleId,
    required String teamId,
    required String userId,
    required int position,
    required int line,
  }) async {
    // Silent operation, very fast
    final branch = _battles[battleId]?[teamId];
    if (branch == null) return;

    final member = branch.members[userId];
    if (member == null) return;

    final updatedMember = member.copyWith(
      cursorPosition: position,
      cursorLine: line,
      lastActivity: DateTime.now(),
    );

    final updatedMembers = {...branch.members, userId: updatedMember};
    _battles[battleId]![teamId] = branch.copyWith(members: updatedMembers);
  }

  /// Update member status
  Future<void> updateMemberStatus({
    required String battleId,
    required String teamId,
    required String userId,
    required MemberStatus status,
    bool? isTyping,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final branch = _battles[battleId]?[teamId];
    if (branch == null) return;

    final member = branch.members[userId];
    if (member == null) return;

    final updatedMember = member.copyWith(
      status: status,
      isTyping: isTyping ?? member.isTyping,
      lastActivity: DateTime.now(),
    );

    final updatedMembers = {...branch.members, userId: updatedMember};
    _battles[battleId]![teamId] = branch.copyWith(members: updatedMembers);
    
    print('Member $userId status: $status');
  }

  /// Update test stats
  Future<void> updateTestStats({
    required String battleId,
    required String teamId,
    required int passed,
    required int failed,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final branch = _battles[battleId]?[teamId];
    if (branch == null) return;

    final updatedStats = branch.stats.copyWith(
      testRuns: branch.stats.testRuns + 1,
      testsPassed: branch.stats.testsPassed + passed,
      testsFailed: branch.stats.testsFailed + failed,
    );

    _battles[battleId]![teamId] = branch.copyWith(stats: updatedStats);
    print('Tests: $passed passed, $failed failed');
  }

  /// Submit branch
  Future<void> submitBranch({
    required String battleId,
    required String teamId,
    required String userId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final branch = _battles[battleId]?[teamId];
    if (branch == null) return;

    // Update all members to submitted status
    final updatedMembers = <String, BranchMember>{};
    for (final entry in branch.members.entries) {
      updatedMembers[entry.key] = entry.value.copyWith(
        status: MemberStatus.submitted,
      );
    }

    _battles[battleId]![teamId] = branch.copyWith(
      status: BranchStatus.submitted,
      submittedAt: DateTime.now(),
      members: updatedMembers,
    );

    print('Branch submitted: ${branch.teamName}');
  }

  /// Check if all branches submitted
  Future<bool> areAllBranchesSubmitted(String battleId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final branches = _battles[battleId]?.values.toList() ?? [];
    if (branches.isEmpty) return false;

    return branches.every((branch) => branch.isSubmitted());
  }

  /// Get branch color
  String getBranchColor(int index) {
    final colors = [
      '#2196F3', // Blue
      '#4CAF50', // Green
      '#FF9800', // Orange
      '#9C27B0', // Purple
      '#F44336', // Red
      '#00BCD4', // Cyan
      '#E91E63', // Pink
      '#009688', // Teal
    ];
    return colors[index % colors.length];
  }

  /// Clear all branches (for testing)
  static void clearAll() {
    _battles.clear();
    print('All mock branches cleared');
  }
}
