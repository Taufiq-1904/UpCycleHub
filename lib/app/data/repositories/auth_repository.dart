import 'package:dio/dio.dart';
import '../providers/api_client.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiClient.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return {
        'user': UserModel.fromJson(response.data['user']),
        'token': response.data['token'],
      };
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await _apiClient.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      });
      return {
        'user': UserModel.fromJson(response.data['user']),
        'token': response.data['token'],
      };
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserModel> getProfile() async {
    try {
      final response = await _apiClient.get('/profile');
      return UserModel.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserModel> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.put('/profile', data: data);
      return UserModel.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserModel> updateProfileWithAvatar(FormData formData) async {
    try {
      final response = await _apiClient.putFormData('/profile', formData);
      return UserModel.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      return e.response?.data['message'] ?? 'Terjadi kesalahan';
    }
    return 'Tidak dapat terhubung ke server';
  }
}
