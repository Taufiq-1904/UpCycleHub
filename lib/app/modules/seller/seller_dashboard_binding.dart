import 'package:get/get.dart';
import 'seller_dashboard_controller.dart';

class SellerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SellerDashboardController());
  }
}
