import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/providers/api_client.dart';
import '../../data/models/user_model.dart';
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
      // Step 1: Register — kirim role ke backend supaya tersimpan benar
      await _authRepo.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        role: selectedRole.value, // ← PENTING: kirim role ke API
      );

      // Step 2: Langsung login pakai kredensial yang baru didaftarkan
      final loginResult = await _authRepo.login(
        emailController.text.trim(),
        passwordController.text,
      );

      final token = loginResult['token']?.toString() ?? '';
      final refreshToken = loginResult['refresh_token']?.toString() ?? '';
      final roleFromServer =
          loginResult['role']?.toString() ?? selectedRole.value;

      // Step 3: Ambil profile untuk dapat data lengkap user
      final authService = Get.find<AuthService>();
      await authService.saveTokenOnly(token, refreshToken);

      UserModel user;
      try {
        user = await _authRepo.getProfile();
        // Jika backend tidak menyimpan role dengan benar, override dari pilihan user
        if (user.role != selectedRole.value) {
          user = user.copyWith(role: selectedRole.value);
        }
      } catch (_) {
        // Fallback: buat UserModel dari data yang tersedia
        user = UserModel(
          id: '',
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          role: roleFromServer.isNotEmpty ? roleFromServer : selectedRole.value,
        );
      }

      await authService.saveUser(user, token, refreshToken: refreshToken);

      // ── Navigasi berdasarkan role ──────────────────────────────────────
      final isSeller = user.role == 'seller';
      Get.offAllNamed(isSeller ? AppRoutes.SELLER_MAIN : AppRoutes.MAIN);

      Get.snackbar(
        'Selamat Datang! 🎉',
        'Akun berhasil dibuat. Halo ${user.name.split(' ').first}!',
        snackPosition: SnackPosition.TOP,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
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
