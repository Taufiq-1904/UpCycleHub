import 'package:get/get.dart';
import '../services/storage_service.dart';
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

  Future<void> saveUser(UserModel user, String token) async {
    await _storageService.saveToken(token);
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
