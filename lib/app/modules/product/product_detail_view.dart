import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'product_detail_controller.dart';
import '../../themes/app_theme.dart';
import '../../utils/app_utils.dart';
import '../../widgets/app_button.dart';
import '../../widgets/state_widgets.dart';
import '../../routes/app_routes.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductDetailController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'Memuat produk...');
        }
        final product = controller.product.value;
        if (product == null) {
          return const ErrorStateWidget(message: 'Produk tidak ditemukan');
        }

        return CustomScrollView(
          slivers: [
            // Image Gallery App Bar
            SliverAppBar(
              expandedHeight: 340,
              pinned: true,
              leading: IconButton(
                onPressed: Get.back,
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 18, color: AppTheme.grey800),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () => Get.toNamed(AppRoutes.CART),
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shopping_cart_outlined,
                        size: 18, color: AppTheme.grey800),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    // Main image
                    Obx(() => CachedNetworkImage(
                          imageUrl: product.images.isNotEmpty
                              ? product
                                  .images[controller.selectedImageIndex.value]
                              : '',
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(
                            color: AppTheme.softGreen,
                            child: const Icon(
                                Icons.image_not_supported_outlined,
                                size: 64,
                                color: AppTheme.primaryGreen),
                          ),
                        )),
                    // Thumbnail row
                    if (product.images.length > 1)
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            product.images.length,
                            (i) => Obx(() => GestureDetector(
                                  onTap: () => controller.selectImage(i),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    width:
                                        controller.selectedImageIndex.value == i
                                            ? 32
                                            : 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: controller
                                                    .selectedImageIndex.value ==
                                                i
                                            ? AppTheme.primaryGreen
                                            : Colors.white,
                                        width: 2,
                                      ),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            product.images[i]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Product Info
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkBg : AppTheme.offWhite,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category + Verification
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.softGreen,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              product.category,
                              style: const TextStyle(
                                color: AppTheme.primaryGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (product.isApproved)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.successGreen.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.verified_rounded,
                                      size: 14, color: AppTheme.successGreen),
                                  SizedBox(width: 4),
                                  Text('Terverifikasi',
                                      style: TextStyle(
                                        color: AppTheme.successGreen,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Name
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),

                      // Price + Stock
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            AppUtils.formatCurrency(product.price),
                            style: const TextStyle(
                              color: AppTheme.primaryGreen,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: product.inStock
                                  ? AppTheme.softGreen
                                  : AppTheme.errorRed.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              product.inStock
                                  ? 'Stok: ${product.stock}'
                                  : 'Habis',
                              style: TextStyle(
                                color: product.inStock
                                    ? AppTheme.primaryGreen
                                    : AppTheme.errorRed,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Rating + Sold
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: product.rating,
                            itemBuilder: (_, __) => const Icon(
                              Icons.star_rounded,
                              color: AppTheme.warningOrange,
                            ),
                            itemCount: 5,
                            itemSize: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${product.rating.toStringAsFixed(1)} (${product.reviewCount} ulasan)',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${product.soldCount} terjual',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      const Divider(),
                      const SizedBox(height: 16),

                      // Description
                      Text(
                        'Deskripsi',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.6,
                            ),
                      ),
                      const SizedBox(height: 20),

                      // penjual Info
                      const Divider(),
                      const SizedBox(height: 16),
                      Text(
                        'Informasi Penjual',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.CHAT_ROOM,
                            arguments: {'product': product}),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? AppTheme.darkCard : AppTheme.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppTheme.grey200),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: AppTheme.softGreen,
                                backgroundImage: product.penjualAvatar != null
                                    ? CachedNetworkImageProvider(
                                        product.penjualAvatar!)
                                    : null,
                                child: product.penjualAvatar == null
                                    ? Text(
                                        product.penjualName[0].toUpperCase(),
                                        style: const TextStyle(
                                          color: AppTheme.primaryGreen,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.penjualName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const Text(
                                      'Penjual Terverifikasi',
                                      style: TextStyle(
                                        color: AppTheme.grey400,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppTheme.softGreen,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.chat_outlined,
                                        size: 16, color: AppTheme.primaryGreen),
                                    SizedBox(width: 4),
                                    Text('Chat',
                                        style: TextStyle(
                                          color: AppTheme.primaryGreen,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Reviews
                      const Divider(),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ulasan Pembeli',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          TextButton(
                            onPressed: () => Get.toNamed(AppRoutes.REVIEW,
                                arguments: product.id),
                            child: const Text('Tambah Ulasan'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Obx(() => controller.reviews.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: Text(
                                  'Belum ada ulasan',
                                  style: TextStyle(color: AppTheme.grey400),
                                ),
                              ),
                            )
                          : Column(
                              children: controller.reviews
                                  .take(3)
                                  .map((review) => _ReviewItem(
                                      review: review, isDark: isDark))
                                  .toList(),
                            )),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        final product = controller.product.value;
        if (product == null) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkSurface : AppTheme.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Quantity Selector
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkCard : AppTheme.grey100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: controller.decrementQuantity,
                      icon: const Icon(Icons.remove_rounded),
                      iconSize: 20,
                    ),
                    Obx(() => SizedBox(
                          width: 32,
                          child: Text(
                            '${controller.quantity.value}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        )),
                    IconButton(
                      onPressed: controller.incrementQuantity,
                      icon: const Icon(Icons.add_rounded),
                      iconSize: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  text: product.inStock ? 'Tambah ke Keranjang' : 'Habis',
                  onPressed: product.inStock ? controller.addToCart : null,
                  icon: Icons.shopping_cart_outlined,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final dynamic review;
  final bool isDark;

  const _ReviewItem({required this.review, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.grey50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppTheme.softGreen,
                child: Text(
                  review.userName[0].toUpperCase(),
                  style: const TextStyle(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.userName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13)),
                    Text(
                      timeago.format(review.createdAt, locale: 'id'),
                      style: const TextStyle(
                          fontSize: 11, color: AppTheme.grey400),
                    ),
                  ],
                ),
              ),
              RatingBarIndicator(
                rating: review.rating,
                itemBuilder: (_, __) => const Icon(
                  Icons.star_rounded,
                  color: AppTheme.warningOrange,
                ),
                itemCount: 5,
                itemSize: 14,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(review.comment,
              style: const TextStyle(fontSize: 13, height: 1.5)),
        ],
      ),
    );
  }
}
