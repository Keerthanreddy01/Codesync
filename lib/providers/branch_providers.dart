/// Branch Providers - State Management
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/branch_model.dart';
import '../services/branch_service.dart';
import '../services/mock_branch_service.dart';

// Use mock service for now (until Firebase is configured)
const bool USE_MOCK = true;

// Branch Service Provider
final branchServiceProvider = Provider<dynamic>((ref) {
  return USE_MOCK ? MockBranchService() : BranchService();
});

// Current Branch ID Provider (team ID)
final currentBranchIdProvider = StateProvider<String?>((ref) => null);

// Current Battle ID Provider
final currentBattleIdForBranchProvider = StateProvider<String?>((ref) => null);

// Current Branch Stream Provider
final currentBranchProvider = StreamProvider<BranchModel?>((ref) {
  final battleId = ref.watch(currentBattleIdForBranchProvider);
  final branchId = ref.watch(currentBranchIdProvider);
  
  if (battleId == null || branchId == null) return Stream.value(null);

  final service = ref.watch(branchServiceProvider);
  return service.streamBranch(battleId, branchId);
});

// All Branches Stream Provider
final allBranchesProvider = StreamProvider<List<BranchModel>>((ref) {
  final battleId = ref.watch(currentBattleIdForBranchProvider);
  
  if (battleId == null) return Stream.value([]);

  final service = ref.watch(branchServiceProvider);
  return service.streamAllBranches(battleId);
});

// Code Sync Provider (with debouncing)
final codeSyncProvider = Provider<CodeSyncManager>((ref) => CodeSyncManager(ref));

// Branch Actions Provider
final branchActionsProvider = Provider<BranchActions>((ref) => BranchActions(ref));

/// Code Sync Manager - Handles debounced code synchronization
class CodeSyncManager {
  final Ref ref;
  Timer? _debounceTimer;
  String? _pendingCode;
  bool _isSyncing = false;

  CodeSyncManager(this.ref);

  /// Sync code with debouncing (500ms delay)
  void syncCode(String code, String userId) {
    _pendingCode = code;
    
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSync(userId);
    });
  }

  Future<void> _performSync(String userId) async {
    if (_pendingCode == null || _isSyncing) return;

    final battleId = ref.read(currentBattleIdForBranchProvider);
    final branchId = ref.read(currentBranchIdProvider);
    
    if (battleId == null || branchId == null) return;

    _isSyncing = true;
    
    try {
      final service = ref.read(branchServiceProvider);
      await service.updateCode(
        battleId: battleId,
        teamId: branchId,
        code: _pendingCode!,
        userId: userId,
      );
      _pendingCode = null;
    } catch (e) {
      print('Sync error: $e');
    } finally {
      _isSyncing = false;
    }
  }

  void dispose() {
    _debounceTimer?.cancel();
  }
}

/// Branch Actions - All branch operations
class BranchActions {
  final Ref ref;

  BranchActions(this.ref);

  /// Create branches for all teams when battle starts
  Future<List<BranchModel>> createBranchesForBattle({
    required String battleId,
    required Map<String, List<String>> teams, // teamId -> memberIds
    required String starterCode,
  }) async {
    final service = ref.read(branchServiceProvider);
    final branches = <BranchModel>[];

    for (final entry in teams.entries) {
      final teamId = entry.key;
      final memberIds = entry.value;
      final teamName = 'Team ${teams.keys.toList().indexOf(teamId) + 1}';

      final branch = await service.createBranch(
        battleId: battleId,
        teamId: teamId,
        teamName: teamName,
        starterCode: starterCode,
        memberIds: memberIds,
      );
      
      branches.add(branch);
    }

    return branches;
  }

  /// Update cursor position (throttled to 100ms)
  Timer? _cursorTimer;
  void updateCursor({
    required String userId,
    required int position,
    required int line,
  }) {
    _cursorTimer?.cancel();
    _cursorTimer = Timer(const Duration(milliseconds: 100), () {
      _performCursorUpdate(userId, position, line);
    });
  }

  Future<void> _performCursorUpdate(String userId, int position, int line) async {
    final battleId = ref.read(currentBattleIdForBranchProvider);
    final branchId = ref.read(currentBranchIdProvider);
    
    if (battleId == null || branchId == null) return;

    final service = ref.read(branchServiceProvider);
    await service.updateCursor(
      battleId: battleId,
      teamId: branchId,
      userId: userId,
      position: position,
      line: line,
    );
  }

  /// Update member status
  Future<void> updateStatus({
    required String userId,
    required MemberStatus status,
    bool? isTyping,
  }) async {
    final battleId = ref.read(currentBattleIdForBranchProvider);
    final branchId = ref.read(currentBranchIdProvider);
    
    if (battleId == null || branchId == null) return;

    final service = ref.read(branchServiceProvider);
    await service.updateMemberStatus(
      battleId: battleId,
      teamId: branchId,
      userId: userId,
      status: status,
      isTyping: isTyping,
    );
  }

  /// Submit branch
  Future<void> submitBranch(String userId) async {
    final battleId = ref.read(currentBattleIdForBranchProvider);
    final branchId = ref.read(currentBranchIdProvider);
    
    if (battleId == null || branchId == null) {
      throw Exception('No active branch');
    }

    final service = ref.read(branchServiceProvider);
    await service.submitBranch(
      battleId: battleId,
      teamId: branchId,
      userId: userId,
    );

    // Check if all branches submitted
    final allSubmitted = await service.areAllBranchesSubmitted(battleId);
    if (allSubmitted) {
      // Trigger judging
      // This will be handled by battle service
    }
  }

  /// Update test statistics
  Future<void> updateTestStats({
    required int passed,
    required int failed,
  }) async {
    final battleId = ref.read(currentBattleIdForBranchProvider);
    final branchId = ref.read(currentBranchIdProvider);
    
    if (battleId == null || branchId == null) return;

    final service = ref.read(branchServiceProvider);
    await service.updateTestStats(
      battleId: battleId,
      teamId: branchId,
      passed: passed,
      failed: failed,
    );
  }

  /// Check if user can edit branch
  bool canUserEditBranch(String userId, BranchModel? branch) {
    if (branch == null) return false;
    return branch.canEdit(userId);
  }
}
