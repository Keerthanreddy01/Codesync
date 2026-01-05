/// App Text Styles - Ultrahuman Inspired Typography
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Large Display Styles
  static TextStyle display1 = GoogleFonts.inter(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    letterSpacing: -1.0,
    height: 1.2,
  );

  static TextStyle display2 = GoogleFonts.inter(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.8,
    height: 1.2,
  );

  // Heading Styles
  static TextStyle heading1 = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.6,
    height: 1.3,
  );

  static TextStyle heading2 = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.4,
    height: 1.3,
  );

  static TextStyle heading3 = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.4,
  );

  // Body Styles
  static TextStyle body1 = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle body2 = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  // Caption & Label Styles
  static TextStyle caption = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.2,
    height: 1.4,
  );

  static TextStyle captionBold = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.4,
  );

  static TextStyle label = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  // Button Styles
  static TextStyle button = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  static TextStyle buttonLarge = GoogleFonts.inter(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  // Code Style
  static TextStyle code = GoogleFonts.jetBrainsMono(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.6,
  );

  static TextStyle codeSmall = GoogleFonts.jetBrainsMono(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.6,
  );

  // Numeric Styles (for stats, scores)
  static TextStyle numeric = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static TextStyle numericLarge = GoogleFonts.inter(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    letterSpacing: -1.0,
    height: 1.1,
  );
}
