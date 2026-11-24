import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:location/location.dart' as loc;
import 'permission_service.dart';

class LocationResult {
  final double lat, lng;
  final double? accuracy; // meter
  const LocationResult(this.lat, this.lng, this.accuracy);

  String get teks {
    final k = '${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}';
    return accuracy == null ? k : '$k (akurasi ±${accuracy!.round()} m)';
  }
}

class LocationService {
  static final _location = loc.Location();

  /// Lempar AppPermissionException atau Exception dengan pesan siap tampil.
  static Future<LocationResult> current() async {
    // 1. Izin lokasi (permission_handler)
    await AppPermission.ensureLocation();

    // 2. Izin di web (di Android/iOS sudah ditangani langkah 1)
    if (kIsWeb) {
      var p = await _location.hasPermission();
      if (p == loc.PermissionStatus.denied) {
        p = await _location.requestPermission();
      }
      if (p != loc.PermissionStatus.granted &&
          p != loc.PermissionStatus.grantedLimited) {
        throw const AppPermissionException('Izin lokasi ditolak.');
      }
    }

    // 3. GPS harus menyala (location)
    var aktif = await _location.serviceEnabled();
    if (!aktif) {
      aktif = await _location.requestService();
      if (!aktif) {
        throw const AppPermissionException(
            'GPS belum aktif. Nyalakan lokasi di HP.');
      }
    }

    // 4. Ambil koordinat
    loc.LocationData data;
    try {
      await _location.changeSettings(accuracy: loc.LocationAccuracy.high);
      data = await _location.getLocation().timeout(const Duration(seconds: 15));
    } catch (_) {
      throw Exception('Lokasi belum ditemukan. Coba lagi di tempat terbuka.');
    }

    if (data.isMock == true) {
      throw Exception('Lokasi palsu (fake GPS) terdeteksi.');
    }

    return LocationResult(data.latitude, data.longitude, data.accuracy);
  }
}