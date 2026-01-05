/// Team Model
import 'package:cloud_firestore/cloud_firestore.dart';

class TeamModel {
  final String id;
  final String name;
  final String leaderId;
  final List<String> memberIds;
  final DateTime createdAt;
  final int wins;
  final int losses;
  final int battlesPlayed;
  final String teamCode; // 6-character alphanumeric code for invites
  final bool isActive;

  TeamModel({
    required this.id,
    required this.name,
    required this.leaderId,
    required this.memberIds,
    required this.createdAt,
    this.wins = 0,
    this.losses = 0,
    this.battlesPlayed = 0,
    required this.teamCode,
    this.isActive = true,
  });

  // Create a new team
  factory TeamModel.create({
    required String id,
    required String name,
    required String leaderId,
    required String teamCode,
  }) {
    return TeamModel(
      id: id,
      name: name,
      leaderId: leaderId,
      memberIds: [leaderId], // Leader is automatically a member
      createdAt: DateTime.now(),
      teamCode: teamCode,
    );
  }

  // Convert from Firestore document
  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'] as String,
      name: json['name'] as String,
      leaderId: json['leaderId'] as String,
      memberIds: List<String>.from(json['memberIds'] as List),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      wins: json['wins'] as int? ?? 0,
      losses: json['losses'] as int? ?? 0,
      battlesPlayed: json['battlesPlayed'] as int? ?? 0,
      teamCode: json['teamCode'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'leaderId': leaderId,
      'memberIds': memberIds,
      'createdAt': Timestamp.fromDate(createdAt),
      'wins': wins,
      'losses': losses,
      'battlesPlayed': battlesPlayed,
      'teamCode': teamCode,
      'isActive': isActive,
    };
  }

  // Get win rate percentage
  double get winRate {
    if (battlesPlayed == 0) return 0.0;
    return (wins / battlesPlayed) * 100;
  }

  // Check if user is team leader
  bool isLeader(String userId) => leaderId == userId;

  // Check if user is team member
  bool isMember(String userId) => memberIds.contains(userId);

  // Get member count
  int get memberCount => memberIds.length;

  // Copy with modifications
  TeamModel copyWith({
    String? id,
    String? name,
    String? leaderId,
    List<String>? memberIds,
    DateTime? createdAt,
    int? wins,
    int? losses,
    int? battlesPlayed,
    String? teamCode,
    bool? isActive,
  }) {
    return TeamModel(
      id: id ?? this.id,
      name: name ?? this.name,
      leaderId: leaderId ?? this.leaderId,
      memberIds: memberIds ?? this.memberIds,
      createdAt: createdAt ?? this.createdAt,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      battlesPlayed: battlesPlayed ?? this.battlesPlayed,
      teamCode: teamCode ?? this.teamCode,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'TeamModel(id: $id, name: $name, members: ${memberIds.length}, wins: $wins, losses: $losses)';
  }
}
