import 'package:dio/dio.dart';
import '../providers/api_client.dart';
import '../models/order_model.dart';

class OrderRepository {
  final ApiClient _apiClient;

  OrderRepository(this._apiClient);

  Future<OrderModel> createOrder(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post('/orders', data: data);
      return OrderModel.fromJson(response.data['order']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<OrderModel>> getOrders() async {
    try {
      final response = await _apiClient.get('/orders');
      final List data = response.data['orders'] ?? [];
      return data.map((e) => OrderModel.fromJson(e)).toList();
    } on DioException catch (_) {
      return OrderDummy.orders;
    }
  }

  Future<OrderModel> getOrderById(String id) async {
    try {
      final response = await _apiClient.get('/orders/$id');
      return OrderModel.fromJson(response.data['order']);
    } on DioException catch (_) {
      return OrderDummy.orders.first;
    }
  }

  Future<OrderModel> uploadPaymentProof(
      String orderId, FormData formData) async {
    try {
      final response = await _apiClient.postFormData(
        '/orders/$orderId/payment-proof',
        formData,
      );
      return OrderModel.fromJson(response.data['order']);
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
