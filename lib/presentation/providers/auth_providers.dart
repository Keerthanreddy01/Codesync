/// Riverpod providers for authentication
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth/firebase_auth_service.dart';
import '../../data/data_sources/local/local_auth_data_source.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';
import '../../data/models/auth_request_models.dart';
import '../../domain/entities/user_entity.dart';

// Firebase Auth Service Provider
final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});

// Local Data Source Provider
final localAuthDataSourceProvider = FutureProvider<LocalAuthDataSource>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return LocalAuthDataSourceImpl(prefs: prefs);
});

// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firebaseAuthService = ref.watch(firebaseAuthServiceProvider);
  final localDataSource = ref.watch(localAuthDataSourceProvider).maybeWhen(
    data: (dataSource) => dataSource,
    orElse: () => throw Exception('Local data source not initialized'),
  );
  return AuthRepositoryImpl(
    firebaseAuthService: firebaseAuthService,
    localAuthDataSource: localDataSource,
  );
});

// Current User Provider
final currentUserProvider = StreamProvider<UserModel?>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.authStateStream;
});

// Auth State Provider
final authStateProvider = StreamProvider<AuthState>((ref) {
  final userStream = ref.watch(currentUserProvider);
  
  return userStream.map((userModel) {
    if (userModel != null) {
      final user = User(
        id: userModel.id,
        email: userModel.email,
        displayName: userModel.displayName,
        photoUrl: userModel.photoUrl,
        username: userModel.username,
        bio: userModel.bio,
        xp: userModel.xp,
        level: userModel.level,
        createdAt: userModel.createdAt,
        lastSignedIn: userModel.lastSignedIn,
        emailVerified: userModel.emailVerified,
        hasCompletedOnboarding: userModel.hasCompletedOnboarding,
      );
      return AuthState(
        isAuthenticated: true,
        user: user,
        isLoading: false,
      );
    } else {
      return const AuthState(
        isAuthenticated: false,
        user: null,
        isLoading: false,
      );
    }
  });
});

// Sign Up Provider
final signupProvider = FutureProvider.family<UserModel?, SignupRequest>((ref, request) async {
  final authRepo = ref.watch(authRepositoryProvider);
  final result = await authRepo.signup(request);
  return result.fold(
    (error) {
      ref.invalidate(authStateProvider);
      throw error;
    },
    (user) => user,
  );
});

// Login Provider
final loginProvider = FutureProvider.family<UserModel?, LoginRequest>((ref, request) async {
  final authRepo = ref.watch(authRepositoryProvider);
  final result = await authRepo.login(request);
  return result.fold(
    (error) {
      ref.invalidate(authStateProvider);
      throw error;
    },
    (user) => user,
  );
});

// Google Sign-In Provider
final googleSignInProvider = FutureProvider<UserModel?>((ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  final result = await authRepo.signInWithGoogle();
  return result.fold(
    (error) {
      ref.invalidate(authStateProvider);
      throw error;
    },
    (user) => user,
  );
});

// Password Reset Provider
final passwordResetProvider = FutureProvider.family<void, String>((ref, email) async {
  final authRepo = ref.watch(authRepositoryProvider);
  final result = await authRepo.sendPasswordResetEmail(email);
  return result.fold(
    (error) => throw error,
    (success) => success,
  );
});

// Update Profile Provider
final updateProfileProvider = FutureProvider.family<void, (String, String?, String?, String?, String?)>((ref, params) async {
  final authRepo = ref.watch(authRepositoryProvider);
  final (userId, username, displayName, bio, photoUrl) = params;
  final result = await authRepo.updateUserProfile(
    userId,
    username,
    displayName,
    bio,
    photoUrl,
  );
  return result.fold(
    (error) => throw error,
    (success) => success,
  );
});

// Mark Onboarding Complete Provider
final markOnboardingCompleteProvider = FutureProvider.family<void, String>((ref, userId) async {
  final authRepo = ref.watch(authRepositoryProvider);
  final result = await authRepo.markOnboardingComplete(userId);
  return result.fold(
    (error) => throw error,
    (success) => success,
  );
});

// Sign Out Provider
final signOutProvider = FutureProvider<void>((ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  final result = await authRepo.signOut();
  return result.fold(
    (error) => throw error,
    (success) {
      ref.invalidate(authStateProvider);
      return success;
    },
  );
});

// Is Authenticated Provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(
    data: (state) => state.isAuthenticated,
    orElse: () => false,
  );
});

// Is Profile Complete Provider
final isProfileCompleteProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(
    data: (state) => state.user?.isProfileComplete ?? false,
    orElse: () => false,
  );
});

// Has Completed Onboarding Provider
final hasCompletedOnboardingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(
    data: (state) => state.user?.hasCompletedOnboarding ?? false,
    orElse: () => false,
  );
});
