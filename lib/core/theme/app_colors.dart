// lib/core/theme/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  // Background gradient
  static const navyDark = Color(0xFF02173A);
  static const navyLight = Color(0xFF032352);
  static const navySolid = Color(0xFF0A1A3A); // For backwards compatibility
  
  // Primary colors
  static const primary = Color(0xFF1E7B7B);
  static const primaryLight = Color(0xFFB8E6E6);
  static const accent = Color(0xFF00C6FB);
  
  // Text colors
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFFB8E6E6);
  static const textDark = Color(0xFF0A1A3A);
  
  // Background gradient
  static const backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [navyDark, navyLight],
  );
}
