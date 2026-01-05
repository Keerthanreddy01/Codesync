/// Application-wide constants
class AppConstants {
  // Firebase
  static const String firebaseProjectId = 'codesync-arena';
  
  // Authentication
  static const String googleClientId = 'YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com';
  
  // App Information
  static const String appName = 'CodeSync Arena';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Multiplayer competitive coding platform with real-time collaboration';
  
  // Constraints
  static const int minPasswordLength = 8;
  static const int maxTeamMembers = 10;
  static const int minTeamMembers = 1;
  static const int maxUsernameLength = 32;
  static const int minUsernameLength = 3;
  static const int maxBioLength = 500;
  
  // Timeouts
  static const Duration authTimeout = Duration(seconds: 30);
  static const Duration firebaseTimeout = Duration(seconds: 15);
  static const Duration syncDebounce = Duration(milliseconds: 200);
  static const Duration codeExecutionTimeout = Duration(seconds: 10);
  
  // API Endpoints
  static const String judge0ApiUrl = 'https://judge0-api.p.rapidapi.com';
  
  // Local Storage Keys
  static const String userPrefsKey = 'user_prefs';
  static const String authTokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String hasCompletedOnboardingKey = 'has_completed_onboarding';
  static const String selectedThemeKey = 'selected_theme';
  
  // Error Messages
  static const String networkError = 'Network connection error. Please try again.';
  static const String authError = 'Authentication failed. Please try again.';
  static const String userNotFound = 'User not found.';
  static const String invalidCredentials = 'Invalid email or password.';
  static const String emailAlreadyInUse = 'This email is already registered.';
  static const String weakPassword = 'Password is too weak. Use at least 8 characters with uppercase, lowercase, and numbers.';
  static const String invalidEmail = 'Please enter a valid email address.';
  static const String unknownError = 'An unexpected error occurred. Please try again.';
  static const String offlineError = 'You are offline. Some features may be unavailable.';
  
  // Success Messages
  static const String signupSuccess = 'Account created successfully!';
  static const String loginSuccess = 'Welcome back!';
  static const String passwordResetSuccess = 'Password reset email sent. Check your inbox.';
  static const String profileUpdateSuccess = 'Profile updated successfully!';
  static const String emailVerificationSent = 'Verification email sent. Please check your inbox.';
}
