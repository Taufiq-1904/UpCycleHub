import 'package:get/get.dart';
import 'product_detail_controller.dart';
import '../cart/cart_controller.dart';

class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductDetailController());
    Get.lazyPut(() => CartController());
  }
}
