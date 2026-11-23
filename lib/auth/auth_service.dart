import 'package:flutter/foundation.dart';
import 'auth_storage.dart';
import 'auth_user.dart';

class AuthService extends ChangeNotifier {
  AuthService._();
  static final instance = AuthService._();

  final _storage = AuthStorage();
  String? _token;
  AuthUser? _user;

  bool get isLoggedIn => _token != null && _user != null;
  AuthUser? get user => _user;
  String? get token => _token;

  /// Dipanggil sekali di main() sebelum runApp.
  Future<void> init() async {
    _token = await _storage.readToken();
    _user = await _storage.readUser();
    if (!isLoggedIn) {
      _token = null;
      _user = null;
    }
  }

  /// Lempar Exception kalau gagal; pesannya tampil di halaman login.
  Future<void> login(String username, String password) async {
    // TODO: ganti blok ini dengan request ke API Sister yang asli,
    // lalu isi token & user dari respons server.
    await Future.delayed(const Duration(milliseconds: 600));
    const token = 'demo-token';
    final user = AuthUser(
      nis: username,
      nama: 'QUINSHA NUR SHAFIRA',
      kelas: 'XI RPL 1',
      sekolah: 'SMK Negeri 1 Bukateja',
    );

    await _storage.save(token, user); // password TIDAK disimpan
    _token = token;
    _user = user;
    notifyListeners();
  }

  Future<void> logout() async {
    await _storage.clear();
    _token = null;
    _user = null;
    notifyListeners();
  }
}