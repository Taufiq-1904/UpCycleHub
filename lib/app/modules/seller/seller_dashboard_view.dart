import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'seller_dashboard_controller.dart';
import '../../themes/app_theme.dart';
import '../../utils/app_utils.dart';
import '../../routes/app_routes.dart';
import '../../widgets/product_card.dart';
import '../../widgets/state_widgets.dart';
import '../../services/auth_service.dart';

class SellerDashboardView extends StatelessWidget {
  final bool isEmbedded;
  const SellerDashboardView({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SellerDashboardController>();
    final authService = Get.find<AuthService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Penjual'),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.SELLER_ADD_PRODUCT),
            icon: const Icon(Icons.add_circle_outline_rounded),
            tooltip: 'Tambah Produk',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const LoadingWidget();
        return RefreshIndicator(
          onRefresh: controller.loadDashboard,
          color: AppTheme.primaryGreen,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryGreen, AppTheme.lightGreen],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Halo, ${authService.userName.split(' ').first}!',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            const Text('Kelola toko upcycle-mu',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                      ),
                      const Icon(Icons.storefront_rounded,
                          color: Colors.white30, size: 48),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Stats Grid
                Text('Statistik',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: [
                    _StatCard(
                      isDark: isDark,
                      label: 'Total Produk',
                      value: '${controller.totalProducts.value}',
                      icon: Icons.inventory_2_outlined,
                      color: AppTheme.infoBlue,
                    ),
                    _StatCard(
                      isDark: isDark,
                      label: 'Disetujui',
                      value: '${controller.approvedProducts.value}',
                      icon: Icons.verified_outlined,
                      color: AppTheme.successGreen,
                    ),
                    _StatCard(
                      isDark: isDark,
                      label: 'Pending Review',
                      value: '${controller.pendingProducts.value}',
                      icon: Icons.pending_outlined,
                      color: AppTheme.warningOrange,
                    ),
                    _StatCard(
                      isDark: isDark,
                      label: 'Total Penjualan',
                      value: AppUtils.formatCurrency(
                          controller.totalRevenue.value),
                      icon: Icons.monetization_on_outlined,
                      color: AppTheme.primaryGreen,
                      isSmallText: true,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Quick Actions
                Text('Aksi Cepat',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        isDark: isDark,
                        icon: Icons.add_box_outlined,
                        label: 'Tambah Produk',
                        color: AppTheme.primaryGreen,
                        onTap: () => Get.toNamed(AppRoutes.SELLER_ADD_PRODUCT),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionButton(
                        isDark: isDark,
                        icon: Icons.inventory_outlined,
                        label: 'Kelola Produk',
                        color: AppTheme.infoBlue,
                        onTap: () =>
                            Get.toNamed(AppRoutes.SELLER_PRODUCT_MANAGEMENT),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // My Products
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Produk Saya',
                        style: Theme.of(context).textTheme.titleLarge),
                    TextButton(
                      onPressed: () =>
                          Get.toNamed(AppRoutes.SELLER_PRODUCT_MANAGEMENT),
                      child: const Text('Lihat Semua'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                controller.products.isEmpty
                    ? EmptyStateWidget(
                        title: 'Belum Ada Produk',
                        subtitle: 'Tambahkan produk pertamamu!',
                        icon: Icons.add_box_outlined,
                        buttonText: 'Tambah Produk',
                        onButtonPressed: () =>
                            Get.toNamed(AppRoutes.SELLER_ADD_PRODUCT),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: controller.products.take(4).length,
                        itemBuilder: (context, index) =>
                            ProductCard(product: controller.products[index]),
                      ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  final bool isDark, isSmallText;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDark,
    this.isSmallText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: isDark ? const Color(0xFF2D4A38) : AppTheme.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: isSmallText ? 13 : 20,
                    color: color,
                  )),
              Text(label,
                  style:
                      const TextStyle(fontSize: 12, color: AppTheme.grey400)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isDark;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(label,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.w600, fontSize: 13),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
