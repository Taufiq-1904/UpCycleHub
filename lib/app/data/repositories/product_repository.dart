import 'package:dio/dio.dart';
import '../providers/api_client.dart';
import '../models/product_model.dart';

class ProductRepository {
  final ApiClient _apiClient;

  ProductRepository(this._apiClient);

  Future<List<ProductModel>> getProducts({
    String? search,
    String? category,
    int page = 1,
    int limit = 10,
    String? sort,
  }) async {
    try {
      final response = await _apiClient.get('/products', queryParams: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (category != null && category.isNotEmpty) 'category': category,
        'page': page,
        'limit': limit,
        if (sort != null) 'sort': sort,
      });
      final List data = response.data['products'] ?? response.data ?? [];
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } on DioException catch (_) {
      // Return dummy data if API fails
      return ProductDummy.products;
    }
  }

  Future<ProductModel> getProductById(String id) async {
    try {
      final response = await _apiClient.get('/products/$id');
      return ProductModel.fromJson(response.data['product'] ?? response.data);
    } on DioException catch (_) {
      return ProductDummy.products.firstWhere(
        (p) => p.id == id,
        orElse: () => ProductDummy.products.first,
      );
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await _apiClient.get('/categories');
      return List<String>.from(response.data['categories'] ?? []);
    } on DioException catch (_) {
      return [
        'Fashion',
        'Dekorasi',
        'Furnitur',
        'Aksesori',
        'Tanaman',
        'Lainnya'
      ];
    }
  }

  Future<ProductModel> createProduct(FormData formData) async {
    try {
      final response = await _apiClient.postFormData('/products', formData);
      return ProductModel.fromJson(response.data['product']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ProductModel> updateProduct(String id, FormData formData) async {
    try {
      final response = await _apiClient.putFormData('/products/$id', formData);
      return ProductModel.fromJson(response.data['product']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _apiClient.delete('/products/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<ProductModel>> getSellerProducts() async {
    try {
      final response = await _apiClient.get('/seller/products');
      final List data = response.data['products'] ?? [];
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } on DioException catch (_) {
      return ProductDummy.products;
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      return e.response?.data['message'] ?? 'Terjadi kesalahan';
    }
    return 'Tidak dapat terhubung ke server';
  }
}
