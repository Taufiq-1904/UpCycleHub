import 'package:get/get.dart';
import 'seller_dashboard_controller.dart';

class penjualDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => penjualDashboardController());
  }
}
