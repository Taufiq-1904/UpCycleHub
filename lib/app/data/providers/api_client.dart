import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart' hide Response;
import '../../services/storage_service.dart';
import '../../routes/app_routes.dart';

class ApiClient {
  static const String baseUrl =
      'https://auth-service-420166052416.asia-southeast2.run.app';

  late dio.Dio _dio;

  ApiClient() {
    _dio = dio.Dio(
      dio.BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
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

    _dio.interceptors.add(
      dio.LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  Future<dio.Response> get(String path,
      {Map<String, dynamic>? queryParams}) async {
    return await _dio.get(path, queryParameters: queryParams);
  }

  Future<dio.Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }

  Future<dio.Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }

  Future<dio.Response> delete(String path) async {
    return await _dio.delete(path);
  }

  Future<dio.Response> postFormData(String path, dio.FormData formData) async {
    return await _dio.post(
      path,
      data: formData,
      options: dio.Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
  }

  Future<dio.Response> putFormData(String path, dio.FormData formData) async {
    return await _dio.put(
      path,
      data: formData,
      options: dio.Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
  }
}
