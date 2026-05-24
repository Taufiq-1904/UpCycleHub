import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';
import '../seller/seller_dashboard_view.dart';
import '../seller/seller_product_view.dart';
import '../chat/chat_list_view.dart';
import '../profile/profile_view.dart';

class SellerMainView extends StatefulWidget {
  const SellerMainView({super.key});

  @override
  State<SellerMainView> createState() => _SellerMainViewState();
}

class _SellerMainViewState extends State<SellerMainView> {
  int _currentIndex = 0;

  // isEmbedded: true → sembunyikan back button, karena ini tab bukan halaman terpisah
  final List<Widget> _pages = const [
    SellerDashboardView(isEmbedded: true),
    SellerProductView(isEmbedded: true), // ← back button disembunyikan
    ChatListView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryGreen,
        unselectedItemColor: AppTheme.grey400,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2_rounded),
            label: 'Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            activeIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
