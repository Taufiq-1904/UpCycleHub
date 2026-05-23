import 'package:dio/dio.dart';
import '../providers/api_client.dart';
import '../models/review_model.dart';

class ReviewRepository {
  final ApiClient _apiClient;

  ReviewRepository(this._apiClient);

  Future<List<ReviewModel>> getReviews(String productId) async {
    try {
      final response = await _apiClient.get('/reviews/$productId');
      final List data = response.data['reviews'] ?? [];
      return data.map((e) => ReviewModel.fromJson(e)).toList();
    } on DioException catch (_) {
      return ReviewDummy.reviews;
    }
  }

  Future<ReviewModel> addReview({
    required String productId,
    required double rating,
    required String comment,
  }) async {
    try {
      final response = await _apiClient.post('/reviews', data: {
        'productId': productId,
        'rating': rating,
        'comment': comment,
      });
      return ReviewModel.fromJson(response.data['review']);
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Gagal menambah review';
    }
  }
}
