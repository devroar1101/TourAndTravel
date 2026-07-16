import 'package:flutter/material.dart';

/// Aurevia palette — minimal luxury.
///
/// Deep midnight blue carries the brand, emerald grounds it in nature,
/// gold is reserved for moments of emphasis, and warm whites keep the
/// canvas airy.
class AppColors {
  AppColors._();

  // Brand
  static const Color midnight = Color(0xFF0A1B2E);
  static const Color midnightDeep = Color(0xFF060F1B);
  static const Color emerald = Color(0xFF0F6B54);
  static const Color emeraldDeep = Color(0xFF0A4A3A);
  static const Color gold = Color(0xFFC9A227);
  static const Color goldBright = Color(0xFFE3C25B);

  // Canvas
  static const Color ivory = Color(0xFFFAF8F4);
  static const Color mist = Color(0xFFEFF2F5);
  static const Color cloud = Color(0xFFFFFFFF);

  // Text
  static const Color inkStrong = Color(0xFF0B1626);
  static const Color ink = Color(0xFF2A3648);
  static const Color inkSoft = Color(0xFF64748B);
  static const Color onDark = Color(0xFFF5F3EE);
  static const Color onDarkSoft = Color(0xFFB8C0CC);

  // Semantic
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color danger = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB);

  // Effects
  static Color glassLight = Colors.white.withValues(alpha: 0.08);
  static Color glassBorder = Colors.white.withValues(alpha: 0.18);
  static Color shadowSoft = midnight.withValues(alpha: 0.08);
  static Color shadowDeep = midnight.withValues(alpha: 0.22);

  static const LinearGradient heroOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x66060F1B), Color(0x22060F1B), Color(0xCC060F1B)],
    stops: [0.0, 0.45, 1.0],
  );

  static const LinearGradient cardOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xE6060F1B)],
    stops: [0.35, 1.0],
  );

  static const LinearGradient goldSheen = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldBright, gold],
  );
}
