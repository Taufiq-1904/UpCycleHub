import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinaryService {
  final Dio _dio = Dio();

  Future<String> uploadImage(File imageFile) async {
    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME']!;

    final uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET']!;

    final url = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imageFile.path,
      ),
      'upload_preset': uploadPreset,
    });

    try {
      final response = await _dio.post(
        url,
        data: formData,
      );

      print("CLOUDINARY SUCCESS");
      print(response.data);

      return response.data['secure_url'];
    } on DioException catch (e) {
      print("CLOUDINARY ERROR");
      print(e.response?.data);
      rethrow;
    }
  }
}
