import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/providers/api_client.dart';
import '../../services/auth_service.dart';
import '../../services/storage_service.dart';
import '../../routes/app_routes.dart';
import '../../themes/app_theme.dart';
import 'dart:io';

class ProfileController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final RxBool isLoading = false.obs;
  final Rxn<File> newAvatar = Rxn<File>();

  late final AuthRepository _repo;
  late final AuthService _authService;
  late final StorageService _storageService;

  @override
  void onInit() {
    super.onInit();
    _repo = AuthRepository(ApiClient());
    _authService = Get.find<AuthService>();
    _storageService = Get.find<StorageService>();
    _prefillFields();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }

  void _prefillFields() {
    final user = _authService.currentUser.value;
    if (user != null) {
      nameController.text = user.name;
      phoneController.text = user.phone ?? '';
      addressController.text = user.address ?? '';
    }
  }

  Future<void> pickAvatar() async {
    final picker = ImagePicker();
    final picked =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) newAvatar.value = File(picked.path);
  }

  Future<void> updateProfile() async {
    isLoading.value = true;
    try {
      if (newAvatar.value != null) {
        final formData = dio.FormData.fromMap({
          'name': nameController.text.trim(),
          'phone': phoneController.text.trim(),
          'address': addressController.text.trim(),
          'avatar': await dio.MultipartFile.fromFile(newAvatar.value!.path),
        });
        final user = await _repo.updateProfileWithAvatar(formData);
        await _authService.saveUser(user, (await _storageService.getToken())!);
      } else {
        final user = await _repo.updateProfile({
          'name': nameController.text.trim(),
          'phone': phoneController.text.trim(),
          'address': addressController.text.trim(),
        });
        await _authService.saveUser(user, (await _storageService.getToken())!);
      }
      Get.back();
      Get.snackbar('Berhasil', 'Profil berhasil diperbarui',
          snackPosition: SnackPosition.TOP,
          borderRadius: 12,
          margin: const EdgeInsets.all(16));
    } catch (e) {
      Get.snackbar('Gagal', e.toString(),
          backgroundColor: AppTheme.errorRed,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          borderRadius: 12,
          margin: const EdgeInsets.all(16));
    } finally {
      isLoading.value = false;
    }
  }

  void toggleDarkMode() {
    _storageService.setDarkMode(!_storageService.isDarkMode);
    Get.changeThemeMode(
      _storageService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
    );
  }

  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}
