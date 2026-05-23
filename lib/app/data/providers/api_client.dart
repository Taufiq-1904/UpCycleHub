import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart' hide Response;
import '../../services/storage_service.dart';
import '../../routes/app_routes.dart';

class ApiClient {
  // Auth Service: /register, /login, /profile, /auth/*
  static const String authBaseUrl =
      'https://auth-service-420166052416.asia-southeast2.run.app';

  // Product Service: /products, /categories, /transaksi, /orders, /verifikasi, /reviews
  // ⚠️ Ganti URL ini dengan URL product-service kamu di GCP Cloud Run
  static const String productBaseUrl =
      'https://product-service-420166052416.asia-southeast2.run.app';

  late dio.Dio _authDio;
  late dio.Dio _productDio;

  ApiClient() {
    _authDio = _createDio(authBaseUrl);
    _productDio = _createDio(productBaseUrl);
  }

  dio.Dio _createDio(String baseUrl) {
    final instance = dio.Dio(
      dio.BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    instance.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) async {
          final storage = Get.find<StorageService>();
          final token = await storage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (dio.DioException e, handler) {
          if (e.response?.statusCode == 401) {
            Get.find<StorageService>().clearAll();
            Get.offAllNamed(AppRoutes.LOGIN);
          }
          handler.next(e);
        },
      ),
    );

    instance.interceptors.add(
      dio.LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );

    return instance;
  }

  // Pilih Dio yang tepat berdasarkan path
  // Auth-service: /register, /login, /profile, /auth/
  // Product-service: semua lainnya (/products, /categories, /transaksi, /orders, /verifikasi, /reviews)
  dio.Dio _selectDio(String path) {
    const authPaths = ['/register', '/login', '/profile', '/auth/'];
    for (final prefix in authPaths) {
      if (path.startsWith(prefix)) return _authDio;
    }
    return _productDio;
  }

  Future<dio.Response> get(String path,
      {Map<String, dynamic>? queryParams}) async {
    return await _selectDio(path).get(path, queryParameters: queryParams);
  }

  Future<dio.Response> post(String path, {dynamic data}) async {
    return await _selectDio(path).post(path, data: data);
  }

  Future<dio.Response> put(String path, {dynamic data}) async {
    return await _selectDio(path).put(path, data: data);
  }

  Future<dio.Response> delete(String path) async {
    return await _selectDio(path).delete(path);
  }

  Future<dio.Response> postFormData(String path, dio.FormData formData) async {
    return await _selectDio(path).post(
      path,
      data: formData,
      options: dio.Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
  }

  Future<dio.Response> putFormData(String path, dio.FormData formData) async {
    return await _selectDio(path).put(
      path,
      data: formData,
      options: dio.Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
  }
}
