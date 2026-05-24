import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../../config/app_config.dart';
import '../../services/storage_service.dart';

class ApiClient {
  late final dio.Dio _authDio;
  late final dio.Dio _productDio;
  StorageService get _storage => Get.find<StorageService>();

  ApiClient() {
    _authDio = _buildDio(AppConfig.authBaseUrl);
    _productDio = _buildDio(AppConfig.productBaseUrl);

    _addJwtInterceptor(_authDio);
    _addJwtInterceptor(_productDio);
  }

  dio.Dio _buildDio(String baseUrl) => dio.Dio(
        dio.BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: Duration(milliseconds: AppConfig.connectTimeout),
          receiveTimeout: Duration(milliseconds: AppConfig.receiveTimeout),
          headers: {'Content-Type': 'application/json'},
        ),
      );

  void _addJwtInterceptor(dio.Dio client) {
    client.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.getToken();
          print('TOKEN: $token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          print('REQUEST: ${options.method} ${options.baseUrl}${options.path}');
          print('HEADERS: ${options.headers}');
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshed = await _tryRefreshToken();
            if (refreshed) {
              final token = await _storage.getToken();
              error.requestOptions.headers['Authorization'] = 'Bearer $token';
              final retryDio = _buildDio(error.requestOptions.baseUrl);
              try {
                final response = await retryDio.fetch(error.requestOptions);
                return handler.resolve(response);
              } catch (e) {
                return handler.next(error);
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<bool> _tryRefreshToken() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await dio.Dio().post(
        '${AppConfig.authApiUrl}/refresh',
        data: {'refresh_token': refreshToken},
      );

      final newToken = response.data['auth_token']?.toString();
      if (newToken != null) {
        await _storage.saveToken(newToken);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  // ── Auth Service (/auth) ──────────────────────────────────────────────────
  Future<dio.Response> get(String path, {Map<String, dynamic>? queryParams}) =>
      _authDio.get(path, queryParameters: queryParams);

  Future<dio.Response> post(String path, {dynamic data}) =>
      _authDio.post(path, data: data);

  Future<dio.Response> put(String path, {dynamic data}) =>
      _authDio.put(path, data: data);

  Future<dio.Response> putFormData(String path, dio.FormData formData) =>
      _authDio.put(path,
          data: formData,
          options:
              dio.Options(headers: {'Content-Type': 'multipart/form-data'}));

  Future<dio.Response> delete(String path) => _authDio.delete(path);

  // ── Product Service (/products, /kategori, /transaksi, /reviews, dll) ─────
  Future<dio.Response> productGet(String path,
          {Map<String, dynamic>? queryParams}) =>
      _productDio.get(path, queryParameters: queryParams);

  Future<dio.Response> productPost(String path, {dynamic data}) =>
      _productDio.post(path, data: data);

  Future<dio.Response> productPostFormData(
          String path, dio.FormData formData) =>
      _productDio.post(path,
          data: formData,
          options:
              dio.Options(headers: {'Content-Type': 'multipart/form-data'}));

  Future<dio.Response> productPut(String path, {dynamic data}) =>
      _productDio.put(path, data: data);

  Future<dio.Response> productDelete(String path) => _productDio.delete(path);

  // Alias — biar repository lama yang pakai postFormData tidak perlu diganti
  Future<dio.Response> postFormData(String path, dio.FormData formData) =>
      productPostFormData(path, formData);
}
