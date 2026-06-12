import 'package:flutter/material.dart';

// Palet warna terpusat untuk mode terang & gelap, dipakai di seluruh halaman
class AppColors {
  final bool isDark;
  const AppColors(this.isDark);

  factory AppColors.of(BuildContext context) =>
      AppColors(Theme.of(context).brightness == Brightness.dark);

  Color get background => isDark ? const Color(0xFF121212) : const Color(0xFFF4F6FB);
  Color get surface => isDark ? const Color(0xFF1E1E26) : Colors.white;
  Color get surfaceAlt => isDark ? const Color(0xFF2A2A3A) : const Color(0xFFEEF1F8);

  Color get textPrimary => isDark ? Colors.white : const Color(0xFF1A1A2E);
  Color get textSecondary => isDark ? Colors.white70 : const Color(0xFF6B7280);
  Color get textMuted => isDark ? Colors.white54 : const Color(0xFF9CA3AF);

  Color get divider => isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.06);
  Color get shadow => isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.06);

  Color get accent => isDark ? Colors.cyanAccent : const Color(0xFF00ACC1);
  Color get inputFill => isDark ? const Color(0xFF1E1E26) : const Color(0xFFF0F2F7);
}

extension AppColorsX on BuildContext {
  AppColors get colors => AppColors.of(this);
}
