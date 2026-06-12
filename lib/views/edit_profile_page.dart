import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../theme/app_colors.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'auth/auth_text_field.dart';

// Halaman untuk mengubah nama, foto profil, dan password pengguna aktif.
// Perubahan nama & foto disimpan ke Firestore (koleksi `users`), perubahan
// password disimpan ke Firebase Auth.
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _profileFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  String? _pickedPhotoBase64;
  bool _isSavingProfile = false;
  bool _isChangingPassword = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthViewModel>().userModel;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 70,
    );
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    setState(() => _pickedPhotoBase64 = base64Encode(bytes));
  }

  Future<void> _saveProfile() async {
    if (!_profileFormKey.currentState!.validate()) return;

    setState(() => _isSavingProfile = true);
    final authViewModel = context.read<AuthViewModel>();
    final success = await authViewModel.updateProfile(
      name: _nameController.text,
      photoBase64: _pickedPhotoBase64,
    );
    if (!mounted) return;
    setState(() {
      _isSavingProfile = false;
      if (success) _pickedPhotoBase64 = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? "Profil berhasil diperbarui" : authViewModel.errorMessage ?? "Gagal memperbarui profil")),
    );
  }

  Future<void> _changePassword() async {
    if (!_passwordFormKey.currentState!.validate()) return;

    setState(() => _isChangingPassword = true);
    final authViewModel = context.read<AuthViewModel>();
    final success = await authViewModel.updatePassword(
      _currentPasswordController.text,
      _newPasswordController.text,
    );
    if (!mounted) return;
    setState(() => _isChangingPassword = false);

    if (success) {
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? "Password berhasil diubah" : authViewModel.errorMessage ?? "Gagal mengubah password")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final user = context.watch<AuthViewModel>().userModel;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text("Edit Profil", style: TextStyle(color: colors.accent, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar + tombol ganti foto
            Center(
              child: Stack(
                children: [
                  _buildAvatar(_pickedPhotoBase64 ?? user?.photoBase64, radius: 60, colors: colors),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colors.accent,
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.background, width: 3),
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.black, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.8, 0.8)),

            const SizedBox(height: 28),

            // Form Profil (nama & email)
            Form(
              key: _profileFormKey,
              child: Column(
                children: [
                  AuthTextField(
                    controller: _nameController,
                    label: "Nama Lengkap",
                    icon: Icons.person,
                    validator: (value) => (value == null || value.trim().isEmpty) ? "Nama tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _emailController,
                    label: "Email",
                    icon: Icons.email,
                    enabled: false,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSavingProfile ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.accent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: _isSavingProfile
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                          : const Text("Simpan Perubahan", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ).animate(delay: 150.ms).fadeIn(duration: 400.ms),

            const SizedBox(height: 32),
            Divider(color: colors.divider),
            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerLeft,
              child: Text("Ubah Password", style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),

            Form(
              key: _passwordFormKey,
              child: Column(
                children: [
                  AuthTextField(
                    controller: _currentPasswordController,
                    label: "Password Saat Ini",
                    icon: Icons.lock_outline,
                    obscureText: _obscureCurrent,
                    suffixIcon: IconButton(
                      icon: Icon(_obscureCurrent ? Icons.visibility_off : Icons.visibility, color: colors.textMuted),
                      onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
                    ),
                    validator: (value) => (value == null || value.isEmpty) ? "Password saat ini wajib diisi" : null,
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _newPasswordController,
                    label: "Password Baru",
                    icon: Icons.lock,
                    obscureText: _obscureNew,
                    suffixIcon: IconButton(
                      icon: Icon(_obscureNew ? Icons.visibility_off : Icons.visibility, color: colors.textMuted),
                      onPressed: () => setState(() => _obscureNew = !_obscureNew),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Password baru wajib diisi";
                      if (value.length < 6) return "Password minimal 6 karakter";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _confirmPasswordController,
                    label: "Konfirmasi Password Baru",
                    icon: Icons.lock_outline,
                    obscureText: _obscureConfirm,
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility, color: colors.textMuted),
                      onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                    validator: (value) => value != _newPasswordController.text ? "Password tidak cocok" : null,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _isChangingPassword ? null : _changePassword,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: colors.accent),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: _isChangingPassword
                          ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: colors.accent))
                          : Text("Ubah Password", style: TextStyle(color: colors.accent, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ).animate(delay: 250.ms).fadeIn(duration: 400.ms),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String? photoBase64, {required double radius, required AppColors colors}) {
    if (photoBase64 != null && photoBase64.isNotEmpty) {
      try {
        return CircleAvatar(radius: radius, backgroundImage: MemoryImage(base64Decode(photoBase64)));
      } catch (_) {
        // Abaikan data foto yang tidak valid, tampilkan ikon default
      }
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: colors.surfaceAlt,
      child: Icon(Icons.person, color: colors.textSecondary, size: radius),
    );
  }
}
