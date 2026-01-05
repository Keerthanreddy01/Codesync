/// App Color Palette - Ultrahuman Inspired Dark Theme
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Coral/Red accent
  static const Color primary = Color(0xFFFF6B6B); // Coral red
  static const Color primaryDark = Color(0xFFE85555);
  static const Color primaryLight = Color(0xFFFF8585);
  
  // Secondary Colors - Blue accent
  static const Color secondary = Color(0xFF4A9DFF); // Bright blue
  static const Color secondaryDark = Color(0xFF3B7FCC);
  static const Color secondaryLight = Color(0xFF6DB5FF);
  
  // Background Colors - Pure black theme
  static const Color background = Color(0xFF000000); // Pure black
  static const Color surface = Color(0xFF1C1C1E); // Card background
  static const Color surfaceVariant = Color(0xFF2C2C2E); // Elevated cards
  static const Color surfaceLight = Color(0xFF3A3A3C); // Hover states
  
  // Status Colors
  static const Color success = Color(0xFF34C759); // iOS green
  static const Color error = Color(0xFFFF453A); // iOS red
  static const Color warning = Color(0xFFFFD60A); // iOS yellow
  static const Color info = Color(0xFF64D2FF); // iOS blue
  
  // Text Colors - High contrast for readability
  static const Color textPrimary = Color(0xFFFFFFFF); // Pure white
  static const Color textSecondary = Color(0xFFAAAAAA); // Medium gray
  static const Color textTertiary = Color(0xFF666666); // Light gray
  static const Color textHint = Color(0xFF4D4D4D); // Subtle gray
  static const Color textMuted = Color(0xFF8E8E93); // iOS gray
  
  // Border Colors - Subtle separators
  static const Color border = Color(0xFF2C2C2E); // Subtle border
  static const Color borderLight = Color(0xFF3A3A3C); // Light border
  static const Color borderAccent = Color(0xFF48484A); // Emphasized border
  
  // Special Colors
  static const Color online = Color(0xFF34C759); // Active/online
  static const Color offline = Color(0xFF8E8E93); // Inactive
  static const Color away = Color(0xFFFFD60A); // Away status
  
  // Gradient Colors
  static const List<Color> primaryGradient = [Color(0xFFFF6B6B), Color(0xFFFF8585)];
  static const List<Color> secondaryGradient = [Color(0xFF4A9DFF), Color(0xFF6DB5FF)];
  static const List<Color> successGradient = [Color(0xFF34C759), Color(0xFF5FDB84)];
  
  // Special UI Colors
  static const Color cardShadow = Color(0x1A000000); // Subtle shadow
  static const Color overlay = Color(0x80000000); // Modal overlay
  static const Color divider = Color(0xFF2C2C2E); // Divider lines
}
