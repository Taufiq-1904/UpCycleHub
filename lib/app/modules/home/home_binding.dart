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
    // FIX: Ganti lazyPut → put(fenix: true)
    // lazyPut hanya inisialisasi saat Get.find() pertama dipanggil.
    // IndexedStack langsung build semua tab sekaligus, sehingga
    // controller yang lazyPut belum ada saat view pertama di-render → blank/crash.
    // fenix: true = controller dibuat ulang kalau sudah di-dispose (aman untuk tab)
    Get.put(HomeController(), permanent: false);
    Get.put(ProductListController(), permanent: false);
    Get.put(OrderListController(), permanent: false);
    Get.put(ChatListController(), permanent: false);
    Get.put(ProfileController(), permanent: false);

    final authService = Get.find<AuthService>();
    if (authService.isSeller) {
      Get.put(SellerDashboardController(), permanent: false);
    }
  }
}
