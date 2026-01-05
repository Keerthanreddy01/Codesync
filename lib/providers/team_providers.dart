/// Team Providers - State Management
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/team_model.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

// Firebase Service Provider
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

// Current User ID Provider (placeholder - will be replaced with actual auth)
final currentUserIdProvider = StateProvider<String?>((ref) => null);

// Current User Provider
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return null;

  final service = ref.watch(firebaseServiceProvider);
  return service.getUser(userId);
});

// User Team Provider
final userTeamProvider = FutureProvider<TeamModel?>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return null;

  final service = ref.watch(firebaseServiceProvider);
  return service.getUserTeam(userId);
});

// Team Stream Provider (for real-time updates)
final teamStreamProvider = StreamProvider.family<TeamModel?, String>((ref, teamId) {
  final service = ref.watch(firebaseServiceProvider);
  return service.streamTeam(teamId);
});

// Team Members Provider
final teamMembersProvider = FutureProvider.family<List<UserModel>, List<String>>((ref, memberIds) async {
  final service = ref.watch(firebaseServiceProvider);
  return service.getTeamMembers(memberIds);
});

// Team Actions Provider
final teamActionsProvider = Provider<TeamActions>((ref) {
  return TeamActions(ref);
});

/// Team Actions Class - Handles all team-related operations
class TeamActions {
  final Ref ref;

  TeamActions(this.ref);

  Future<TeamModel> createTeam(String teamName) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final service = ref.read(firebaseServiceProvider);
    final team = await service.createTeam(
      teamName: teamName,
      leaderId: userId,
    );

    // Refresh user team
    ref.invalidate(userTeamProvider);

    return team;
  }

  Future<TeamModel> joinTeam(String teamCode) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final service = ref.read(firebaseServiceProvider);
    final team = await service.joinTeamByCode(
      teamCode: teamCode,
      userId: userId,
    );

    // Refresh user team
    ref.invalidate(userTeamProvider);

    return team;
  }

  Future<void> leaveTeam(String teamId) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final service = ref.read(firebaseServiceProvider);
    await service.leaveTeam(teamId: teamId, userId: userId);

    // Refresh user team
    ref.invalidate(userTeamProvider);
  }

  Future<void> deleteTeam(String teamId) async {
    final service = ref.read(firebaseServiceProvider);
    await service.deleteTeam(teamId);

    // Refresh user team
    ref.invalidate(userTeamProvider);
  }

  Future<void> updateUserStatus(bool isOnline) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    final service = ref.read(firebaseServiceProvider);
    await service.updateUserStatus(userId: userId, isOnline: isOnline);
  }
}
