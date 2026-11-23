import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_user.dart';

class AuthStorage {
  static const _kToken = 'auth_token';
  static const _kUser = 'auth_user';
  final _s = const FlutterSecureStorage();

  Future<void> save(String token, AuthUser user) async {
    await _s.write(key: _kToken, value: token);
    await _s.write(key: _kUser, value: jsonEncode(user.toJson()));
  }

  Future<String?> readToken() => _s.read(key: _kToken);

  Future<AuthUser?> readUser() async {
    final raw = await _s.read(key: _kUser);
    if (raw == null) return null;
    try {
      return AuthUser.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() async {
    await _s.delete(key: _kToken);
    await _s.delete(key: _kUser);
  }
}