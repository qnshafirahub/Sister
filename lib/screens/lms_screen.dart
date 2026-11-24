import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class _Mapel {
  final String kode, nama, guru;
  final Color warna;
  final int materi, tugas;
  const _Mapel(this.kode, this.nama, this.guru, this.warna,
      {this.materi = 0, this.tugas = 0});
}

const _mapel = [
  _Mapel('BIND', 'BAHASA INDONESIA', 'NUR YULIANDRIANINGTYAS, S.Pd.',
      Color(0xFF17A300)),
  _Mapel('MK-RPL', 'MAPEL KONSENTRASI REKAYASA PERANGKAT LUNAK',
      'PARAS TAUFANI, S.Kom.', Color(0xFF0B4FA8)),
  _Mapel('B.JEPANG', 'B.JEPANG', 'IMAM MAULANA, S.Pd.', Color(0xFF8A3B0B)),
];

const _shadow = [
  BoxShadow(color: Color(0x40000000), blurRadius: 4, offset: Offset(0, 2))
];

BoxDecoration _card() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    boxShadow: _shadow);

class LmsScreen extends StatelessWidget {
  const LmsScreen({super.key});

  Widget _header() => Container(
        width: double.infinity,
        color: AppColors.bg,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.dark, width: 2),
                ),
                child:
                    const Icon(Icons.school, color: AppColors.dark, size: 32),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pembelajaran',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.dark)),
                    Text('SMK N 1 Bukateja  XI RPL 1 Gasal 2026/2027',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.dark)),
                  ],
                ),
              ),
            ]),
          ),
        ),
      );


  Widget _search() => Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: _card(),
        child: const Row(children: [
          Icon(Icons.search, color: Colors.black87),
          SizedBox(width: 8),
          Text('Cari mata pelajaran..', style: TextStyle(fontSize: 13)),
        ]),
      );

  Widget _stat(String v, String l, Color c) => Expanded(
        child: Column(children: [
          Text(v,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w700, color: c)),
          Text(l,
              style: const TextStyle(fontSize: 10, color: AppColors.grey)),
        ]),
      );

  Widget _stats() => Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: _card(),
        child: Row(children: [
          _stat('${_mapel.length}', 'Mata Pelajaran', const Color(0xFFD60000)),
          _stat('0', 'Materi', const Color(0xFF00B8D4)),
          _stat('0', 'Tugas Aktif', const Color(0xFF00C853)),
        ]),
      );

  Widget _chip(IconData i, String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
            color: const Color(0xFFEDEDED),
            borderRadius: BorderRadius.circular(50)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(i, size: 12),
          const SizedBox(width: 4),
          Text(t, style: const TextStyle(fontSize: 9)),
        ]),
      );

  Widget _mapelCard(_Mapel m) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: const BoxConstraints(minHeight: 84),
        clipBehavior: Clip.antiAlias,
        decoration: _card(),
        child: IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Container(
              width: 76,
              color: m.warna,
              alignment: Alignment.center,
              child: Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Color.lerp(m.warna, Colors.white, 0.3),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(m.kode,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m.nama,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w700)),
                    Text(m.guru, style: const TextStyle(fontSize: 9)),
                    const SizedBox(height: 6),
                    Row(children: [
                      _chip(Icons.menu_book_outlined, '${m.materi} Materi'),
                      const SizedBox(width: 8),
                      _chip(Icons.description_outlined, '${m.tugas} Tugas'),
                    ]),
                  ],
                ),
              ),
            ),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        _header(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
            children: [
              _search(),
              const SizedBox(height: 10),
              _stats(),
              const Padding(
                padding: EdgeInsets.fromLTRB(4, 18, 0, 12),
                child: Text('Mata Pelajaran',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ),
              for (final m in _mapel) _mapelCard(m),
            ],
          ),
        ),
      ]),
    );
  }
}