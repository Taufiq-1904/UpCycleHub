import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home/home_controller.dart';
import '../home/home_view.dart';
import '../product/product_list_view.dart';
import '../order/order_list_view.dart';
import '../chat/chat_list_view.dart';
import '../profile/profile_view.dart';
import '../../services/auth_service.dart';
import '../seller/seller_dashboard_view.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final authService = Get.find<AuthService>();

    // FIX: Ambil ispenjual di dalam Obx agar reaktif
    return Obx(() {
      final index = controller.currentIndex.value;
      // FIX: baca di dalam Obx supaya rebuild kalau role berubah
      final ispenjual = authService.currentUser.value?.role == 'penjual';

      final List<Widget> pages = ispenjual
          ? [
              const penjualDashboardView(isEmbedded: true),
              const ProductListView(isEmbedded: true),
              const OrderListView(isEmbedded: true),
              const ChatListView(isEmbedded: true),
              const ProfileView(isEmbedded: true),
            ]
          : [
              const HomeView(),
              const ProductListView(isEmbedded: true),
              const OrderListView(isEmbedded: true),
              const ChatListView(isEmbedded: true),
              const ProfileView(isEmbedded: true),
            ];

      return Scaffold(
        body: IndexedStack(
          index: index,
          children: pages,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: index,
            onTap: controller.changePage,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: const Icon(Icons.home_rounded),
                label: ispenjual ? 'Dashboard' : 'Beranda',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_outlined),
                activeIcon: Icon(Icons.grid_view_rounded),
                label: 'Produk',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_outlined),
                activeIcon: Icon(Icons.receipt_long_rounded),
                label: 'Pesanan',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline_rounded),
                activeIcon: Icon(Icons.chat_bubble_rounded),
                label: 'Chat',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                activeIcon: Icon(Icons.person_rounded),
                label: 'Profil',
              ),
            ],
          ),
        ),
      );
    });
  }
}
