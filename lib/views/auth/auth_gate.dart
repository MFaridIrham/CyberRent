import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home_page.dart';
import '../../theme/app_colors.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'login_page.dart';

// Mengarahkan pengguna ke HomePage jika sesi aktif, atau LoginPage jika belum login
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final authViewModel = context.read<AuthViewModel>();

    return StreamBuilder<User?>(
      stream: authViewModel.authStateChanges,
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.connectionState == ConnectionState.waiting) {
          child = Scaffold(
            key: const ValueKey('loading'),
            backgroundColor: colors.background,
            body: Center(
              child: CircularProgressIndicator(color: colors.accent),
            ),
          );
        } else if (snapshot.hasData) {
          child = const HomePage(key: ValueKey('home'));
        } else {
          child = const LoginPage(key: ValueKey('login'));
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: child,
        );
      },
    );
  }
}
