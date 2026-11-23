import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  final int index; // 0 = Home, 1 = CBT, 2 = Akun
  final ValueChanged<int> onTap;
  const AppBottomNav({super.key, required this.index, required this.onTap});

  static const _grey = Color(0xFF666A75);

  /// Menu yang bisa ditekan (Home, CBT, Akun).
  Widget _active(int i, IconData icon, String label) {
    final c = index == i ? AppColors.dark : _grey;
    return Expanded(
      child: InkWell(
        onTap: () => onTap(i),
        child: _content(icon, label, c),
      ),
    );
  }

  /// Menu yang hanya tampilan, tidak bisa ditekan (LMS).
  Widget _disabled(IconData icon, String label) {
    return Expanded(child: _content(icon, label, _grey));
  }

  Widget _content(IconData icon, String label, Color c) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 38, color: c),
          Text(label,
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700, color: c)),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))
      ]),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 84,
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            _active(0, Icons.home_filled, 'Home'),
            _disabled(Icons.school, 'LMS'),
            // Presensi: tampil saja, belum bisa ditekan
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                        color: Color(0xFFBFE3BA), shape: BoxShape.circle),
                    child: const Icon(Icons.face_unlock_outlined,
                        size: 44, color: Color(0xFFEAF7E7)),
                  ),
                  const Text('Presensi',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700)),
                ]),
              ),
            ),
            _active(1, Icons.content_paste, 'CBT'),
            _active(2, Icons.person, 'Akun'),
          ]),
        ),
      ),
    );
  }
}