import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/providers/api_client.dart';
import '../../services/auth_service.dart';
import '../../routes/app_routes.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirm = true.obs;
  final RxString selectedRole = 'buyer'.obs;

  late final AuthRepository _authRepo;

  @override
  void onInit() {
    super.onInit();
    _authRepo = AuthRepository(ApiClient());
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void setRole(String role) => selectedRole.value = role;

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      final result = await _authRepo.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        role: selectedRole.value,
      );
      final authService = Get.find<AuthService>();
      await authService.saveUser(result['user'], result['token']);
      Get.offAllNamed(AppRoutes.MAIN);
    } catch (e) {
      Get.snackbar(
        'Registrasi Gagal',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
