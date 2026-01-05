/// Domain entities for authentication
import 'package:equatable/equatable.dart';

/// User entity representing an authenticated user
class User extends Equatable {
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

  const User({
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

  /// Create a copy with updated fields
  User copyWith({
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
    return User(
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

  /// Check if profile is complete
  bool get isProfileComplete => username != null && displayName != null;

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

/// Authentication state
class AuthState extends Equatable {
  final bool isAuthenticated;
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.isAuthenticated = false,
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isAuthenticated, user, isLoading, error];
}
