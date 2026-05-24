import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import '../../data/models/order_model.dart';

class CartController extends GetxController {
  final RxList<CartItemModel> items = <CartItemModel>[].obs;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice => items.fold(0, (sum, item) => sum + item.subtotal);

  void addItem(ProductModel product, int qty) {
    final existingIndex = items.indexWhere((i) => i.productId == product.id);
    if (existingIndex >= 0) {
      final item = items[existingIndex];
      final newQty = (item.quantity + qty).clamp(1, item.maxStock);
      items[existingIndex] = CartItemModel(
        productId: item.productId,
        productName: item.productName,
        productImage: item.productImage,
        price: item.price,
        quantity: newQty,
        maxStock: item.maxStock,
        penjualId: item.penjualId,
        penjualName: item.penjualName,
      );
    } else {
      items.add(CartItemModel.fromProduct(product, quantity: qty));
    }
  }

  void removeItem(String productId) {
    items.removeWhere((i) => i.productId == productId);
  }

  void updateQuantity(String productId, int qty) {
    final index = items.indexWhere((i) => i.productId == productId);
    if (index >= 0) {
      if (qty <= 0) {
        items.removeAt(index);
      } else {
        items[index].quantity = qty;
        items.refresh();
      }
    }
  }

  void clear() => items.clear();

  bool isInCart(String productId) => items.any((i) => i.productId == productId);
}
