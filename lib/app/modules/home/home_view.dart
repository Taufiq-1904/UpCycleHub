import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'home_controller.dart';
import '../../themes/app_theme.dart';
import '../../widgets/product_card.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final authService = Get.find<AuthService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pageController = PageController();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.loadData,
          color: AppTheme.primaryGreen,
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      // Logo
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.recycling_rounded,
                                color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'UpCycleHub',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primaryGreen,
                                ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Notification
                      IconButton(
                        onPressed: () => Get.toNamed(AppRoutes.NOTIFICATION),
                        icon: const Icon(Icons.notifications_outlined),
                        style: IconButton.styleFrom(
                          backgroundColor:
                              isDark ? AppTheme.darkCard : AppTheme.grey100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Cart
                      IconButton(
                        onPressed: () => Get.toNamed(AppRoutes.CART),
                        icon: const Icon(Icons.shopping_cart_outlined),
                        style: IconButton.styleFrom(
                          backgroundColor:
                              isDark ? AppTheme.darkCard : AppTheme.grey100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Greeting
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, ${authService.userName.split(' ').first} 👋',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Temukan produk upcycle terbaik',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),

              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.PRODUCT_LIST),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.darkCard : AppTheme.grey100,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF2D4A38)
                              : AppTheme.grey200,
                        ),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          const Icon(Icons.search_rounded,
                              color: AppTheme.grey400),
                          const SizedBox(width: 12),
                          Text(
                            'Cari produk upcycle...',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppTheme.grey400,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Banner Promo
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 160,
                        child: PageView.builder(
                          controller: pageController,
                          itemCount: controller.banners.length,
                          itemBuilder: (context, index) {
                            final banner = controller.banners[index];
                            return Container(
                              margin: const EdgeInsets.only(right: 4),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppTheme.primaryGreen,
                                    AppTheme.lightGreen,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(24),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          banner['title']!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          banner['subtitle']!,
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.85),
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: const Text(
                                            'Belanja Sekarang',
                                            style: TextStyle(
                                              color: AppTheme.primaryGreen,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.recycling_rounded,
                                    size: 80,
                                    color: Colors.white24,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      SmoothPageIndicator(
                        controller: pageController,
                        count: controller.banners.length,
                        effect: const WormEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          activeDotColor: AppTheme.primaryGreen,
                          dotColor: AppTheme.grey200,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Category
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kategori',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed(AppRoutes.PRODUCT_LIST),
                        child: const Text('Lihat Semua'),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Obx(() => SizedBox(
                      height: 50,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: controller.categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final cat = controller.categories[index];
                          return GestureDetector(
                            onTap: () => Get.toNamed(
                              AppRoutes.PRODUCT_LIST,
                              arguments: {'category': cat},
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppTheme.darkCard
                                    : AppTheme.softGreen,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0xFF2D4A38)
                                      : AppTheme.accentGreen.withOpacity(0.5),
                                ),
                              ),
                              child: Text(
                                cat,
                                style: TextStyle(
                                  color: isDark
                                      ? AppTheme.lightGreen
                                      : AppTheme.primaryGreen,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )),
              ),

              // Featured Products
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Produk Unggulan',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed(AppRoutes.PRODUCT_LIST),
                        child: const Text('Lihat Semua'),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Obx(() => SizedBox(
                      height: 280,
                      child: controller.isLoading.value
                          ? ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: 4,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (_, __) => const SizedBox(
                                width: 180,
                                child: ProductCardSkeleton(),
                              ),
                            )
                          : ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                              itemCount: controller.featuredProducts.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, index) => SizedBox(
                                width: 180,
                                child: ProductCard(
                                  product: controller.featuredProducts[index],
                                  isCompact: true,
                                ),
                              ),
                            ),
                    )),
              ),

              // Popular Products
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Produk Terlaris',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed(AppRoutes.PRODUCT_LIST),
                        child: const Text('Lihat Semua'),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                sliver: Obx(() => SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => controller.isLoading.value
                            ? const ProductCardSkeleton()
                            : ProductCard(
                                product: controller.popularProducts[index],
                              ),
                        childCount: controller.isLoading.value
                            ? 4
                            : controller.popularProducts.length,
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
