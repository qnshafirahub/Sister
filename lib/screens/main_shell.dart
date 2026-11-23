import 'package:flutter/material.dart';
import '../widgets/app_bottom_nav.dart';
import 'cbt_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _i = 0; // 0 = Home, 1 = CBT, 2 = Akun

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _i, children: const [
        HomeScreen(),
        CbtScreen(),
        ProfileScreen(),
      ]),
      bottomNavigationBar: AppBottomNav(
        index: _i,
        onTap: (v) => setState(() => _i = v),
      ),
    );
  }
}