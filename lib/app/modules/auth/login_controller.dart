import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/providers/api_client.dart';
import '../../services/auth_service.dart';
import '../../routes/app_routes.dart';
import '../../services/storage_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;

  late final AuthRepository _authRepo;

  @override
  void onInit() {
    super.onInit();
    _authRepo = AuthRepository(ApiClient());
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePassword() => obscurePassword.toggle();

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final result = await _authRepo.login(
        emailController.text.trim(),
        passwordController.text,
      );

      // Simpan token sementara
      await Get.find<StorageService>().saveToken(result['token']);

      // Ambil profile user
      final profile = await _authRepo.getProfile();

      // Simpan user + token
      final authService = Get.find<AuthService>();

      await authService.saveUser(
        profile,
        result['token'],
      );

      Get.offAllNamed(
        AppRoutes.MAIN,
      );
    } catch (e) {
      Get.snackbar(
        'Login Gagal',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Demo login
  void loginDemo({String role = 'buyer'}) {
    emailController.text =
        role == 'seller' ? 'seller@demo.com' : 'buyer@demo.com';
    passwordController.text = 'password123';
    login();
  }
}
