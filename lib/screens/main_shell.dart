import 'package:flutter/material.dart';
import '../widgets/app_bottom_nav.dart';
import 'cbt_screen.dart';
import 'home_screen.dart';
import 'presensi_flow.dart';
import 'profile_screen.dart';
import 'lms_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _i = 0; // 0 = Home, 1 = CBT, 2 = Akun
  DateTime? _masuk;
  DateTime? _pulang;

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Future<void> _presensi() async {
    final now = DateTime.now();
    // Hari baru: presensi kemarin dikosongkan.
    if (_masuk != null && !_sameDay(_masuk!, now)) {
      _masuk = null;
      _pulang = null;
    }
    if (_masuk != null && _pulang != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Presensi hari ini sudah lengkap')),
      );
      return;
    }

    final jenis = _masuk == null ? 'Masuk' : 'Pulang';
       final r = await Navigator.push<PresensiResult>(
        context, MaterialPageRoute(builder: (_) => const PresensiScreen()));
    if (r == null || !mounted) return;

    setState(() {
      _i = 0;
      if (jenis == 'Masuk') {
        _masuk = r.waktu;
      } else {
        _pulang = r.waktu;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: IndexedStack(index: _i, children: [
        HomeScreen(masukAt: _masuk, pulangAt: _pulang),
        const LmsScreen(),
        const CbtScreen(),
        const ProfileScreen(),
      ]),
      bottomNavigationBar: AppBottomNav(
        index: _i,
        onTap: (v) => setState(() => _i = v),
        onPresensi: _presensi,
      ),
    );
  }
}