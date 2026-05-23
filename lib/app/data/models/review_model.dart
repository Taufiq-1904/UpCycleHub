class ReviewModel {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String? userAvatar;
  final double rating;
  final String comment;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['_id'] ?? json['id'] ?? '',
      productId: json['productId'] ?? '',
      userId: json['user']?['_id'] ?? json['userId'] ?? '',
      userName: json['user']?['name'] ?? json['userName'] ?? '',
      userAvatar: json['user']?['avatar'] ?? json['userAvatar'],
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}

class ReviewDummy {
  static List<ReviewModel> get reviews => [
        ReviewModel(
          id: 'r1',
          productId: '1',
          userId: 'u1',
          userName: 'Sari Dewi',
          rating: 5,
          comment:
              'Produk sangat bagus! Kualitas kulit premium dan jahitannya rapi. Pengiriman cepat. Sangat direkomendasikan!',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        ReviewModel(
          id: 'r2',
          productId: '1',
          userId: 'u2',
          userName: 'Budi Santoso',
          rating: 4,
          comment:
              'Tas unik dan stylish. Ramah lingkungan pula. Agak sedikit lebih kecil dari ekspektasi tapi tetap suka.',
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
        ReviewModel(
          id: 'r3',
          productId: '1',
          userId: 'u3',
          userName: 'Anisa Rahman',
          rating: 5,
          comment:
              'Wow keren banget! Udah punya 3 tas dari toko ini. Semua kualitas oke. Seller responsif juga.',
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
        ),
      ];
}
