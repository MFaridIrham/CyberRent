import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../theme/app_colors.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../widgets/page_transition.dart';
import 'auth_text_field.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final authViewModel = context.read<AuthViewModel>();
    final success = await authViewModel.login(
      _emailController.text,
      _passwordController.text,
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authViewModel.errorMessage ?? "Login gagal")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isLoading = context.watch<AuthViewModel>().isLoading;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                Icon(Icons.computer, size: 80, color: colors.accent)
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .scale(begin: const Offset(0.5, 0.5), curve: Curves.easeOutBack),
                const SizedBox(height: 16),
                Text(
                  "CyberRent",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.accent, fontSize: 32, fontWeight: FontWeight.bold),
                ).animate(delay: 150.ms).fadeIn(duration: 500.ms).slideY(begin: 0.3, end: 0),
                const SizedBox(height: 8),
                Text(
                  "Masuk untuk melanjutkan",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.textSecondary, fontSize: 14),
                ).animate(delay: 250.ms).fadeIn(duration: 500.ms).slideY(begin: 0.3, end: 0),
                const SizedBox(height: 40),
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
                ).animate(delay: 350.ms).fadeIn(duration: 500.ms).slideX(begin: -0.2, end: 0),
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
                ).animate(delay: 450.ms).fadeIn(duration: 500.ms).slideX(begin: -0.2, end: 0),
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
                          "Masuk",
                          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ).animate(delay: 550.ms).fadeIn(duration: 500.ms).slideY(begin: 0.3, end: 0),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Belum punya akun?", style: TextStyle(color: colors.textSecondary)),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () => Navigator.push(
                                context,
                                fadeSlideRoute((context) => const RegisterPage()),
                              ),
                      child: Text("Daftar", style: TextStyle(color: colors.accent, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ).animate(delay: 650.ms).fadeIn(duration: 500.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
