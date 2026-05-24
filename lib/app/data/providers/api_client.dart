import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../config/app_config.dart';

class ApiClient {
  late final Dio _authDio;
  late final Dio _productDio;
  final _storage = const FlutterSecureStorage();

  ApiClient() {
    _authDio = _buildDio(AppConfig.authBaseUrl);
    _productDio = _buildDio(AppConfig.productBaseUrl);

    _addJwtInterceptor(_authDio);
    _addJwtInterceptor(_productDio);
  }

  Dio _buildDio(String baseUrl) => Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: Duration(milliseconds: AppConfig.connectTimeout),
          receiveTimeout: Duration(milliseconds: AppConfig.receiveTimeout),
          headers: {'Content-Type': 'application/json'},
        ),
      );

  void _addJwtInterceptor(Dio dio) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'auth_token');
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
              final token = await _storage.read(key: 'auth_token');
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
      final refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken == null) return false;

      final response = await Dio().post(
        '${AppConfig.authApiUrl}/refresh',
        data: {'refresh_token': refreshToken},
      );

      final newToken = response.data['access_token'];
      if (newToken != null) {
        await _storage.write(key: 'access_token', value: newToken);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  // ── Auth Service (/auth) ──────────────────────────────────────────────────
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) =>
      _authDio.get(path, queryParameters: queryParams);

  Future<Response> post(String path, {dynamic data}) =>
      _authDio.post(path, data: data);

  Future<Response> put(String path, {dynamic data}) =>
      _authDio.put(path, data: data);

  Future<Response> putFormData(String path, FormData formData) =>
      _authDio.put(path,
          data: formData,
          options: Options(headers: {'Content-Type': 'multipart/form-data'}));

  Future<Response> delete(String path) => _authDio.delete(path);

  // ── Product Service (/products, /kategori, /transaksi, /reviews, dll) ─────
  Future<Response> productGet(String path,
          {Map<String, dynamic>? queryParams}) =>
      _productDio.get(path, queryParameters: queryParams);

  Future<Response> productPost(String path, {dynamic data}) =>
      _productDio.post(path, data: data);

  Future<Response> productPostFormData(String path, FormData formData) =>
      _productDio.post(path,
          data: formData,
          options: Options(headers: {'Content-Type': 'multipart/form-data'}));

  Future<Response> productPut(String path, {dynamic data}) =>
      _productDio.put(path, data: data);

  Future<Response> productDelete(String path) => _productDio.delete(path);

  // Alias — biar repository lama yang pakai postFormData tidak perlu diganti
  Future<Response> postFormData(String path, FormData formData) =>
      productPostFormData(path, formData);
}
