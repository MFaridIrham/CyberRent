import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

// Input field bergaya konsisten untuk halaman Login, Register & Edit Profil
class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final bool enabled;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.enabled = true,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      keyboardType: keyboardType,
      style: TextStyle(color: colors.textPrimary),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: colors.textSecondary),
        prefixIcon: Icon(icon, color: colors.accent),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: colors.inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.accent.withValues(alpha: 0.3), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.accent, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
