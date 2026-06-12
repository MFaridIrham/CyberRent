import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../theme/app_colors.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'auth_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final authViewModel = context.read<AuthViewModel>();
    final success = await authViewModel.register(
      _nameController.text.trim(),
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      // Akun berhasil dibuat & sesi otomatis aktif -> kembali ke AuthGate
      // yang akan menampilkan HomePage.
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authViewModel.errorMessage ?? "Registrasi gagal")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isLoading = context.watch<AuthViewModel>().isLoading;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text("Daftar Akun", style: TextStyle(color: colors.accent, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                Text(
                  "Buat akun baru untuk mulai menyewa PC & memesan snack",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.textSecondary, fontSize: 14),
                ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.3, end: 0),
                const SizedBox(height: 32),
                AuthTextField(
                  controller: _nameController,
                  label: "Nama Lengkap",
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return "Nama tidak boleh kosong";
                    return null;
                  },
                ).animate(delay: 100.ms).fadeIn(duration: 500.ms).slideX(begin: -0.2, end: 0),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _emailController,
                  label: "Email",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Email tidak boleh kosong";
                    if (!value.contains('@')) return "Format email tidak valid";
                    return null;
                  },
                ).animate(delay: 200.ms).fadeIn(duration: 500.ms).slideX(begin: -0.2, end: 0),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _passwordController,
                  label: "Password",
                  icon: Icons.lock,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: colors.textMuted,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Password tidak boleh kosong";
                    if (value.length < 6) return "Password minimal 6 karakter";
                    return null;
                  },
                ).animate(delay: 300.ms).fadeIn(duration: 500.ms).slideX(begin: -0.2, end: 0),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _confirmPasswordController,
                  label: "Konfirmasi Password",
                  icon: Icons.lock_outline,
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      color: colors.textMuted,
                    ),
                    onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) return "Password tidak cocok";
                    return null;
                  },
                ).animate(delay: 400.ms).fadeIn(duration: 500.ms).slideX(begin: -0.2, end: 0),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.accent,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                        )
                      : const Text(
                          "Daftar",
                          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ).animate(delay: 500.ms).fadeIn(duration: 500.ms).slideY(begin: 0.3, end: 0),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Sudah punya akun?", style: TextStyle(color: colors.textSecondary)),
                    TextButton(
                      onPressed: isLoading ? null : () => Navigator.pop(context),
                      child: Text("Masuk", style: TextStyle(color: colors.accent, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ).animate(delay: 600.ms).fadeIn(duration: 500.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
