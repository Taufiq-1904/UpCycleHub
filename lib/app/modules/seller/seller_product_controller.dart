import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/providers/api_client.dart';
import '../../themes/app_theme.dart';
import 'dart:io';

class SellerProductController extends GetxController {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxList<File> selectedImages = <File>[].obs;
  final RxString selectedCategory = ''.obs;
  final RxList<String> categories = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;

  Rxn<ProductModel> editingProduct = Rxn<ProductModel>();
  late final ProductRepository _repo;

  @override
  void onInit() {
    super.onInit();
    _repo = ProductRepository(ApiClient());

    final args = Get.arguments;
    if (args is ProductModel) {
      editingProduct.value = args;
      _prefillForm(args);
    }

    loadProducts();
    loadCategories();
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.onClose();
  }

  void _prefillForm(ProductModel p) {
    nameController.text = p.name;
    descriptionController.text = p.description;
    priceController.text = p.price.toStringAsFixed(0);
    stockController.text = p.stock.toString();
    selectedCategory.value = p.category;
  }

  Future<void> loadCategories() async {
    categories.value = await _repo.getCategories();
    if (categories.isNotEmpty && selectedCategory.value.isEmpty) {
      selectedCategory.value = categories.first;
    }
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    try {
      products.value = await _repo.getSellerProducts();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(imageQuality: 70);
    for (final img in picked) {
      selectedImages.add(File(img.path));
    }
  }

  void removeImage(int index) => selectedImages.removeAt(index);

  Future<void> saveProduct() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedCategory.value.isEmpty) {
      Get.snackbar('Perhatian', 'Pilih kategori produk',
          snackPosition: SnackPosition.TOP,
          borderRadius: 12,
          margin: const EdgeInsets.all(16));
      return;
    }

    isSaving.value = true;
    try {
      final formData = dio.FormData.fromMap({
        'name': nameController.text.trim(),
        'description': descriptionController.text.trim(),
        'category': selectedCategory.value,
        'price': double.tryParse(priceController.text) ?? 0,
        'stock': int.tryParse(stockController.text) ?? 0,
      });

      for (final img in selectedImages) {
        formData.files.add(
            MapEntry('images', await dio.MultipartFile.fromFile(img.path)));
      }

      if (editingProduct.value != null) {
        await _repo.updateProduct(editingProduct.value!.id, formData);
        Get.snackbar('Berhasil', 'Produk berhasil diperbarui',
            snackPosition: SnackPosition.TOP,
            borderRadius: 12,
            margin: const EdgeInsets.all(16));
      } else {
        await _repo.createProduct(formData);
        Get.snackbar('Berhasil', 'Produk berhasil ditambahkan',
            snackPosition: SnackPosition.TOP,
            borderRadius: 12,
            margin: const EdgeInsets.all(16));
      }
      Get.back();
      await loadProducts();
    } catch (e) {
      Get.snackbar('Gagal', e.toString(),
          backgroundColor: AppTheme.errorRed,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          borderRadius: 12,
          margin: const EdgeInsets.all(16));
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteProduct(ProductModel product) async {
    final confirmed = await Get.dialog<bool>(AlertDialog(
      title: const Text('Hapus Produk'),
      content: Text('Yakin hapus "${product.name}"?'),
      actions: [
        TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal')),
        TextButton(
          onPressed: () => Get.back(result: true),
          child:
              const Text('Hapus', style: TextStyle(color: AppTheme.errorRed)),
        ),
      ],
    ));
    if (confirmed == true) {
      try {
        await _repo.deleteProduct(product.id);
        products.removeWhere((p) => p.id == product.id);
        Get.snackbar('Berhasil', 'Produk berhasil dihapus',
            snackPosition: SnackPosition.TOP,
            borderRadius: 12,
            margin: const EdgeInsets.all(16));
      } catch (e) {
        Get.snackbar('Gagal', e.toString(),
            snackPosition: SnackPosition.TOP,
            borderRadius: 12,
            margin: const EdgeInsets.all(16));
      }
    }
  }
}
