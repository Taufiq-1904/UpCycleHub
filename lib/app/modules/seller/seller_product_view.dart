import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'seller_product_controller.dart';
import '../../themes/app_theme.dart';
import '../../utils/app_utils.dart';
import '../../widgets/state_widgets.dart';
import '../../routes/app_routes.dart';

class SellerProductView extends StatelessWidget {
  /// true  → dipakai sebagai tab di SellerMainView (tidak ada back button)
  /// false → dibuka sebagai halaman standalone (ada back button)
  final bool isEmbedded;
  const SellerProductView({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SellerProductController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Produk'),
        // Sembunyikan back button kalau sedang dipakai sebagai tab
        automaticallyImplyLeading: !isEmbedded,
        leading: isEmbedded
            ? null
            : IconButton(
                onPressed: Get.back,
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.SELLER_ADD_PRODUCT),
        backgroundColor: AppTheme.primaryGreen,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Tambah',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const LoadingWidget();
        if (controller.products.isEmpty) {
          return EmptyStateWidget(
            title: 'Belum Ada Produk',
            subtitle: 'Tambahkan produk pertamamu sekarang!',
            icon: Icons.add_box_outlined,
            buttonText: 'Tambah Produk',
            onButtonPressed: () => Get.toNamed(AppRoutes.SELLER_ADD_PRODUCT),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.loadProducts,
          color: AppTheme.primaryGreen,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final product = controller.products[index];
              return Container(
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkCard : AppTheme.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color:
                          isDark ? const Color(0xFF2D4A38) : AppTheme.grey200),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(14)),
                      child: CachedNetworkImage(
                        imageUrl: product.mainImage,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                          width: 90,
                          height: 90,
                          color: AppTheme.softGreen,
                          child: const Icon(Icons.image_not_supported_outlined,
                              color: AppTheme.primaryGreen),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Text(AppUtils.formatCurrency(product.price),
                                style: const TextStyle(
                                    color: AppTheme.primaryGreen,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                _VerifBadge(status: product.verificationStatus),
                                const SizedBox(width: 8),
                                Text('Stok: ${product.stock}',
                                    style: const TextStyle(
                                        fontSize: 11, color: AppTheme.grey400)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () => Get.toNamed(
                              AppRoutes.SELLER_EDIT_PRODUCT,
                              arguments: product),
                          icon: const Icon(Icons.edit_outlined,
                              color: AppTheme.infoBlue, size: 20),
                        ),
                        IconButton(
                          onPressed: () => controller.deleteProduct(product),
                          icon: const Icon(Icons.delete_outline_rounded,
                              color: AppTheme.errorRed, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class _VerifBadge extends StatelessWidget {
  final String status;
  const _VerifBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'approved':
        color = AppTheme.successGreen;
        break;
      case 'rejected':
        color = AppTheme.errorRed;
        break;
      default:
        color = AppTheme.warningOrange;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(AppUtils.verificationLabel(status),
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.w600)),
    );
  }
}
