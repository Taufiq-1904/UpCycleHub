import 'package:dio/dio.dart';
import '../providers/api_client.dart';
import '../models/product_model.dart';
import '../models/kategori_model.dart';

class ProductRepository {
  final ApiClient _apiClient;

  ProductRepository(this._apiClient);

  // ── List produk aktif (buyer) ─────────────────────────────────────────
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
      return ProductDummy.products;
    }
  }

  // ── Detail produk ─────────────────────────────────────────────────────
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

  // ── Kategori — endpoint sesuai backend: /kategori ─────────────────────
  // Return List<KategoriModel> supaya bisa kirim kategori_id (int) ke backend
  Future<List<KategoriModel>> getCategories() async {
    try {
      final response = await _apiClient.get('/kategori');

      // Backend return array langsung atau dibungkus { data: [...] }
      final List raw = response.data is List
          ? response.data
          : (response.data['data'] ?? response.data['kategori'] ?? []);

      return raw.map((e) => KategoriModel.fromJson(e)).toList();
    } on DioException catch (_) {
      // Fallback hardcode — sesuai data di upcycle_products.sql
      return const [
        KategoriModel(id: 1, nama: 'Fesyen',    slug: 'fesyen'),
        KategoriModel(id: 2, nama: 'Furnitur',  slug: 'furnitur'),
        KategoriModel(id: 3, nama: 'Aksesori',  slug: 'aksesori'),
        KategoriModel(id: 4, nama: 'Dekorasi',  slug: 'dekorasi'),
        KategoriModel(id: 5, nama: 'Elektronik',slug: 'elektronik'),
      ];
    }
  }

  // ── Tambah produk (seller) ────────────────────────────────────────────
  // Pakai Map<String, dynamic> — foto sudah diupload ke Firebase,
  // dikirim sebagai list URL string biasa (bukan file/FormData)
  Future<ProductModel> createProduct(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post('/products', data: data);
      return ProductModel.fromJson(
          response.data['product'] ?? response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ── Edit produk (seller) ──────────────────────────────────────────────
  Future<ProductModel> updateProduct(
      String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.put('/products/$id', data: data);
      return ProductModel.fromJson(
          response.data['product'] ?? response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ── Hapus produk (seller) ─────────────────────────────────────────────
  Future<void> deleteProduct(String id) async {
    try {
      await _apiClient.delete('/products/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ── Produk milik seller yang sedang login ─────────────────────────────
  // Endpoint sesuai backend README: GET /products/penjual/me
  Future<List<ProductModel>> getSellerProducts() async {
    try {
      final response = await _apiClient.get('/products/penjual/me');
      final List data = response.data['products'] ?? response.data ?? [];
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } on DioException catch (_) {
      return ProductDummy.products;
    }
  }

  // ── Error handler ─────────────────────────────────────────────────────
  String _handleError(DioException e) {
    if (e.response != null) {
      return e.response?.data['message'] ?? 'Terjadi kesalahan';
    }
    return 'Tidak dapat terhubung ke server';
  }
}
