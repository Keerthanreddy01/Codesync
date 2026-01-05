/// Firebase authentication service
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/user_model.dart';

class FirebaseAuthService {
  final fb.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  FirebaseAuthService({
    fb.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get current user
  fb.User? get currentUser => _firebaseAuth.currentUser;

  /// Get current user ID
  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  /// Check if user is authenticated
  bool get isAuthenticated => _firebaseAuth.currentUser != null;

  /// Get authentication state changes stream
  Stream<fb.User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Sign up with email and password
  Future<UserModel> signupWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw Exception('Failed to create user account');
      }

      // Create user document in Firestore
      final userModel = UserModel(
        id: user.uid,
        email: user.email ?? '',
        createdAt: DateTime.now(),
        lastSignedIn: DateTime.now(),
        emailVerified: false,
      );

      await _firestore.collection('users').doc(user.uid).set(userModel.toJson());

      return userModel;
    } on fb.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Login with email and password
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw Exception('Failed to login');
      }

      // Update last signed in time
      await _firestore.collection('users').doc(user.uid).update({
        'lastSignedIn': DateTime.now().toIso8601String(),
      });

      // Fetch user data
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      return UserModel.fromJson(userDoc.data() ?? {});
    } on fb.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign in with Google
  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign-in cancelled');
      }

      final googleAuth = await googleUser.authentication;
      final credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        throw Exception('Failed to sign in with Google');
      }

      // Check if user already exists
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      
      if (userDoc.exists) {
        // Update last signed in time
        await _firestore.collection('users').doc(user.uid).update({
          'lastSignedIn': DateTime.now().toIso8601String(),
        });
        return UserModel.fromJson(userDoc.data() ?? {});
      } else {
        // Create new user document
        final userModel = UserModel(
          id: user.uid,
          email: user.email ?? '',
          displayName: user.displayName,
          photoUrl: user.photoURL,
          createdAt: DateTime.now(),
          lastSignedIn: DateTime.now(),
          emailVerified: user.emailVerified,
        );

        await _firestore.collection('users').doc(user.uid).set(userModel.toJson());
        return userModel;
      }
    } catch (e) {
      throw Exception('Google sign-in failed: $e');
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on fb.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Reset password with code
  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async {
    try {
      await _firebaseAuth.confirmPasswordReset(
        code: code,
        newPassword: newPassword,
      );
    } on fb.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Update user profile
  Future<void> updateUserProfile({
    required String userId,
    String? username,
    String? displayName,
    String? bio,
    String? photoUrl,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (username != null) data['username'] = username;
      if (displayName != null) data['displayName'] = displayName;
      if (bio != null) data['bio'] = bio;
      if (photoUrl != null) data['photoUrl'] = photoUrl;

      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  /// Mark onboarding as completed
  Future<void> markOnboardingComplete({required String userId}) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'hasCompletedOnboarding': true,
      });
    } catch (e) {
      throw Exception('Failed to update onboarding status: $e');
    }
  }

  /// Get user by ID
  Future<UserModel?> getUserById({required String userId}) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return UserModel.fromJson(userDoc.data() ?? {});
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch user: $e');
    }
  }

  /// Send email verification
  Future<void> sendEmailVerification() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } on fb.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  /// Delete account
  Future<void> deleteAccount({required String userId}) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        // Delete user document from Firestore
        await _firestore.collection('users').doc(userId).delete();
        // Delete Firebase Auth account
        await user.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  /// Handle Firebase authentication exceptions
  Exception _handleAuthException(fb.FirebaseAuthException e) {
    return switch (e.code) {
      'invalid-email' => Exception('Invalid email address'),
      'user-disabled' => Exception('This account has been disabled'),
      'user-not-found' => Exception('User not found'),
      'wrong-password' => Exception('Incorrect password'),
      'email-already-in-use' => Exception('Email already in use'),
      'operation-not-allowed' => Exception('Operation not allowed'),
      'weak-password' => Exception('Password is too weak'),
      'invalid-credential' => Exception('Invalid credentials'),
      'account-exists-with-different-credential' => Exception('Account exists with different credentials'),
      'invalid-verification-code' => Exception('Invalid verification code'),
      'invalid-verification-id' => Exception('Invalid verification ID'),
      _ => Exception('Authentication failed: ${e.message}'),
    };
  }
}
