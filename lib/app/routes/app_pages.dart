import 'package:get/get.dart';
import '../modules/auth/login_binding.dart';
import '../modules/auth/login_view.dart';
import '../modules/auth/register_binding.dart';
import '../modules/auth/register_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/main_view.dart';
import '../modules/home/seller_main_view.dart'; // ← BARU
import '../modules/product/product_list_binding.dart';
import '../modules/product/product_list_view.dart';
import '../modules/product/product_detail_binding.dart';
import '../modules/product/product_detail_view.dart';
import '../modules/cart/cart_binding.dart';
import '../modules/cart/cart_view.dart';
import '../modules/checkout/checkout_binding.dart';
import '../modules/checkout/checkout_view.dart';
import '../modules/order/order_list_binding.dart';
import '../modules/order/order_list_view.dart';
import '../modules/order/order_detail_binding.dart';
import '../modules/order/order_detail_view.dart';
import '../modules/review/review_binding.dart';
import '../modules/review/review_view.dart';
import '../modules/profile/profile_binding.dart';
import '../modules/profile/profile_view.dart';
import '../modules/profile/edit_profile_view.dart';
import '../modules/seller/seller_dashboard_binding.dart';
import '../modules/seller/seller_dashboard_view.dart';
import '../modules/seller/seller_product_binding.dart';
import '../modules/seller/seller_product_view.dart';
import '../modules/seller/seller_add_product_view.dart';
import '../modules/chat/chat_list_binding.dart';
import '../modules/chat/chat_list_view.dart';
import '../modules/chat/chat_room_binding.dart';
import '../modules/chat/chat_room_view.dart';
import '../modules/notification/notification_binding.dart';
import '../modules/notification/notification_view.dart';
import '../modules/home/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.SPLASH, page: () => const SplashView()),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),

    // ── pembeli main (home pembeli + bottom nav pembeli) ─────────────────────────
    GetPage(
      name: AppRoutes.MAIN,
      page: () => const MainView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const MainView(),
      binding: HomeBinding(),
    ),

    // ── penjual main (dashboard + bottom nav penjual) ← BARU ───────────────
    GetPage(
      name: AppRoutes.penjual_MAIN,
      page: () => const penjualMainView(),
      // penjualMainView menampilkan beberapa halaman sekaligus,
      // jadi kita bind semua dependency yang dibutuhkan di sini
      bindings: [
        penjualDashboardBinding(),
        penjualProductBinding(),
        ChatListBinding(),
        ProfileBinding(),
      ],
    ),

    GetPage(
      name: AppRoutes.PRODUCT_LIST,
      page: () => const ProductListView(),
      binding: ProductListBinding(),
    ),
    GetPage(
      name: AppRoutes.PRODUCT_DETAIL,
      page: () => const ProductDetailView(),
      binding: ProductDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.CART,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: AppRoutes.CHECKOUT,
      page: () => const CheckoutView(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: AppRoutes.ORDER_LIST,
      page: () => const OrderListView(),
      binding: OrderListBinding(),
    ),
    GetPage(
      name: AppRoutes.ORDER_DETAIL,
      page: () => const OrderDetailView(),
      binding: OrderDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.REVIEW,
      page: () => const ReviewView(),
      binding: ReviewBinding(),
    ),
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.penjual_DASHBOARD,
      page: () => const penjualDashboardView(),
      binding: penjualDashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.penjual_PRODUCT_MANAGEMENT,
      page: () => const penjualProductView(),
      binding: penjualProductBinding(),
    ),
    GetPage(
      name: AppRoutes.penjual_ADD_PRODUCT,
      page: () => const penjualAddProductView(),
      binding: penjualProductBinding(),
    ),
    GetPage(
      name: AppRoutes.penjual_EDIT_PRODUCT,
      page: () => const penjualAddProductView(isEdit: true),
      binding: penjualProductBinding(),
    ),
    GetPage(
      name: AppRoutes.CHAT_LIST,
      page: () => const ChatListView(),
      binding: ChatListBinding(),
    ),
    GetPage(
      name: AppRoutes.CHAT_ROOM,
      page: () => const ChatRoomView(),
      binding: ChatRoomBinding(),
    ),
    GetPage(
      name: AppRoutes.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
  ];
}
