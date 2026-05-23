import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import '../../data/repositories/order_repository.dart';
import '../../data/providers/api_client.dart';
import '../cart/cart_controller.dart';
import '../../routes/app_routes.dart';
import '../../themes/app_theme.dart';
import 'dart:io';

class CheckoutController extends GetxController {
  final addressController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final RxBool isLoading = false.obs;
  final Rxn<File> paymentProof = Rxn<File>();
  late final OrderRepository _orderRepo;
  late final CartController _cartController;

  @override
  void onInit() {
    super.onInit();
    _orderRepo = OrderRepository(ApiClient());
    _cartController = Get.find<CartController>();
  }

  @override
  void onClose() {
    addressController.dispose();
    super.onClose();
  }

  Future<void> pickPaymentProof() async {
    final picker = ImagePicker();
    final picked =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked != null) paymentProof.value = File(picked.path);
  }

  Future<void> checkout() async {
    if (!formKey.currentState!.validate()) return;
    if (paymentProof.value == null) {
      Get.snackbar('Perhatian', 'Upload bukti pembayaran terlebih dahulu',
          snackPosition: SnackPosition.TOP,
          borderRadius: 12,
          margin: const EdgeInsets.all(16));
      return;
    }
    isLoading.value = true;
    try {
      final items = _cartController.items.map((i) => i.toJson()).toList();
      final order = await _orderRepo.createOrder({
        'items': items,
        'shippingAddress': addressController.text.trim(),
        'totalAmount': _cartController.totalPrice,
      });
      final formData = dio.FormData.fromMap({
        'paymentProof':
            await dio.MultipartFile.fromFile(paymentProof.value!.path),
      });
      await _orderRepo.uploadPaymentProof(order.id, formData);
      _cartController.clear();
      Get.offAllNamed(AppRoutes.ORDER_DETAIL, arguments: order.id);
      Get.snackbar('Pesanan Dibuat! 🎉', 'Pesananmu sedang diproses',
          snackPosition: SnackPosition.TOP,
          borderRadius: 12,
          margin: const EdgeInsets.all(16));
    } catch (e) {
      Get.snackbar('Gagal', e.toString(),
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppTheme.errorRed,
          colorText: Colors.white,
          borderRadius: 12,
          margin: const EdgeInsets.all(16));
    } finally {
      isLoading.value = false;
    }
  }
}
