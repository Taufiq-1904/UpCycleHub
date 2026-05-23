import 'package:get/get.dart';
import 'checkout_controller.dart';
import '../cart/cart_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CheckoutController());
    Get.lazyPut(() => CartController());
  }
}
