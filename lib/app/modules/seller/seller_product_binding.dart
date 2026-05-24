import 'package:get/get.dart';
import 'seller_product_controller.dart';

class penjualProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => penjualProductController());
  }
}
