import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userRoleKey = 'user_role';
  static const String _darkModeKey = 'dark_mode';
  static const String _userDataKey = 'user_data';

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // ── Token ─────────────────────────────────────────────────────────────────
  Future<void> saveToken(String token) async {
    await _secureStorage.write(
      key: 'auth_token',
      value: token,
    );
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(
      key: 'auth_token',
    );
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  // ── Refresh Token ─────────────────────────────────────────────────────────
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: _refreshTokenKey, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  // ── User ID ───────────────────────────────────────────────────────────────
  Future<void> saveUserId(String userId) async {
    await _prefs.setString(_userIdKey, userId);
  }

  String? get userId => _prefs.getString(_userIdKey);

  // ── User Role ─────────────────────────────────────────────────────────────
  Future<void> saveUserRole(String role) async {
    await _prefs.setString(_userRoleKey, role);
  }

  String get userRole => _prefs.getString(_userRoleKey) ?? 'pembeli';
  bool get ispenjual => userRole == 'penjual';

  // ── Dark Mode ─────────────────────────────────────────────────────────────
  bool get isDarkMode => _prefs.getBool(_darkModeKey) ?? false;

  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool(_darkModeKey, value);
  }

  // ── User Data ─────────────────────────────────────────────────────────────
  Future<void> saveUserData(String json) async {
    await _prefs.setString(_userDataKey, json);
  }

  String? get userData => _prefs.getString(_userDataKey);

  // ── Clear All (logout) ────────────────────────────────────────────────────
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    await _prefs.clear();
  }
}
