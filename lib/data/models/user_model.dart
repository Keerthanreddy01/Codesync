/// User authentication model
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? username;
  final String? bio;
  final int xp;
  final int level;
  final DateTime createdAt;
  final DateTime lastSignedIn;
  final bool emailVerified;
  final bool hasCompletedOnboarding;

  const UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.username,
    this.bio,
    this.xp = 0,
    this.level = 1,
    required this.createdAt,
    required this.lastSignedIn,
    this.emailVerified = false,
    this.hasCompletedOnboarding = false,
  });

  /// Create a copy of this model with updated fields
  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    String? username,
    String? bio,
    int? xp,
    int? level,
    DateTime? createdAt,
    DateTime? lastSignedIn,
    bool? emailVerified,
    bool? hasCompletedOnboarding,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      createdAt: createdAt ?? this.createdAt,
      lastSignedIn: lastSignedIn ?? this.lastSignedIn,
      emailVerified: emailVerified ?? this.emailVerified,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'displayName': displayName,
    'photoUrl': photoUrl,
    'username': username,
    'bio': bio,
    'xp': xp,
    'level': level,
    'createdAt': createdAt.toIso8601String(),
    'lastSignedIn': lastSignedIn.toIso8601String(),
    'emailVerified': emailVerified,
    'hasCompletedOnboarding': hasCompletedOnboarding,
  };

  /// Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    email: json['email'] as String,
    displayName: json['displayName'] as String?,
    photoUrl: json['photoUrl'] as String?,
    username: json['username'] as String?,
    bio: json['bio'] as String?,
    xp: json['xp'] as int? ?? 0,
    level: json['level'] as int? ?? 1,
    createdAt: DateTime.parse(json['createdAt'] as String),
    lastSignedIn: DateTime.parse(json['lastSignedIn'] as String),
    emailVerified: json['emailVerified'] as bool? ?? false,
    hasCompletedOnboarding: json['hasCompletedOnboarding'] as bool? ?? false,
  );

  @override
  List<Object?> get props => [
    id,
    email,
    displayName,
    photoUrl,
    username,
    bio,
    xp,
    level,
    createdAt,
    lastSignedIn,
    emailVerified,
    hasCompletedOnboarding,
  ];
}
