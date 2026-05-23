import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/providers/api_client.dart';
import '../../data/repositories/auth_repository.dart';
import '../../services/auth_service.dart';
import '../../routes/app_routes.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;

  // Mock users — demo offline tanpa backend
  static const _mockPassword = 'password123';
  static final _mockUsers = <String, UserModel>{
    'buyer@demo.com': UserModel(
      id: 'buyer_001',
      name: 'Andi Pembeli',
      email: 'buyer@demo.com',
      role: 'buyer',
      phone: '081234567890',
      address: 'Jl. Merdeka No. 10, Jakarta Pusat',
    ),
    'seller@demo.com': UserModel(
      id: 'seller_001',
      name: 'Budi Penjual',
      email: 'seller@demo.com',
      role: 'seller',
      phone: '089876543210',
      address: 'Jl. Sudirman No. 5, Bandung',
    ),
  };

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
      final email = emailController.text.trim().toLowerCase();
      final password = passwordController.text;

      // 1. Cek mock user dulu (offline demo)
      final mockUser = _mockUsers[email];
      if (mockUser != null && password == _mockPassword) {
        await Future.delayed(const Duration(milliseconds: 600));
        await _saveAndNavigate(mockUser, 'mock_token_${mockUser.role}');
        return;
      }

      // 2. Hit API login — backend return: { token, refresh_token, role, message }
      final loginResult = await _authRepo.login(email, password);

      final token = loginResult['token']?.toString() ?? '';
      final refreshToken = loginResult['refresh_token']?.toString() ?? '';
      final roleFromServer = loginResult['role']?.toString() ?? 'buyer';

      if (token.isEmpty) throw 'Token tidak diterima dari server';

      // 3. Simpan token sementara supaya getProfile bisa pakai Authorization header
      final authService = Get.find<AuthService>();
      await authService.saveTokenOnly(token, refreshToken);

      // 4. Ambil data lengkap user via /auth/profile
      UserModel user;
      try {
        user = await _authRepo.getProfile();
      } catch (_) {
        // Fallback kalau getProfile gagal: buat user minimal dari data login
        user = UserModel(
          id: '',
          name: email.split('@').first,
          email: email,
          role: roleFromServer,
        );
      }

      await _saveAndNavigate(user, token, refreshToken: refreshToken);
    } catch (e) {
      Get.snackbar(
        'Login Gagal',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveAndNavigate(
    UserModel user,
    String token, {
    String? refreshToken,
  }) async {
    final authService = Get.find<AuthService>();
    await authService.saveUser(user, token, refreshToken: refreshToken);
    Get.offAllNamed(AppRoutes.MAIN);
    Get.snackbar(
      'Selamat Datang! 👋',
      'Halo ${user.name.split(' ').first}! '
          'Masuk sebagai ${user.role == 'seller' ? '🏪 Penjual' : '🛍️ Pembeli'}',
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }

  void loginDemo({String role = 'buyer'}) {
    emailController.text =
        role == 'seller' ? 'seller@demo.com' : 'buyer@demo.com';
    passwordController.text = _mockPassword;
    login();
  }
}
