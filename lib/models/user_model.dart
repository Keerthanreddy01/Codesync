/// User Model
class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? teamId;
  final bool isOnline;
  final DateTime lastSeen;
  final int totalWins;
  final int totalLosses;
  final int problemsSolved;

  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.teamId,
    this.isOnline = false,
    required this.lastSeen,
    this.totalWins = 0,
    this.totalLosses = 0,
    this.problemsSolved = 0,
  });

  // Convert from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      teamId: json['teamId'] as String?,
      isOnline: json['isOnline'] as bool? ?? false,
      lastSeen: DateTime.parse(json['lastSeen'] as String),
      totalWins: json['totalWins'] as int? ?? 0,
      totalLosses: json['totalLosses'] as int? ?? 0,
      problemsSolved: json['problemsSolved'] as int? ?? 0,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'teamId': teamId,
      'isOnline': isOnline,
      'lastSeen': lastSeen.toIso8601String(),
      'totalWins': totalWins,
      'totalLosses': totalLosses,
      'problemsSolved': problemsSolved,
    };
  }

  // Check if user is in a team
  bool get hasTeam => teamId != null;

  // Get win rate
  double get winRate {
    final total = totalWins + totalLosses;
    if (total == 0) return 0.0;
    return (totalWins / total) * 100;
  }

  // Copy with modifications
  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? teamId,
    bool? isOnline,
    DateTime? lastSeen,
    int? totalWins,
    int? totalLosses,
    int? problemsSolved,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      teamId: teamId ?? this.teamId,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      totalWins: totalWins ?? this.totalWins,
      totalLosses: totalLosses ?? this.totalLosses,
      problemsSolved: problemsSolved ?? this.problemsSolved,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $displayName, teamId: $teamId)';
  }
}
