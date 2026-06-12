import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'theme/app_colors.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/payment_viewmodel.dart';
import 'viewmodels/rental_viewmodel.dart';
import 'viewmodels/theme_viewmodel.dart';
import 'views/auth/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => RentalViewModel()),
        ChangeNotifierProvider(create: (_) => PaymentViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
      ],
      child: Consumer<ThemeViewModel>(
        builder: (context, themeVM, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: _buildTheme(Brightness.light),
            darkTheme: _buildTheme(Brightness.dark),
            themeMode: themeVM.themeMode,
            home: const AuthGate(),
          );
        },
      ),
    );
  }

  // Membangun ThemeData modern (Material 3) untuk mode terang & gelap
  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colors = AppColors(isDark);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.cyan,
        brightness: brightness,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      cardColor: colors.surface,
      dividerColor: colors.divider,
    );
  }
}
