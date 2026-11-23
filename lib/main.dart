import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth/auth_service.dart';
import 'core/app_colors.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.instance.init();
  runApp(const SisterApp());
}

class SisterApp extends StatelessWidget {
  const SisterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sister Skansika',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.green),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: AuthService.instance.isLoggedIn
          ? const MainShell()
          : const LoginScreen(),
    );
  }
}