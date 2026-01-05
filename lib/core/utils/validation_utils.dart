/// Input validation utilities
class ValidationUtils {
  /// Validate email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validate password strength
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain uppercase letters';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain lowercase letters';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain numbers';
    }
    return null;
  }

  /// Validate password confirmation
  static String? validatePasswordConfirmation(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validate username
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    if (value.length > 32) {
      return 'Username must not exceed 32 characters';
    }
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_-]+$');
    if (!usernameRegex.hasMatch(value)) {
      return 'Username can only contain letters, numbers, hyphens, and underscores';
    }
    return null;
  }

  /// Validate display name
  static String? validateDisplayName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Display name is required';
    }
    if (value.length < 2) {
      return 'Display name must be at least 2 characters';
    }
    if (value.length > 50) {
      return 'Display name must not exceed 50 characters';
    }
    return null;
  }

  /// Validate bio
  static String? validateBio(String? value) {
    if (value != null && value.length > 500) {
      return 'Bio must not exceed 500 characters';
    }
    return null;
  }

  /// Check password strength score (0-4)
  static int getPasswordStrengthScore(String password) {
    int score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    return score;
  }

  /// Get password strength label
  static String getPasswordStrengthLabel(int score) {
    return switch (score) {
      0 => 'Very Weak',
      1 => 'Weak',
      2 => 'Fair',
      3 => 'Good',
      4 => 'Strong',
      _ => 'Unknown',
    };
  }

  /// Get password strength color
  static String getPasswordStrengthColor(int score) {
    return switch (score) {
      0 => '#EF4444', // Red
      1 => '#F59E0B', // Orange
      2 => '#EAB308', // Yellow
      3 => '#84CC16', // Lime
      4 => '#22C55E', // Green
      _ => '#6B7280', // Gray
    };
  }
}
