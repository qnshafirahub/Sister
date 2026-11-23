import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../core/app_colors.dart';

class DataDiriScreen extends StatelessWidget {
  const DataDiriScreen({super.key});

  Widget _head(String t) => Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 10),
        child: Text(t,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
      );

  Widget _rows(Map<String, String> m) => Column(children: [
        for (final e in m.entries)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                  width: 150,
                  child: Text(e.key,
                      style: const TextStyle(fontWeight: FontWeight.w500))),
              Expanded(
                  child: Text(e.value,
                      style: const TextStyle(color: Colors.black54))),
            ]),
          ),
      ]);

  @override
  Widget build(BuildContext context) {
    final u = AuthService.instance.user;
    final personal = {
      'Nama': u?.nama ?? '-',
      'Tempat Lahir': '-',
      'Tanggal Lahir': '-',
      'Jenis Kelamin': '-',
      'Telepon': '-',
      'NIS': u?.nis ?? '-',
      'NISN': '-',
      'NIK': '-',
      'Agama': '-',
      'Alamat': '-',
      'Anak Ke-': '-',
      'Asal Sekolah': '-',
      'Nomor Surat Tanda Lulus': '-',
      'Tanggal Surat Tanda Lulus': '-',
    };
    const ortu = {'Nama Ayah': '-', 'Nama Ibu': '-'};

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        centerTitle: true,
        toolbarHeight: 74,
        title: const Text('Data Diri',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      ),
      body: ListView(padding: const EdgeInsets.all(19), children: [
        _head('Data Personal'),
        _rows(personal),
        const Divider(height: 40, color: Colors.black),
        _head('Data Orang Tua'),
        _rows(ortu),
      ]),
    );
  }
}