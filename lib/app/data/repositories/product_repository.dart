import 'package:dio/dio.dart';
import '../providers/api_client.dart';
import '../models/product_model.dart';
import '../models/kategori_model.dart';

class ProductRepository {
  final ApiClient _apiClient;

  ProductRepository(this._apiClient);

  // ── List produk aktif (pembeli) ─────────────────────────────────────────
  Future<List<ProductModel>> getProducts({
    String? search,
    String? category,
    int page = 1,
    int limit = 10,
    String? sort,
  }) async {
    try {
      final response = await _apiClient.productGet('/products', queryParams: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (category != null && category.isNotEmpty) 'category': category,
        'page': page,
        'limit': limit,
        if (sort != null) 'sort': sort,
      });
      final raw = response.data['data'] ?? response.data['products'] ?? [];
      final List<dynamic> data = raw is List ? raw : [];
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } on DioException catch (_) {
      return ProductDummy.products;
    }
  }

  // ── Detail produk ─────────────────────────────────────────────────────
  Future<ProductModel> getProductById(String id) async {
    try {
      final response = await _apiClient.productGet('/products/$id');
      return ProductModel.fromJson(response.data['product'] ?? response.data);
    } on DioException catch (_) {
      return ProductDummy.products.firstWhere(
        (p) => p.id == id,
        orElse: () => ProductDummy.products.first,
      );
    }
  }

  // ── Kategori ──────────────────────────────────────────────────────────
  Future<List<KategoriModel>> getCategories() async {
    try {
      final response = await _apiClient.productGet('/kategori');
      final List raw = response.data is List
          ? response.data
          : (response.data['data'] ?? response.data['kategori'] ?? []);
      return raw.map((e) => KategoriModel.fromJson(e)).toList();
    } on DioException catch (_) {
      return const [
        KategoriModel(id: 1, nama: 'Fesyen', slug: 'fesyen'),
        KategoriModel(id: 2, nama: 'Furnitur', slug: 'furnitur'),
        KategoriModel(id: 3, nama: 'Aksesori', slug: 'aksesori'),
        KategoriModel(id: 4, nama: 'Dekorasi', slug: 'dekorasi'),
        KategoriModel(id: 5, nama: 'Elektronik', slug: 'elektronik'),
      ];
    }
  }

  // ── Tambah produk (penjual) ────────────────────────────────────────────
  Future<ProductModel> createProduct(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _apiClient.productPost(
        '/products',
        data: data,
      );

      print("===============");
      print("RESPONSE TYPE:");
      print(response.data.runtimeType);
      print("RESPONSE DATA:");
      print(response.data);
      print("===============");

      return ProductModel.fromJson(
        response.data['product'] ?? response.data,
      );
    } on DioException catch (e) {
      print("DIO ERROR:");
      print(e.response?.data);
      throw _handleError(e);
    }
  }

  // ── Edit produk (penjual) ──────────────────────────────────────────────
  Future<ProductModel> updateProduct(
      String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.productPut('/products/$id', data: data);
      return ProductModel.fromJson(response.data['product'] ?? response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ── Hapus produk (penjual) ─────────────────────────────────────────────
  Future<void> deleteProduct(String id) async {
    try {
      await _apiClient.productDelete('/products/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ── Produk milik penjual yang sedang login ─────────────────────────────
  Future<List<ProductModel>> getpenjualProducts() async {
    try {
      final response = await _apiClient.productGet('/products/penjual/me');
      final List data = response.data['products'] ?? response.data ?? [];
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } on DioException catch (_) {
      return ProductDummy.products;
    }
  }

  // ── Error handler ─────────────────────────────────────────────────────
  String _handleError(DioException e) {
    try {
      if (e.response != null) {
        final data = e.response!.data;

        if (data is Map && data.containsKey('message')) {
          return data['message'].toString();
        }

        return 'Server error (${e.response?.statusCode})';
      }
    } catch (_) {}

    return 'Tidak dapat terhubung ke server';
  }
}
