import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import '../../data/models/review_model.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/repositories/review_repository.dart';
import '../../data/providers/api_client.dart';
import '../cart/cart_controller.dart';

class ProductDetailController extends GetxController {
  final Rxn<ProductModel> product = Rxn<ProductModel>();
  final RxList<ReviewModel> reviews = <ReviewModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt selectedImageIndex = 0.obs;
  final RxInt quantity = 1.obs;

  late final ProductRepository _productRepo;
  late final ReviewRepository _reviewRepo;

  @override
  void onInit() {
    super.onInit();
    _productRepo = ProductRepository(ApiClient());
    _reviewRepo = ReviewRepository(ApiClient());

    final args = Get.arguments;
    if (args is ProductModel) {
      product.value = args;
      loadReviews(args.id);
    } else if (args is String) {
      loadProduct(args);
    }
  }

  Future<void> loadProduct(String id) async {
    isLoading.value = true;
    try {
      product.value = await _productRepo.getProductById(id);
      await loadReviews(id);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadReviews(String productId) async {
    reviews.value = await _reviewRepo.getReviews(productId);
  }

  void selectImage(int index) => selectedImageIndex.value = index;

  void incrementQuantity() {
    if (quantity.value < (product.value?.stock ?? 1)) {
      quantity.value++;
    }
  }

  void decrementQuantity() {
    if (quantity.value > 1) quantity.value--;
  }

  void addToCart() {
    if (product.value == null) return;
    final cartController = Get.find<CartController>();
    cartController.addItem(product.value!, quantity.value);
    Get.snackbar(
      'Ditambahkan! 🛍️',
      '${product.value!.name} berhasil ditambah ke keranjang',
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }
}
