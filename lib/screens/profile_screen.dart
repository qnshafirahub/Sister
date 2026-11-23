import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../core/app_colors.dart';
import 'data_diri_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _shadow = [
    BoxShadow(color: Color(0x40000000), blurRadius: 6, offset: Offset(0, 3))
  ];

  Widget _box(Widget child) => Container(
        margin: const EdgeInsets.fromLTRB(28, 14, 28, 0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: _shadow),
        child: child,
      );

  Widget _stat(String l) => Column(children: [
        const Text('0',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        Text(l,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black54)),
      ]);

  Widget _item(IconData i, String t, VoidCallback onTap, {bool chev = true}) =>
      InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(children: [
            Icon(i, size: 22),
            const SizedBox(width: 14),
            Expanded(
                child: Text(t,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54))),
            if (chev) const Icon(Icons.chevron_right),
          ]),
        ),
      );

  void _soon(BuildContext c, String fitur) {
    ScaffoldMessenger.of(c).showSnackBar(
      SnackBar(content: Text('$fitur segera hadir')),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Keluar dari akun?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        content: const Text(
            'Kamu perlu masuk kembali untuk menggunakan aplikasi. Yakin ingin keluar?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Keluar')),
        ],
      ),
    );
    if (yes != true) return;

    await AuthService.instance.logout();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final u = AuthService.instance.user;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Stack(clipBehavior: Clip.none, children: [
            Container(
              width: double.infinity,
              height: 282,
              color: AppColors.bg,
              child: SafeArea(
                child: Column(children: [
                  const SizedBox(height: 10),
                  const CircleAvatar(
                      radius: 51,
                      backgroundColor: Color(0xFFE6E6E6),
                      child:
                          Icon(Icons.person, size: 70, color: Colors.white)),
                  const SizedBox(height: 18),
                  Text(u?.nama ?? '-',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text('${u?.kelas ?? '-'} | ${u?.sekolah ?? '-'}',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w700)),
                ]),
              ),
            ),
            Positioned(
              left: 28,
              right: 28,
              bottom: -35,
              child: Container(
                height: 69,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: _shadow),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _stat('Hadir'),
                      _stat('Sakit'),
                      _stat('Izin'),
                      _stat('Alpha')
                    ]),
              ),
            ),
          ]),
          const SizedBox(height: 40),
          _box(const Padding(
            padding: EdgeInsets.all(18),
            child: Row(children: [
              Icon(Icons.shield, size: 40),
              SizedBox(width: 24),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Poin pelanggaran',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                Text('Tahun Ajaran 2026/2027',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54)),
              ]),
            ]),
          )),
          _box(Column(children: [
            const Padding(
              padding: EdgeInsets.only(top: 12, bottom: 4),
              child: Text('Profil',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
            ),
            _item(
                Icons.person_outline,
                'Data Diri',
                () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const DataDiriScreen()))),
            _item(Icons.center_focus_weak, 'Registrasi Wajah',
                () => _soon(context, 'Registrasi wajah')),
            _item(Icons.refresh, 'Reset Wajah',
                () => _soon(context, 'Reset wajah')),
            const SizedBox(height: 8),
          ])),
          const SizedBox(height: 12),
          _box(_item(Icons.logout, 'Logout', () => _logout(context),
              chev: false)),
          const SizedBox(height: 30),
        ]),
      ),
    );
  }
}