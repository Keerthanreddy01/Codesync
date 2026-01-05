/// Application theme constants and color definitions
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF3B82F6); // Blue
  static const Color primaryDark = Color(0xFF1E40AF);
  static const Color primaryLight = Color(0xFF60A5FA);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF10B981); // Green
  static const Color secondaryDark = Color(0xFF047857);
  static const Color secondaryLight = Color(0xFF6EE7B7);
  
  // Background Colors
  static const Color background = Color(0xFF0D1117);
  static const Color surface = Color(0xFF161B22);
  static const Color surfaceVariant = Color(0xFF21262D);
  
  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB6BAC3);
  static const Color textMuted = Color(0xFF8B949E);
  static const Color textHint = Color(0xFF6E7681);
  
  // Border Colors
  static const Color border = Color(0xFF30363D);
  static const Color borderLight = Color(0xFF444C56);
  
  // Divider
  static const Color divider = Color(0xFF21262D);
  
  // Special Colors
  static const Color skeleton = Color(0xFF21262D);
  static const Color overlay = Color(0x80000000);
}

class AppTextTheme {
  static const String fontFamily = 'Inter';
  static const String codeFont = 'JetBrainsMono';
  
  // Heading
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
  );
  
  // Subheading
  static const TextStyle subheading1 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle subheading2 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
  );
  
  // Body
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  // Caption
  static const TextStyle caption1 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
    color: AppColors.textMuted,
  );
  
  static const TextStyle caption2 = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
    color: AppColors.textMuted,
  );
  
  // Button
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );
  
  // Code
  static const TextStyle code = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    fontFamily: codeFont,
    color: AppColors.textPrimary,
  );
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

class AppBorderRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double full = 9999;
}

class AppElevation {
  static const double none = 0;
  static const double sm = 2;
  static const double md = 4;
  static const double lg = 8;
  static const double xl = 16;
  static const double xxl = 24;
}

class AppDurations {
  static const Duration shortest = Duration(milliseconds: 150);
  static const Duration short = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration long = Duration(milliseconds: 500);
  static const Duration veryLong = Duration(milliseconds: 1000);
}

class AppCurves {
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve linear = Curves.linear;
  static const Curve decelerate = Curves.decelerate;
}
