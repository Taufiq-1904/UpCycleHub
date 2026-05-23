import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/providers/api_client.dart';

class ProductListController extends GetxController {
  final searchController = TextEditingController();
  final scrollController = ScrollController();

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxList<String> categories = <String>[].obs;
  final RxString selectedCategory = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;

  int _page = 1;
  static const int _limit = 10;
  late final ProductRepository _repo;

  @override
  void onInit() {
    super.onInit();
    _repo = ProductRepository(ApiClient());

    // Pre-set category from args
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['category'] != null) {
      selectedCategory.value = args['category'];
    }

    scrollController.addListener(_onScroll);
    loadCategories();
    loadProducts(refresh: true);
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      loadMore();
    }
  }

  Future<void> loadCategories() async {
    categories.value = await _repo.getCategories();
  }

  Future<void> loadProducts({bool refresh = false}) async {
    if (refresh) {
      _page = 1;
      hasMore.value = true;
      isLoading.value = true;
    }
    try {
      final result = await _repo.getProducts(
        search: searchQuery.value,
        category: selectedCategory.value,
        page: _page,
        limit: _limit,
      );
      if (refresh) {
        products.value = result;
      } else {
        products.addAll(result);
      }
      if (result.length < _limit) hasMore.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore.value) return;
    isLoadingMore.value = true;
    _page++;
    try {
      await loadProducts();
    } finally {
      isLoadingMore.value = false;
    }
  }

  void onSearch(String query) {
    searchQuery.value = query;
    loadProducts(refresh: true);
  }

  void selectCategory(String category) {
    if (selectedCategory.value == category) {
      selectedCategory.value = '';
    } else {
      selectedCategory.value = category;
    }
    loadProducts(refresh: true);
  }

  @override
  Future<void> refresh() async {
    await loadProducts(refresh: true);
  }
}
