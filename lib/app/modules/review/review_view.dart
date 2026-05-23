import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'review_controller.dart';
import '../../themes/app_theme.dart';
import '../../widgets/app_button.dart';

class ReviewView extends StatelessWidget {
  const ReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReviewController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tulis Ulasan'),
        leading: IconButton(
            onPressed: Get.back,
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Icon(Icons.star_rounded,
                size: 64, color: AppTheme.warningOrange),
            const SizedBox(height: 16),
            Text('Bagaimana produknya?',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Berikan rating dan ulasanmu',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 32),
            Obx(() => RatingBar.builder(
                  initialRating: controller.rating.value,
                  minRating: 1,
                  itemCount: 5,
                  itemSize: 48,
                  itemBuilder: (_, __) => const Icon(Icons.star_rounded,
                      color: AppTheme.warningOrange),
                  onRatingUpdate: (r) => controller.rating.value = r,
                )),
            const SizedBox(height: 8),
            Obx(() => Text(
                  _ratingLabel(controller.rating.value),
                  style: const TextStyle(
                      color: AppTheme.warningOrange,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                )),
            const SizedBox(height: 32),
            Align(
                alignment: Alignment.centerLeft,
                child: Text('Ulasan',
                    style: Theme.of(context).textTheme.titleLarge)),
            const SizedBox(height: 12),
            TextField(
              controller: controller.commentController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Ceritakan pengalamanmu dengan produk ini...',
              ),
            ),
            const SizedBox(height: 32),
            Obx(() => AppButton(
                  text: 'Kirim Ulasan',
                  onPressed: controller.submitReview,
                  isLoading: controller.isLoading.value,
                  icon: Icons.send_rounded,
                )),
          ],
        ),
      ),
    );
  }

  String _ratingLabel(double r) {
    if (r >= 5) return 'Sangat Bagus!';
    if (r >= 4) return 'Bagus';
    if (r >= 3) return 'Cukup';
    if (r >= 2) return 'Kurang';
    return 'Sangat Kurang';
  }
}
