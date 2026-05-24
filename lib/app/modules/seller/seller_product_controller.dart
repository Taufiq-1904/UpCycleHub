import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/product_model.dart';
import '../../data/models/kategori_model.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/providers/api_client.dart';
import '../../services/cloudinary_service.dart';
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
  final RxList<String> existingImageUrls = <String>[].obs;

  final Rxn<KategoriModel> selectedCategory = Rxn<KategoriModel>();
  final RxList<KategoriModel> categories = <KategoriModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isUploadingImages = false.obs;

  Rxn<ProductModel> editingProduct = Rxn<ProductModel>();
  late final ProductRepository _repo;
  final _cloudinary = CloudinaryService();

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
    existingImageUrls.value = List<String>.from(p.images);
  }

  Future<void> loadCategories() async {
    try {
      final list = await _repo.getCategories();
      categories.value = list;

      if (editingProduct.value != null) {
        try {
          selectedCategory.value = list.firstWhere(
            (k) =>
                k.nama.toLowerCase() ==
                editingProduct.value!.category.toLowerCase(),
          );
        } catch (_) {
          selectedCategory.value = list.isNotEmpty ? list.first : null;
        }
      } else {
        selectedCategory.value = null;
      }
    } catch (_) {
      categories.value = const [
        KategoriModel(id: 1, nama: 'Fesyen', slug: 'fesyen'),
        KategoriModel(id: 2, nama: 'Furnitur', slug: 'furnitur'),
        KategoriModel(id: 3, nama: 'Aksesori', slug: 'aksesori'),
        KategoriModel(id: 4, nama: 'Dekorasi', slug: 'dekorasi'),
        KategoriModel(id: 5, nama: 'Elektronik', slug: 'elektronik'),
      ];
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
    final picked = await picker.pickMultiImage(imageQuality: 80);
    for (final img in picked) {
      selectedImages.add(File(img.path));
    }
  }

  void removeNewImage(int index) => selectedImages.removeAt(index);
  void removeImage(int index) => removeNewImage(index);
  void removeExistingImage(int index) => existingImageUrls.removeAt(index);

  // ── Upload foto BARU ke Cloudinary ──────────────────────────────────────
  Future<List<String>> _uploadNewImages() async {
    if (selectedImages.isEmpty) return [];

    isUploadingImages.value = true;
    final List<String> urls = [];
    try {
      for (final file in selectedImages) {
        final url = await _cloudinary.uploadImage(file);
        urls.add(url);
      }
    } catch (e) {
      throw 'Gagal upload foto: $e';
    } finally {
      isUploadingImages.value = false;
    }
    return urls;
  }

  Future<void> saveProduct() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedCategory.value == null) {
      Get.snackbar(
        'Perhatian',
        'Pilih kategori produk terlebih dahulu',
        snackPosition: SnackPosition.TOP,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (selectedImages.isEmpty && existingImageUrls.isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Tambahkan minimal 1 foto produk',
        snackPosition: SnackPosition.TOP,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    isSaving.value = true;
    try {
      final newUrls = await _uploadNewImages();
      final allImageUrls = [...existingImageUrls, ...newUrls];

      final body = <String, dynamic>{
        'nama': nameController.text.trim(),
        'deskripsi': descriptionController.text.trim(),
        'kategori_id': selectedCategory.value!.id,
        'harga': double.tryParse(priceController.text) ?? 0,
        'stok': int.tryParse(stockController.text) ?? 0,
        'fotos': allImageUrls,
      };

      if (editingProduct.value != null) {
        await _repo.updateProduct(editingProduct.value!.id, body);
        Get.snackbar('Berhasil', 'Produk berhasil diperbarui',
            snackPosition: SnackPosition.TOP,
            borderRadius: 12,
            margin: const EdgeInsets.all(16));
      } else {
        await _repo.createProduct(body);
        Get.snackbar('Berhasil', 'Produk berhasil ditambahkan',
            snackPosition: SnackPosition.TOP,
            borderRadius: 12,
            margin: const EdgeInsets.all(16));
      }

      Get.back();
      await loadProducts();
    } catch (e, s) {
      print("ERROR => $e");
      print("STACKTRACE =>");
      print(s);

      Get.snackbar(
        'Gagal Menyimpan',
        e.toString(),
        backgroundColor: AppTheme.errorRed,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteProduct(ProductModel product) async {
    final confirmed = await Get.dialog<bool>(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Hapus Produk'),
      content: Text('Yakin ingin menghapus "${product.name}"?'),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: const Text('Batal'),
        ),
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
