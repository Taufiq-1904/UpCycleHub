class ProductModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final int stock;
  final List<String> images;
  final String sellerId;
  final String sellerName;
  final String? sellerAvatar;
  final String verificationStatus;
  final double rating;
  final int reviewCount;
  final int soldCount;
  final DateTime? createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.stock,
    required this.images,
    required this.sellerId,
    required this.sellerName,
    this.sellerAvatar,
    this.verificationStatus = 'pending',
    this.rating = 0,
    this.reviewCount = 0,
    this.soldCount = 0,
    this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? json['nama'] ?? '',
      description: json['description'] ?? json['deskripsi'] ?? '',
      category: json['category'] ?? json['kategori'] ?? '',
      price: double.tryParse(
            json['harga']?.toString() ?? json['price']?.toString() ?? '0',
          ) ??
          0,
      stock: json['stok'] ?? json['stock'] ?? 0,
      images: List<String>.from(
        json['fotos'] ?? json['images'] ?? [],
      ),
      sellerId: json['seller']?['_id'] ?? json['sellerId'] ?? '',
      sellerName: json['seller']?['name'] ?? json['sellerName'] ?? '',
      sellerAvatar: json['seller']?['avatar'] ?? json['sellerAvatar'],
      verificationStatus: json['verificationStatus'] ?? 'pending',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      soldCount: json['soldCount'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'category': category,
        'price': price,
        'stock': stock,
        'images': images,
        'sellerId': sellerId,
        'sellerName': sellerName,
        'verificationStatus': verificationStatus,
        'rating': rating,
        'reviewCount': reviewCount,
        'soldCount': soldCount,
      };

  String get mainImage => images.isNotEmpty ? images[0] : '';
  bool get isApproved => verificationStatus == 'approved';
  bool get inStock => stock > 0;
}

// Dummy data for development
class ProductDummy {
  static List<ProductModel> get products => [
        ProductModel(
          id: '1',
          name: 'Tas Kulit Upcycle Vintage',
          description:
              'Tas cantik berbahan kulit daur ulang dari jaket lama. Kualitas premium, ramah lingkungan.',
          category: 'Fashion',
          price: 285000,
          stock: 15,
          images: [
            'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400',
            'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400',
          ],
          sellerId: 's1',
          sellerName: 'EcoStyle Studio',
          verificationStatus: 'approved',
          rating: 4.8,
          reviewCount: 124,
          soldCount: 89,
        ),
        ProductModel(
          id: '2',
          name: 'Lampu Botol Kaca Artistik',
          description:
              'Lampu dekorasi dari botol kaca bekas. Hemat energi dengan LED, cocok untuk ruang tamu.',
          category: 'Dekorasi',
          price: 125000,
          stock: 30,
          images: [
            'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
          ],
          sellerId: 's2',
          sellerName: 'GreenCraft ID',
          verificationStatus: 'approved',
          rating: 4.6,
          reviewCount: 67,
          soldCount: 45,
        ),
        ProductModel(
          id: '3',
          name: 'Pot Tanaman dari Ban Bekas',
          description:
              'Pot unik dan kuat dari ban bekas yang sudah dicat ulang. Tahan cuaca.',
          category: 'Tanaman',
          price: 75000,
          stock: 50,
          images: [
            'https://images.unsplash.com/photo-1466781783364-36c955e42a7f?w=400',
          ],
          sellerId: 's1',
          sellerName: 'EcoStyle Studio',
          verificationStatus: 'approved',
          rating: 4.4,
          reviewCount: 38,
          soldCount: 120,
        ),
        ProductModel(
          id: '4',
          name: 'Dompet Kain Perca Batik',
          description:
              'Dompet cantik dari kain perca batik asli Jogja. Setiap produk unik dan berbeda.',
          category: 'Fashion',
          price: 65000,
          stock: 25,
          images: [
            'https://images.unsplash.com/photo-1627123424574-724758594e93?w=400',
          ],
          sellerId: 's3',
          sellerName: 'Batik Recycle Co',
          verificationStatus: 'approved',
          rating: 4.7,
          reviewCount: 92,
          soldCount: 200,
        ),
        ProductModel(
          id: '5',
          name: 'Meja Kayu Palet Minimalis',
          description:
              'Meja coffee table dari kayu palet daur ulang. Desain minimalis modern.',
          category: 'Furnitur',
          price: 650000,
          stock: 5,
          images: [
            'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400',
          ],
          sellerId: 's2',
          sellerName: 'GreenCraft ID',
          verificationStatus: 'approved',
          rating: 4.9,
          reviewCount: 15,
          soldCount: 12,
        ),
        ProductModel(
          id: '6',
          name: 'Kalung Upcycle Tutup Botol',
          description:
              'Kalung unik dari tutup botol bekas yang dicat dan disusun menjadi aksesori cantik.',
          category: 'Aksesori',
          price: 45000,
          stock: 100,
          images: [
            'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=400',
          ],
          sellerId: 's3',
          sellerName: 'Batik Recycle Co',
          verificationStatus: 'approved',
          rating: 4.3,
          reviewCount: 54,
          soldCount: 310,
        ),
      ];
}
