import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../theme/app_colors.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'balance_page.dart';
import 'edit_profile_page.dart';
import 'settings_page.dart';
import 'widgets/animated_tap.dart';
import 'widgets/page_transition.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final user = context.watch<AuthViewModel>().userModel;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text("Profil", style: TextStyle(color: colors.accent, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Profil (data dinamis dari Firebase Auth & Firestore)
            _buildHeader(context, colors, user),

            // Menu Opsi Profil
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildProfileOption(context, colors, Icons.edit, "Edit Profil", () {
                    Navigator.push(context, fadeSlideRoute((context) => const EditProfilePage()));
                  }, 200.ms),
                  _buildProfileOption(context, colors, Icons.history, "Riwayat", () {
                    Navigator.push(context, fadeSlideRoute((context) => const BalancePage()));
                  }, 280.ms),
                  _buildProfileOption(context, colors, Icons.settings, "Pengaturan", () {
                    Navigator.push(context, fadeSlideRoute((context) => const SettingsPage()));
                  }, 360.ms),
                  _buildProfileOption(context, colors, Icons.logout, "Logout", () => _confirmLogout(context, colors), 440.ms),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppColors colors, UserModel? user) {
    if (user == null) {
      return Padding(
        padding: const EdgeInsets.all(60),
        child: Center(child: CircularProgressIndicator(color: colors.accent)),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.cyanAccent, Colors.blueAccent]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          _buildAvatar(user.photoBase64, radius: 50)
              .animate()
              .fadeIn(duration: 500.ms)
              .scale(begin: const Offset(0.7, 0.7), curve: Curves.easeOutBack),
          const SizedBox(height: 10),
          Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          Text(user.email, style: const TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 10),
          Text(
            "Level: ${user.memberLevel} | Poin: ${user.points}",
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1, end: 0);
  }

  Widget _buildAvatar(String? photoBase64, {required double radius}) {
    if (photoBase64 != null && photoBase64.isNotEmpty) {
      try {
        return CircleAvatar(radius: radius, backgroundImage: MemoryImage(base64Decode(photoBase64)));
      } catch (_) {
        // Abaikan data foto yang tidak valid, tampilkan ikon default
      }
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
      child: Icon(Icons.person, color: Colors.blueAccent, size: radius),
    );
  }

  void _confirmLogout(BuildContext context, AppColors colors) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text("Logout", style: TextStyle(color: colors.textPrimary)),
        content: Text("Apakah Anda yakin ingin keluar?", style: TextStyle(color: colors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text("Batal", style: TextStyle(color: colors.textSecondary)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await context.read<AuthViewModel>().logout();
              if (context.mounted) {
                Navigator.popUntil(context, (route) => route.isFirst);
              }
            },
            child: const Text("Logout", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context, AppColors colors, IconData icon, String title, VoidCallback onTap, Duration delay) {
    return AnimatedTap(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 5, offset: const Offset(0, 2))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: colors.accent, size: 40),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(color: colors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    ).animate(delay: delay).fadeIn(duration: 400.ms).scale(begin: const Offset(0.85, 0.85), curve: Curves.easeOutBack);
  }
}
