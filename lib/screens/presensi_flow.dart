import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../core/location_service.dart';
import '../core/permission_service.dart';
import '../widgets/app_modal.dart';

class PresensiResult {
  final DateTime waktu;
  final LocationResult lokasi;
  const PresensiResult(this.waktu, this.lokasi);
}

class PresensiScreen extends StatefulWidget {
  const PresensiScreen({super.key});
  @override
  State<PresensiScreen> createState() => _PresensiScreenState();
}

class _PresensiScreenState extends State<PresensiScreen> {
  bool _busy = false;

  Future<void> _presensi() async {
    if (_busy) return;
    _busy = true;

   

    final lokasi = await showAppModal<LocationResult>(
      context,
      dismissible: false,
      child: _ConfirmDialog(nama: AuthService.instance.user?.nama ?? '-'),
    );
    if (lokasi == null || !mounted) {
      _busy = false;
      return;
    }

    final waktu = DateTime.now();
    await showAppModal(
      context,
      child: const StatusModal(
          title: 'Presensi Berhasil', message: 'Berhasil Melakukan Presensi'),
    );
    if (mounted) Navigator.pop(context, PresensiResult(waktu, lokasi));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B2B2B),
      appBar: AppBar(
        backgroundColor: Colors.black54,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Presensi Wajah',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ),
      body: Stack(children: [
        const Center(
            child: Icon(Icons.face_outlined, size: 200, color: Colors.white10)),
        Positioned(
          left: 20,
          right: 20,
          bottom: 154,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: Colors.black54, borderRadius: BorderRadius.circular(10)),
            child: const Text(
                'Pastikan wajah terlihat jelas dan tidak menggunakan masker/topeng',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ),
        ),
        Positioned(
          bottom: 26,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: _presensi,
              child: Container(
                width: 110,
                height: 110,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xFFBFE3BA)),
                child: const Icon(Icons.photo_camera_outlined,
                    size: 62, color: Colors.white),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class _ConfirmDialog extends StatefulWidget {
  final String nama;
  const _ConfirmDialog({required this.nama});
  @override
  State<_ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<_ConfirmDialog> {
  LocationResult? _loc;
  String? _err;
  bool _bukaPengaturan = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _err = null;
      _bukaPengaturan = false;
      _loc = null;
    });
    try {
      final l = await LocationService.current();
      if (!mounted) return;
      setState(() => _loc = l);
    } on AppPermissionException catch (e) {
      if (!mounted) return;
      setState(() {
        _err = e.message;
        _bukaPengaturan = e.openSettings;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _err = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Wajah Terdeteksi',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: const Color(0xFFE8E8EC),
                borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFFD0D0D0),
                  child: Icon(Icons.person, color: Colors.white, size: 26)),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(widget.nama,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w400))),
            ]),
          ),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Lokasi',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            InkWell(
              onTap: _loading ? null : _load,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(Icons.refresh,
                    size: 20, color: _loading ? Colors.black26 : Colors.black87),
              ),
            ),
          ]),
          const SizedBox(height: 4),
          if (_loading)
            const Row(children: [
              SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2)),
              SizedBox(width: 10),
              Text('Mendeteksi lokasi...', style: TextStyle(fontSize: 12)),
            ])
          else if (_err != null) ...[
            Text(_err!,
                style: const TextStyle(
                    fontSize: 12, height: 1.4, color: Color(0xFFAB0101))),
            if (_bukaPengaturan)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  width: 170,
                  child: PillButton('Buka Pengaturan',
                      () => AppPermission.openSettingsPage()),
                ),
              ),
          ] else
            Text(_loc!.teks, style: const TextStyle(fontSize: 12, height: 1.4)),
          const SizedBox(height: 16),
          const Center(
              child: Text('Apakah Anda yakin melakukan presensi?',
                  style: TextStyle(fontSize: 12))),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
                child: PillButton('Tidak', () => Navigator.pop(context),
                    outline: true)),
            const SizedBox(width: 20),
            Expanded(
              child: Opacity(
                opacity: _loc == null ? 0.4 : 1,
                child: PillButton('Ya', () {
                  if (_loc != null) Navigator.pop(context, _loc);
                }),
              ),
            ),
          ]),
        ]);
  }
}