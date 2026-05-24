import 'package:get/get.dart';
import 'storage_service.dart';
import '../data/models/user_model.dart';
import 'dart:convert';

class AuthService extends GetxService {
  final _storageService = Get.find<StorageService>();
  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  final RxBool isLoggedIn = false.obs;

  Future<AuthService> init() async {
    await _loadUser();
    return this;
  }

  Future<void> _loadUser() async {
    final token = await _storageService.getToken();
    final userData = _storageService.userData;
    if (token != null && userData != null) {
      try {
        currentUser.value = UserModel.fromJson(jsonDecode(userData));
        isLoggedIn.value = true;
      } catch (e) {
        await logout();
      }
    }
  }

  /// Simpan token saja (sebelum getProfile dipanggil)
  /// Dipakai saat login/register: token ada duluan, user belum
  Future<void> saveTokenOnly(
    String token,
    String? refreshToken,
  ) async {
    print("SAVE TOKEN => $token");

    await _storageService.saveToken(token);

    final check = await _storageService.getToken();

    print("TOKEN AFTER SAVE => $check");

    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _storageService.saveRefreshToken(refreshToken);
    }
  }

  /// Simpan user lengkap + token (final step setelah getProfile)
  Future<void> saveUser(
    UserModel user,
    String token, {
    String? refreshToken,
  }) async {
    await _storageService.saveToken(token);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _storageService.saveRefreshToken(refreshToken);
    }
    await _storageService.saveUserId(user.id);
    await _storageService.saveUserRole(user.role);
    await _storageService.saveUserData(jsonEncode(user.toJson()));
    currentUser.value = user;
    isLoggedIn.value = true;
  }

  Future<void> logout() async {
    await _storageService.clearAll();
    currentUser.value = null;
    isLoggedIn.value = false;
  }

  bool get isSeller => currentUser.value?.role == 'seller';
  String get userId => currentUser.value?.id ?? '';
  String get userName => currentUser.value?.name ?? '';
}
