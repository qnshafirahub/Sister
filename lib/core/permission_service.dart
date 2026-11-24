import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';

/// Error izin/GPS dengan pesan yang siap ditampilkan ke pengguna.
class AppPermissionException implements Exception {
  final String message;

  /// true kalau pengguna harus mengaktifkan izin lewat Pengaturan aplikasi.
  final bool openSettings;
  const AppPermissionException(this.message, {this.openSettings = false});

  @override
  String toString() => message;
}

class AppPermission {
  static Future<void> ensureLocation() async {
    if (kIsWeb) return; // di web, izin ditangani package location
    final s = await Permission.locationWhenInUse.request();
    if (s.isGranted || s.isLimited) return;
    if (s.isPermanentlyDenied) {
      throw const AppPermissionException(
          'Izin lokasi ditolak permanen. Aktifkan lewat Pengaturan aplikasi.',
          openSettings: true);
    }
    throw const AppPermissionException(
        'Izin lokasi diperlukan untuk presensi.');
  }

  static Future<bool> openSettingsPage() => openAppSettings();
}