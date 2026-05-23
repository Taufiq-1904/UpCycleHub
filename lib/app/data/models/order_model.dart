import 'product_model.dart';

class CartItemModel {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  int quantity;
  final int maxStock;
  final String sellerId;
  final String sellerName;

  CartItemModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.maxStock,
    required this.sellerId,
    required this.sellerName,
  });

  double get subtotal => price * quantity;

  factory CartItemModel.fromProduct(ProductModel product, {int quantity = 1}) {
    return CartItemModel(
      productId: product.id,
      productName: product.name,
      productImage: product.mainImage,
      price: product.price,
      quantity: quantity,
      maxStock: product.stock,
      sellerId: product.sellerId,
      sellerName: product.sellerName,
    );
  }

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'quantity': quantity,
      };
}

class OrderModel {
  final String id;
  final String userId;
  final List<OrderItemModel> items;
  final double totalAmount;
  final String paymentStatus;
  final String shippingStatus;
  final String? paymentProof;
  final String shippingAddress;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.paymentStatus,
    required this.shippingStatus,
    this.paymentProof,
    required this.shippingAddress,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      items: (json['items'] as List? ?? [])
          .map((e) => OrderItemModel.fromJson(e))
          .toList(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      paymentStatus: json['paymentStatus'] ?? 'pending',
      shippingStatus: json['shippingStatus'] ?? 'pending',
      paymentProof: json['paymentProof'],
      shippingAddress: json['shippingAddress'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  String get statusLabel {
    switch (paymentStatus) {
      case 'pending':
        return 'Menunggu Pembayaran';
      case 'paid':
        return 'Sudah Dibayar';
      case 'confirmed':
        return 'Dikonfirmasi';
      case 'rejected':
        return 'Ditolak';
      default:
        return paymentStatus;
    }
  }

  String get shippingLabel {
    switch (shippingStatus) {
      case 'pending':
        return 'Menunggu';
      case 'processing':
        return 'Diproses';
      case 'shipped':
        return 'Dikirim';
      case 'delivered':
        return 'Diterima';
      default:
        return shippingStatus;
    }
  }
}

class OrderItemModel {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;

  OrderItemModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['product']?['_id'] ?? json['productId'] ?? '',
      productName: json['product']?['name'] ?? json['productName'] ?? '',
      productImage:
          json['product']?['images']?[0] ?? json['productImage'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
    );
  }

  double get subtotal => price * quantity;
}

// Dummy orders
class OrderDummy {
  static List<OrderModel> get orders => [
        OrderModel(
          id: 'ORD001',
          userId: 'u1',
          items: [
            OrderItemModel(
              productId: '1',
              productName: 'Tas Kulit Upcycle Vintage',
              productImage:
                  'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400',
              price: 285000,
              quantity: 1,
            ),
          ],
          totalAmount: 285000,
          paymentStatus: 'paid',
          shippingStatus: 'shipped',
          shippingAddress: 'Jl. Merdeka No. 10, Jakarta Pusat',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        OrderModel(
          id: 'ORD002',
          userId: 'u1',
          items: [
            OrderItemModel(
              productId: '2',
              productName: 'Lampu Botol Kaca Artistik',
              productImage:
                  'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
              price: 125000,
              quantity: 2,
            ),
          ],
          totalAmount: 250000,
          paymentStatus: 'pending',
          shippingStatus: 'pending',
          shippingAddress: 'Jl. Merdeka No. 10, Jakarta Pusat',
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
      ];
}
