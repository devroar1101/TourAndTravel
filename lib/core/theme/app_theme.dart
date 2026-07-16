import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Material 3 theme for Aurevia.
///
/// Poppins throughout, with a deliberate weight ladder: featherweight
/// display sizes for cinematic headlines, medium weights for UI chrome.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.midnight,
        primary: AppColors.midnight,
        secondary: AppColors.emerald,
        tertiary: AppColors.gold,
        surface: AppColors.ivory,
        error: AppColors.danger,
      ),
      scaffoldBackgroundColor: AppColors.ivory,
    );

    final textTheme = GoogleFonts.poppinsTextTheme(base.textTheme).copyWith(
      displayLarge: GoogleFonts.poppins(
        fontSize: 88,
        fontWeight: FontWeight.w200,
        height: 1.02,
        letterSpacing: -2.5,
        color: AppColors.inkStrong,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 64,
        fontWeight: FontWeight.w200,
        height: 1.05,
        letterSpacing: -1.8,
        color: AppColors.inkStrong,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 46,
        fontWeight: FontWeight.w300,
        height: 1.1,
        letterSpacing: -1.2,
        color: AppColors.inkStrong,
      ),
      headlineLarge: GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: FontWeight.w300,
        height: 1.15,
        letterSpacing: -0.8,
        color: AppColors.inkStrong,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        height: 1.2,
        letterSpacing: -0.5,
        color: AppColors.inkStrong,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        height: 1.25,
        color: AppColors.inkStrong,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: AppColors.inkStrong,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: AppColors.inkStrong,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: AppColors.inkStrong,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 17,
        fontWeight: FontWeight.w300,
        height: 1.7,
        color: AppColors.ink,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w300,
        height: 1.65,
        color: AppColors.ink,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w300,
        height: 1.55,
        color: AppColors.inkSoft,
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.2,
        color: AppColors.inkStrong,
      ),
      labelMedium: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 2.4,
        color: AppColors.inkSoft,
      ),
      labelSmall: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.8,
        color: AppColors.inkSoft,
      ),
    );

    return base.copyWith(
      textTheme: textTheme,
      dividerTheme: DividerThemeData(
        color: AppColors.midnight.withValues(alpha: 0.08),
        thickness: 1,
        space: 1,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cloud,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.inkSoft),
        labelStyle: textTheme.bodySmall?.copyWith(
          color: AppColors.inkSoft,
          letterSpacing: 0.4,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide:
              BorderSide(color: AppColors.midnight.withValues(alpha: 0.12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide:
              BorderSide(color: AppColors.midnight.withValues(alpha: 0.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.emerald, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.4),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.midnight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        contentTextStyle:
            textTheme.bodyMedium?.copyWith(color: AppColors.onDark),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.midnight,
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: textTheme.bodySmall?.copyWith(color: AppColors.onDark),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(
          AppColors.midnight.withValues(alpha: 0.25),
        ),
        radius: const Radius.circular(8),
        thickness: const WidgetStatePropertyAll(6),
      ),
    );
  }
}
