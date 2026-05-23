import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/review_repository.dart';
import '../../data/providers/api_client.dart';
import '../../themes/app_theme.dart';

class ReviewController extends GetxController {
  final commentController = TextEditingController();
  final RxDouble rating = 5.0.obs;
  final RxBool isLoading = false.obs;
  late String productId;
  late final ReviewRepository _repo;

  @override
  void onInit() {
    super.onInit();
    _repo = ReviewRepository(ApiClient());
    productId = Get.arguments as String;
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }

  Future<void> submitReview() async {
    if (commentController.text.trim().isEmpty) {
      Get.snackbar('Perhatian', 'Tulis ulasan terlebih dahulu',
          snackPosition: SnackPosition.TOP,
          borderRadius: 12,
          margin: const EdgeInsets.all(16));
      return;
    }
    isLoading.value = true;
    try {
      await _repo.addReview(
        productId: productId,
        rating: rating.value,
        comment: commentController.text.trim(),
      );
      Get.back();
      Get.snackbar('Terima Kasih! ⭐', 'Ulasan kamu berhasil dikirim',
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
}
