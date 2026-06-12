import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../theme/app_colors.dart';
import '../viewmodels/theme_viewmodel.dart';

// Halaman pengaturan: saat ini hanya berisi switch mode tampilan terang/gelap
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final themeVM = context.watch<ThemeViewModel>();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text("Pengaturan", style: TextStyle(color: colors.accent, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 5, offset: const Offset(0, 2))],
          ),
          child: SwitchListTile(
            value: themeVM.isDark,
            onChanged: (value) => themeVM.setDarkMode(value),
            activeThumbColor: colors.accent,
            secondary: Icon(themeVM.isDark ? Icons.dark_mode : Icons.light_mode, color: colors.accent),
            title: Text("Mode Gelap", style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w500)),
            subtitle: Text(
              themeVM.isDark ? "Tampilan gelap aktif" : "Tampilan terang aktif",
              style: TextStyle(color: colors.textSecondary, fontSize: 12),
            ),
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0),
      ),
    );
  }
}
