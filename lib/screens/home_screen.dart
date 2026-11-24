import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../core/app_colors.dart';

class HomeScreen extends StatelessWidget {
   final DateTime? masukAt;
  final DateTime? pulangAt;
  const HomeScreen({super.key, this.masukAt, this.pulangAt});

  static const _batasJam = 6;
  static const _batasMenit = 0;

  String _two(int n) => n.toString().padLeft(2, '0');

  String _fmt(DateTime d) =>
      '${_two(d.hour)}.${_two(d.minute)} | ${_two(d.day)}/${_two(d.month)}/${d.year}';

  bool _tepatWaktu(DateTime d) =>
      d.hour < _batasJam || (d.hour == _batasJam && d.minute <= _batasMenit);

  static const _shadow = [
    BoxShadow(
        color: Color(0x40000000),
        blurRadius: 4,
        spreadRadius: 3,
        offset: Offset(0, 2))
  ];

  Widget _title(String t) => Padding(
        padding: const EdgeInsets.fromLTRB(37, 16, 37, 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(t,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          const Text('Lihat Semua',
              style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
        ]),
      );

  Widget _card(Widget child, {double h = 0, double mx = 37}) => Container(
        margin: EdgeInsets.symmetric(horizontal: mx),
        height: h == 0 ? null : h,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: _shadow),
        child: child,
      );

  Widget _summary(IconData i, String v, String l) => Row(children: [
        Icon(i, color: const Color(0xFFF5C518), size: 30),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(v,
              style:
                  const TextStyle(fontWeight: FontWeight.w300, fontSize: 15)),
          Text(l,
              style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey)),
        ]),
      ]);

  Widget _presRow(String label, String time, String badge, bool ok) => Row(
        children: [
          const CircleAvatar(
              radius: 15,
              backgroundColor: Color(0xFFE6E6E6),
              child: Icon(Icons.person, color: Colors.white, size: 20)),
          const SizedBox(width: 25),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 9, fontWeight: FontWeight.w300)),
              Text(time,
                  style: const TextStyle(
                      fontSize: 7, fontWeight: FontWeight.w300)),
            ]),
          ),
          Container(
            width: 87,
            padding: const EdgeInsets.symmetric(vertical: 6),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ok ? const Color(0x7D97DF91) : null,
              borderRadius: BorderRadius.circular(50),
              border: ok ? null : Border.all(color: const Color(0xFFAB0101)),
            ),
            child: Text(badge,
                style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: ok
                        ? const Color(0xFF14981F)
                        : const Color(0xFFA00505))),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final u = AuthService.instance.user;
    final now = DateTime.now();
    final tgl =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}';
            final masukRow = masukAt == null
        ? _presRow(
            'Presensi Masuk', '--.-- | --/--/----', 'Belum Presensi', false)
        : _presRow('Presensi Masuk', _fmt(masukAt!),
            _tepatWaktu(masukAt!) ? 'Tepat Waktu' : 'Terlambat',
            _tepatWaktu(masukAt!));

    final pulangRow = pulangAt == null
        ? _presRow(
            'Presensi Pulang', '--.-- | --/--/----', 'Belum Presensi', false)
        : _presRow('Presensi Pulang', _fmt(pulangAt!), 'Sudah Presensi', true);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Stack(clipBehavior: Clip.none, children: [
            Container(
              height: 175,
              width: double.infinity,
              color: AppColors.bg,
              padding: const EdgeInsets.fromLTRB(31, 0, 20, 0),
              child: SafeArea(
                child: Row(children: [
                  const CircleAvatar(
                      radius: 33,
                      backgroundColor: Color(0xFFE6E6E6),
                      child:
                          Icon(Icons.person, size: 46, color: Colors.white)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Hi\n${u?.nama ?? '-'}\n${u?.nis ?? ''} I ${u?.kelas ?? ''} I SMK N 1 Bukateja',
                      style: const TextStyle(fontSize: 15, height: 1.2),
                    ),
                  ),
                ]),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: -30,
              child: Container(
                height: 61,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _summary(Icons.calendar_month, tgl, 'Tanggal'),
                      _summary(Icons.access_time, '06:00', 'Masuk'),
                      _summary(Icons.access_time, '14:00', 'Pulang'),
                    ]),
              ),
            ),
          ]),
          const SizedBox(height: 36),
          _title('Presensi'),
                  _card(Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              masukRow,
              const SizedBox(height: 30),
              pulangRow,
            ]),
          )),
          _title('Jurnal PKL'),
          _card(
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_month,
                        size: 44, color: Color(0xFFF5C518)),
                    SizedBox(height: 6),
                    Text('Periode PKL belum dimulai',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w500)),
                    SizedBox(height: 4),
                    Text(
                        'Jurnal PKL kamu belum bisa diisi. Fitur ini aktif otomatis saat periode PKL dimulai.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: AppColors.grey)),
                  ]),
            ),
            h: 139,
          ),
          _title('Jadwal Pelajaran'),
          _card(
            const Padding(
              padding: EdgeInsets.fromLTRB(9, 8, 9, 14),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('KONSENTRASI REKAYASA PERANGKAT LUNAK',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w500)),
                    SizedBox(height: 12),
                    Padding(
                        padding: EdgeInsets.only(left: 23),
                        child: Text('08.00-',
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF696565)))),
                    SizedBox(height: 6),
                    Row(children: [
                      Icon(Icons.person_outline, size: 14),
                      SizedBox(width: 9),
                      Text('PARAS TAUFANI, S.KOM',
                          style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF696565))),
                    ]),
                  ]),
            ),
            mx: 12,
          ),
          _title('Perizinan'),
          Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
            height: 102,
            decoration: BoxDecoration(
                color: const Color(0x1C000000),
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: _card(
                const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu_book_outlined, size: 26),
                      SizedBox(height: 3),
                      Text('Ajukan izin',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w500)),
                      Text('Ajukan izin jika kamu berhalangan hadir',
                          style: TextStyle(
                              fontSize: 6, fontWeight: FontWeight.w300)),
                    ]),
                h: 83,
                mx: 0,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}