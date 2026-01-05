/// Authentication request models
import 'package:equatable/equatable.dart';

class SignupRequest extends Equatable {
  final String email;
  final String password;
  final String confirmPassword;

  const SignupRequest({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [email, password, confirmPassword];
}

class LoginRequest extends Equatable {
  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class ProfileSetupRequest extends Equatable {
  final String username;
  final String? displayName;
  final String? bio;
  final String? photoUrl;

  const ProfileSetupRequest({
    required this.username,
    this.displayName,
    this.bio,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [username, displayName, bio, photoUrl];
}

class PasswordResetRequest extends Equatable {
  final String email;

  const PasswordResetRequest({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}

class UpdatePasswordRequest extends Equatable {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  const UpdatePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword, confirmPassword];
}
