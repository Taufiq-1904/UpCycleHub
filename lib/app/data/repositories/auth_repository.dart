import 'package:dio/dio.dart';
import '../providers/api_client.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  // ================= LOGIN =================

  Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await _apiClient.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      return {
        'token': response.data['token'],
        'refresh_token': response.data['refresh_token'],
        'role': response.data['role'],
        'message': response.data['message'],
      };
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ================= REGISTER =================

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ================= PROFILE =================

  Future<UserModel> getProfile() async {
    try {
      final response = await _apiClient.get(
        '/auth/profile',
      );

      final profileData =
          response.data['user'] ?? response.data['data'] ?? response.data;

      return UserModel.fromJson(profileData);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ================= UPDATE PROFILE =================

  Future<UserModel> updateProfile(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _apiClient.put(
        '/auth/profile',
        data: data,
      );

      final profileData =
          response.data['user'] ?? response.data['data'] ?? response.data;

      return UserModel.fromJson(profileData);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ================= UPDATE PROFILE + PHOTO =================

  Future<UserModel> updateProfileWithAvatar(
    FormData formData,
  ) async {
    try {
      final response = await _apiClient.putFormData(
        '/auth/profile',
        formData,
      );

      final profileData =
          response.data['user'] ?? response.data['data'] ?? response.data;

      return UserModel.fromJson(profileData);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ================= REFRESH TOKEN =================

  Future<Map<String, dynamic>> refreshToken(
    String refreshToken,
  ) async {
    try {
      final response = await _apiClient.post(
        '/auth/refresh',
        data: {
          'refresh_token': refreshToken,
        },
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ================= ERROR HANDLER =================

  String _handleError(DioException e) {
    if (e.response != null) {
      try {
        return e.response?.data['message'] ?? 'Terjadi kesalahan';
      } catch (_) {
        return 'Terjadi kesalahan';
      }
    }

    return 'Tidak dapat terhubung ke server';
  }
}
