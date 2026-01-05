/// Firebase Service - Team Management
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/team_model.dart';
import '../models/user_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  static const String teamsCollection = 'teams';
  static const String usersCollection = 'users';
  static const String teamCodesCollection = 'teamCodes';

  // ===== TEAM OPERATIONS =====

  /// Create a new team
  Future<TeamModel> createTeam({
    required String teamName,
    required String leaderId,
  }) async {
    try {
      // Generate unique team code
      final teamCode = _generateTeamCode();
      
      // Create team document
      final teamRef = _firestore.collection(teamsCollection).doc();
      final team = TeamModel.create(
        id: teamRef.id,
        name: teamName,
        leaderId: leaderId,
        teamCode: teamCode,
      );

      // Save team to Firestore
      await teamRef.set(team.toJson());

      // Save team code mapping for quick lookups
      await _firestore.collection(teamCodesCollection).doc(teamCode).set({
        'teamId': team.id,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Update user's teamId
      await _firestore.collection(usersCollection).doc(leaderId).update({
        'teamId': team.id,
      });

      return team;
    } catch (e) {
      throw Exception('Failed to create team: $e');
    }
  }

  /// Join team by code
  Future<TeamModel> joinTeamByCode({
    required String teamCode,
    required String userId,
  }) async {
    try {
      // Get team ID from code
      final codeDoc = await _firestore
          .collection(teamCodesCollection)
          .doc(teamCode.toUpperCase())
          .get();

      if (!codeDoc.exists) {
        throw Exception('Invalid team code');
      }

      final teamId = codeDoc.data()!['teamId'] as String;

      // Get team
      final teamDoc = await _firestore
          .collection(teamsCollection)
          .doc(teamId)
          .get();

      if (!teamDoc.exists) {
        throw Exception('Team not found');
      }

      final team = TeamModel.fromJson(teamDoc.data()!);

      // Check if user is already a member
      if (team.memberIds.contains(userId)) {
        throw Exception('Already a member of this team');
      }

      // Add user to team
      await _firestore.collection(teamsCollection).doc(teamId).update({
        'memberIds': FieldValue.arrayUnion([userId]),
      });

      // Update user's teamId
      await _firestore.collection(usersCollection).doc(userId).update({
        'teamId': teamId,
      });

      // Return updated team
      final updatedTeam = team.copyWith(
        memberIds: [...team.memberIds, userId],
      );

      return updatedTeam;
    } catch (e) {
      throw Exception('Failed to join team: $e');
    }
  }

  /// Leave team
  Future<void> leaveTeam({
    required String teamId,
    required String userId,
  }) async {
    try {
      final teamDoc = await _firestore
          .collection(teamsCollection)
          .doc(teamId)
          .get();

      if (!teamDoc.exists) {
        throw Exception('Team not found');
      }

      final team = TeamModel.fromJson(teamDoc.data()!);

      // Check if user is the leader
      if (team.leaderId == userId) {
        // If leader leaves, delete the team (or transfer leadership)
        await deleteTeam(teamId);
      } else {
        // Remove user from team
        await _firestore.collection(teamsCollection).doc(teamId).update({
          'memberIds': FieldValue.arrayRemove([userId]),
        });

        // Update user's teamId
        await _firestore.collection(usersCollection).doc(userId).update({
          'teamId': null,
        });
      }
    } catch (e) {
      throw Exception('Failed to leave team: $e');
    }
  }

  /// Delete team (only leader can do this)
  Future<void> deleteTeam(String teamId) async {
    try {
      final teamDoc = await _firestore
          .collection(teamsCollection)
          .doc(teamId)
          .get();

      if (!teamDoc.exists) {
        throw Exception('Team not found');
      }

      final team = TeamModel.fromJson(teamDoc.data()!);

      // Remove team from all members
      for (final memberId in team.memberIds) {
        await _firestore.collection(usersCollection).doc(memberId).update({
          'teamId': null,
        });
      }

      // Delete team code mapping
      await _firestore
          .collection(teamCodesCollection)
          .doc(team.teamCode)
          .delete();

      // Delete team document
      await _firestore.collection(teamsCollection).doc(teamId).delete();
    } catch (e) {
      throw Exception('Failed to delete team: $e');
    }
  }

  /// Get team by ID
  Future<TeamModel?> getTeam(String teamId) async {
    try {
      final doc = await _firestore
          .collection(teamsCollection)
          .doc(teamId)
          .get();

      if (!doc.exists) return null;

      return TeamModel.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('Failed to get team: $e');
    }
  }

  /// Stream team updates
  Stream<TeamModel?> streamTeam(String teamId) {
    return _firestore
        .collection(teamsCollection)
        .doc(teamId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return TeamModel.fromJson(doc.data()!);
    });
  }

  /// Get user's team
  Future<TeamModel?> getUserTeam(String userId) async {
    try {
      final userDoc = await _firestore
          .collection(usersCollection)
          .doc(userId)
          .get();

      if (!userDoc.exists) return null;

      final userData = userDoc.data()!;
      final teamId = userData['teamId'] as String?;

      if (teamId == null) return null;

      return getTeam(teamId);
    } catch (e) {
      throw Exception('Failed to get user team: $e');
    }
  }

  // ===== USER OPERATIONS =====

  /// Create or update user
  Future<void> saveUser(UserModel user) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(user.id)
          .set(user.toJson(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save user: $e');
    }
  }

  /// Get user by ID
  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _firestore
          .collection(usersCollection)
          .doc(userId)
          .get();

      if (!doc.exists) return null;

      return UserModel.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  /// Update user online status
  Future<void> updateUserStatus({
    required String userId,
    required bool isOnline,
  }) async {
    try {
      await _firestore.collection(usersCollection).doc(userId).update({
        'isOnline': isOnline,
        'lastSeen': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to update user status: $e');
    }
  }

  /// Get team members
  Future<List<UserModel>> getTeamMembers(List<String> memberIds) async {
    try {
      if (memberIds.isEmpty) return [];

      final users = <UserModel>[];
      
      // Firestore has a limit of 10 items in 'in' queries, so batch if needed
      for (int i = 0; i < memberIds.length; i += 10) {
        final batch = memberIds.skip(i).take(10).toList();
        final snapshot = await _firestore
            .collection(usersCollection)
            .where(FieldPath.documentId, whereIn: batch)
            .get();

        users.addAll(
          snapshot.docs.map((doc) => UserModel.fromJson(doc.data())),
        );
      }

      return users;
    } catch (e) {
      throw Exception('Failed to get team members: $e');
    }
  }

  // ===== HELPER METHODS =====

  /// Generate a unique 6-character team code
  String _generateTeamCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // Removed similar chars
    final random = Random();
    return List.generate(
      6,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }
}
