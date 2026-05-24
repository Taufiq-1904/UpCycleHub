import 'package:dio/dio.dart';
import '../providers/api_client.dart';
import '../models/review_model.dart';

class ReviewRepository {
  final ApiClient _apiClient;

  ReviewRepository(this._apiClient);

  Future<List<ReviewModel>> getReviews(String productId) async {
    try {
      final response = await _apiClient.productGet('/verifikasi/review/$productId');
      final List data = response.data['reviews'] ?? response.data ?? [];
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
      final response = await _apiClient.productPost(
        '/verifikasi/review/$productId',
        data: {
          'rating': rating,
          'comment': comment,
        },
      );
      return ReviewModel.fromJson(response.data['review'] ?? response.data);
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Gagal menambah review';
    }
  }
}
