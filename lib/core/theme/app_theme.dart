// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Warna-warna dasar ReStok.in
class AppColors {
  // warna utama (teal button)
  static const Color primary = Color(0xFF008B8B);
  static const Color primaryDark = Color(0xFF006C6C);

  // background navy
  static const Color background = Color(0xFF02173A);

  // kartu / input (biru muda)
  static const Color surface = Color(0xFFE0F8FF);

  // teks
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB3E5F5);

  // status / aksen
  static const Color success = Color(0xFF2ECC71);
  static const Color danger = Color(0xFFE74C3C);
}

class AppTheme {
  AppTheme._();

  /// TextTheme global
  static TextTheme _baseTextTheme(Brightness brightness) {
    final base = ThemeData(brightness: brightness).textTheme;
    return GoogleFonts.poppinsTextTheme(base).apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    );
  }

  /// ColorScheme MD3, tanpa pakai properti yang deprecated
  static ColorScheme _colorScheme(Brightness brightness) {
    return ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    );
  }

  /// Di desain kamu dominan dark, jadi dua-duanya sama dulu
  static ThemeData get light => _theme(brightness: Brightness.dark);
  static ThemeData get dark => _theme(brightness: Brightness.dark);

  static ThemeData _theme({required Brightness brightness}) {
    final colorScheme = _colorScheme(brightness);
    final textTheme = _baseTextTheme(brightness);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,

      // background utama app (navy)
      scaffoldBackgroundColor: AppColors.background,

      textTheme: textTheme.copyWith(
        bodyMedium: textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF02173A), // input text dark navy
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.surface,
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF0D2A59).withValues(alpha: 0.6), // dark navy semi-transparan untuk kontras
          fontWeight: FontWeight.w400,
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF0D2A59), // tidak dipakai lagi
          fontWeight: FontWeight.w600,
        ),
        floatingLabelStyle: textTheme.bodyMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.6,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.danger,
            width: 1.4,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.danger,
            width: 1.6,
          ),
        ),
      ),

      // NOTE: di SDK kamu tipe-nya CardThemeData?
      // Kita sesuaikan:
      cardTheme: CardThemeData(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        elevation: 0,
        margin: EdgeInsets.zero,
      ),

      listTileTheme: ListTileThemeData(
        tileColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        iconColor: colorScheme.primary,
        textColor: AppColors.textPrimary,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF0D2A59),
        behavior: SnackBarBehavior.floating,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: Colors.white,
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xFF032352),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }
}
