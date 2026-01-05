/// Authentication repository implementation
import 'package:dartz/dartz.dart';
import '../models/user_model.dart';
import '../models/auth_request_models.dart';
import '../data_sources/local/local_auth_data_source.dart';
import '../../services/auth/firebase_auth_service.dart';

abstract class AuthRepository {
  Future<Either<Exception, UserModel>> signup(SignupRequest request);
  Future<Either<Exception, UserModel>> login(LoginRequest request);
  Future<Either<Exception, UserModel>> signInWithGoogle();
  Future<Either<Exception, void>> sendPasswordResetEmail(String email);
  Future<Either<Exception, void>> updateUserProfile(
    String userId,
    String? username,
    String? displayName,
    String? bio,
    String? photoUrl,
  );
  Future<Either<Exception, void>> markOnboardingComplete(String userId);
  Future<Either<Exception, UserModel?>> getCurrentUser();
  Future<Either<Exception, void>> signOut();
  Future<Either<Exception, void>> deleteAccount(String userId);
  Stream<UserModel?> get authStateStream;
  bool get isAuthenticated;
}

/// Authentication repository implementation
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService _firebaseAuthService;
  final LocalAuthDataSource _localAuthDataSource;

  AuthRepositoryImpl({
    required FirebaseAuthService firebaseAuthService,
    required LocalAuthDataSource localAuthDataSource,
  })  : _firebaseAuthService = firebaseAuthService,
        _localAuthDataSource = localAuthDataSource;

  @override
  Future<Either<Exception, UserModel>> signup(SignupRequest request) async {
    try {
      // Validate input
      if (request.password != request.confirmPassword) {
        return Left(Exception('Passwords do not match'));
      }

      // Sign up with Firebase
      final userModel = await _firebaseAuthService.signupWithEmailPassword(
        email: request.email,
        password: request.password,
      );

      // Save to local storage
      await _localAuthDataSource.saveUser(userModel);

      return Right(userModel);
    } catch (e) {
      return Left(Exception('Signup failed: $e'));
    }
  }

  @override
  Future<Either<Exception, UserModel>> login(LoginRequest request) async {
    try {
      // Login with Firebase
      final userModel = await _firebaseAuthService.loginWithEmailPassword(
        email: request.email,
        password: request.password,
      );

      // Save to local storage
      await _localAuthDataSource.saveUser(userModel);

      return Right(userModel);
    } catch (e) {
      return Left(Exception('Login failed: $e'));
    }
  }

  @override
  Future<Either<Exception, UserModel>> signInWithGoogle() async {
    try {
      // Sign in with Google
      final userModel = await _firebaseAuthService.signInWithGoogle();

      // Save to local storage
      await _localAuthDataSource.saveUser(userModel);

      return Right(userModel);
    } catch (e) {
      return Left(Exception('Google sign-in failed: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuthService.sendPasswordResetEmail(email: email);
      return const Right(null);
    } catch (e) {
      return Left(Exception('Failed to send reset email: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> updateUserProfile(
    String userId,
    String? username,
    String? displayName,
    String? bio,
    String? photoUrl,
  ) async {
    try {
      await _firebaseAuthService.updateUserProfile(
        userId: userId,
        username: username,
        displayName: displayName,
        bio: bio,
        photoUrl: photoUrl,
      );

      // Update local cache
      final user = await _localAuthDataSource.getUser();
      if (user != null) {
        final updatedUser = user.copyWith(
          username: username ?? user.username,
          displayName: displayName ?? user.displayName,
          bio: bio ?? user.bio,
          photoUrl: photoUrl ?? user.photoUrl,
        );
        await _localAuthDataSource.saveUser(updatedUser);
      }

      return const Right(null);
    } catch (e) {
      return Left(Exception('Failed to update profile: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> markOnboardingComplete(String userId) async {
    try {
      await _firebaseAuthService.markOnboardingComplete(userId: userId);

      // Update local cache
      final user = await _localAuthDataSource.getUser();
      if (user != null) {
        final updatedUser = user.copyWith(hasCompletedOnboarding: true);
        await _localAuthDataSource.saveUser(updatedUser);
      }

      return const Right(null);
    } catch (e) {
      return Left(Exception('Failed to mark onboarding complete: $e'));
    }
  }

  @override
  Future<Either<Exception, UserModel?>> getCurrentUser() async {
    try {
      // Try to get from local cache first
      var user = await _localAuthDataSource.getUser();

      // If not in cache and user is authenticated, fetch from Firebase
      if (user == null && _firebaseAuthService.isAuthenticated) {
        final userId = _firebaseAuthService.currentUserId;
        if (userId != null) {
          user = await _firebaseAuthService.getUserById(userId: userId);
          if (user != null) {
            await _localAuthDataSource.saveUser(user);
          }
        }
      }

      return Right(user);
    } catch (e) {
      return Left(Exception('Failed to get current user: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> signOut() async {
    try {
      await _firebaseAuthService.signOut();
      await _localAuthDataSource.clearUser();
      return const Right(null);
    } catch (e) {
      return Left(Exception('Sign out failed: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> deleteAccount(String userId) async {
    try {
      await _firebaseAuthService.deleteAccount(userId: userId);
      await _localAuthDataSource.clearUser();
      return const Right(null);
    } catch (e) {
      return Left(Exception('Failed to delete account: $e'));
    }
  }

  @override
  Stream<UserModel?> get authStateStream {
    return _firebaseAuthService.authStateChanges.asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        await _localAuthDataSource.clearUser();
        return null;
      }

      final user = await _firebaseAuthService.getUserById(userId: firebaseUser.uid);
      if (user != null) {
        await _localAuthDataSource.saveUser(user);
      }
      return user;
    });
  }

  @override
  bool get isAuthenticated => _firebaseAuthService.isAuthenticated;
}
