import 'package:get/get.dart';
import 'home_controller.dart';
import '../product/product_list_controller.dart';
import '../order/order_list_controller.dart';
import '../chat/chat_list_controller.dart';
import '../profile/profile_controller.dart';
import '../seller/seller_dashboard_controller.dart';
import '../../services/auth_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => ProductListController());
    Get.lazyPut(() => OrderListController());
    Get.lazyPut(() => ChatListController());
    Get.lazyPut(() => ProfileController());

    final authService = Get.find<AuthService>();
    if (authService.isSeller) {
      Get.lazyPut(() => SellerDashboardController());
    }
  }
}
