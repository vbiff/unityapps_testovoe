import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Apple-inspired light theme configuration
///
/// This theme is inspired by Apple's design language from apple.com
/// featuring clean typography, subtle shadows, and premium color palette
/// Provides only light theme for consistent user experience
class AppTheme {
  // Apple-inspired color palette
  static const Color _primaryBlue = Color(0xFF007AFF);
  static const Color _backgroundGray = Color(0xFFF5F5F7);
  static const Color _surfaceWhite = Color(0xFFFFFFFF);
  static const Color _textPrimary = Color(0xFF1D1D1F);
  static const Color _textSecondary = Color(0xFF86868B);
  static const Color _textTertiary = Color(0xFFA1A1A6);
  static const Color _dividerGray = Color(0xFFD2D2D7);
  static const Color _errorRed = Color(0xFFFF3B30);

  // Apple's SF Pro Display font weights
  static const FontWeight _regular = FontWeight.w400;
  static const FontWeight _medium = FontWeight.w500;
  static const FontWeight _semibold = FontWeight.w600;
  static const FontWeight _bold = FontWeight.w700;

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: _primaryBlue,
        onPrimary: Colors.white,
        secondary: _textSecondary,
        onSecondary: Colors.white,
        surface: _surfaceWhite,
        onSurface: _textPrimary,
        error: _errorRed,
        onError: Colors.white,
        outline: _dividerGray,
        outlineVariant: _textTertiary,
      ),

      // Scaffold background
      scaffoldBackgroundColor: _backgroundGray,

      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: _surfaceWhite,
        foregroundColor: _textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          color: _textPrimary,
          fontSize: 17,
          fontWeight: _semibold,
          letterSpacing: -0.41,
        ),
      ),

      // Typography - Apple SF Pro inspired
      textTheme: const TextTheme(
        // Large display text
        displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: _bold,
          letterSpacing: -0.25,
          color: _textPrimary,
          height: 1.12,
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: _bold,
          letterSpacing: 0,
          color: _textPrimary,
          height: 1.16,
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: _bold,
          letterSpacing: 0,
          color: _textPrimary,
          height: 1.22,
        ),

        // Headlines
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: _bold,
          letterSpacing: 0,
          color: _textPrimary,
          height: 1.25,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: _semibold,
          letterSpacing: 0,
          color: _textPrimary,
          height: 1.29,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: _semibold,
          letterSpacing: 0,
          color: _textPrimary,
          height: 1.33,
        ),

        // Titles
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: _medium,
          letterSpacing: 0,
          color: _textPrimary,
          height: 1.27,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: _medium,
          letterSpacing: 0.15,
          color: _textPrimary,
          height: 1.50,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: _medium,
          letterSpacing: 0.1,
          color: _textPrimary,
          height: 1.43,
        ),

        // Body text
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: _regular,
          letterSpacing: 0.5,
          color: _textPrimary,
          height: 1.50,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: _regular,
          letterSpacing: 0.25,
          color: _textSecondary,
          height: 1.43,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: _regular,
          letterSpacing: 0.4,
          color: _textTertiary,
          height: 1.33,
        ),

        // Labels
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: _medium,
          letterSpacing: 0.1,
          color: _textPrimary,
          height: 1.43,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: _medium,
          letterSpacing: 0.5,
          color: _textSecondary,
          height: 1.33,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: _medium,
          letterSpacing: 0.5,
          color: _textTertiary,
          height: 1.45,
        ),
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _textTertiary,
          disabledForegroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: _semibold,
            letterSpacing: -0.41,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryBlue,
          disabledForegroundColor: _textTertiary,
          side: const BorderSide(color: _primaryBlue, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: _semibold,
            letterSpacing: -0.41,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryBlue,
          disabledForegroundColor: _textTertiary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: _medium,
            letterSpacing: -0.41,
          ),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _dividerGray, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _dividerGray, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _errorRed, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _errorRed, width: 2),
        ),
        contentPadding: const EdgeInsets.all(16),
        hintStyle: const TextStyle(
          color: _textTertiary,
          fontSize: 16,
          fontWeight: _regular,
        ),
        labelStyle: const TextStyle(
          color: _textSecondary,
          fontSize: 16,
          fontWeight: _medium,
        ),
        floatingLabelStyle: const TextStyle(
          color: _primaryBlue,
          fontSize: 12,
          fontWeight: _medium,
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: _surfaceWhite,
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.04),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(8),
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: _dividerGray,
        thickness: 0.5,
        space: 1,
      ),

      // Icon theme
      iconTheme: const IconThemeData(color: _textSecondary, size: 24),

      // Progress indicator theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: _primaryBlue,
        linearTrackColor: _dividerGray,
        circularTrackColor: _dividerGray,
      ),

      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _textPrimary,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: _regular,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        elevation: 8,
      ),
    );
  }
}

/// Custom colors for specific use cases
class AppColors {
  static const Color primary = Color(0xFF007AFF);
  static const Color success = Color(0xFF30D158);
  static const Color warning = Color(0xFFFF9500);
  static const Color error = Color(0xFFFF3B30);
  static const Color info = Color(0xFF5AC8FA);

  // Semantic colors
  static const Color background = Color(0xFFF5F5F7);
  static const Color surface = Color(0xFFFFFFFF);

  // Text colors
  static const Color textPrimary = Color(0xFF1D1D1F);
  static const Color textSecondary = Color(0xFF86868B);
  static const Color textTertiary = Color(0xFFA1A1A6);

  // Border and divider
  static const Color divider = Color(0xFFD2D2D7);
}

/// Custom text styles for specific components
class AppTextStyles {
  static const TextStyle largeTitle = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.37,
    height: 1.12,
  );

  static const TextStyle title1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.36,
    height: 1.14,
  );

  static const TextStyle title2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.35,
    height: 1.18,
  );

  static const TextStyle title3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.38,
    height: 1.20,
  );

  static const TextStyle headline = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.41,
    height: 1.29,
  );

  static const TextStyle body = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.41,
    height: 1.29,
  );

  static const TextStyle callout = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.32,
    height: 1.31,
  );

  static const TextStyle subheadline = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.24,
    height: 1.33,
  );

  static const TextStyle footnote = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.08,
    height: 1.38,
  );

  static const TextStyle caption1 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.33,
  );

  static const TextStyle caption2 = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.07,
    height: 1.36,
  );
}
