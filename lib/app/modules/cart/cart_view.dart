import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cart_controller.dart';
import '../../themes/app_theme.dart';
import '../../utils/app_utils.dart';
import '../../widgets/app_button.dart';
import '../../widgets/state_widgets.dart';
import '../../routes/app_routes.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('Keranjang (${controller.itemCount})')),
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        actions: [
          Obx(() => controller.items.isNotEmpty
              ? TextButton(
                  onPressed: () => Get.dialog(AlertDialog(
                    title: const Text('Kosongkan Keranjang'),
                    content: const Text('Yakin ingin menghapus semua item?'),
                    actions: [
                      TextButton(
                          onPressed: Get.back, child: const Text('Batal')),
                      TextButton(
                        onPressed: () {
                          controller.clear();
                          Get.back();
                        },
                        child: const Text('Hapus',
                            style: TextStyle(color: AppTheme.errorRed)),
                      ),
                    ],
                  )),
                  child: const Text('Kosongkan',
                      style: TextStyle(color: AppTheme.errorRed)),
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: Obx(() {
        if (controller.items.isEmpty) {
          return EmptyStateWidget(
            title: 'Keranjang Kosong',
            subtitle: 'Tambahkan produk ke keranjangmu terlebih dahulu',
            icon: Icons.shopping_cart_outlined,
            buttonText: 'Belanja Sekarang',
            onButtonPressed: () => Get.offAllNamed(AppRoutes.MAIN),
          );
        }
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = controller.items[index];
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.darkCard : AppTheme.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: isDark
                              ? const Color(0xFF2D4A38)
                              : AppTheme.grey200),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: item.productImage,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Container(
                              width: 80,
                              height: 80,
                              color: AppTheme.softGreen,
                              child: const Icon(
                                  Icons.image_not_supported_outlined,
                                  color: AppTheme.primaryGreen),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 13),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.sellerName,
                                style: const TextStyle(
                                    fontSize: 11, color: AppTheme.grey400),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                AppUtils.formatCurrency(item.price),
                                style: const TextStyle(
                                  color: AppTheme.primaryGreen,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () =>
                                  controller.removeItem(item.productId),
                              icon: const Icon(Icons.delete_outline_rounded,
                                  color: AppTheme.errorRed, size: 20),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    isDark ? AppTheme.darkBg : AppTheme.grey100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () => controller.updateQuantity(
                                        item.productId, item.quantity - 1),
                                    icon: const Icon(Icons.remove_rounded,
                                        size: 16),
                                    padding: const EdgeInsets.all(4),
                                    constraints: const BoxConstraints(
                                        minWidth: 32, minHeight: 32),
                                  ),
                                  Text(
                                    '${item.quantity}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13),
                                  ),
                                  IconButton(
                                    onPressed: item.quantity < item.maxStock
                                        ? () => controller.updateQuantity(
                                            item.productId, item.quantity + 1)
                                        : null,
                                    icon:
                                        const Icon(Icons.add_rounded, size: 16),
                                    padding: const EdgeInsets.all(4),
                                    constraints: const BoxConstraints(
                                        minWidth: 32, minHeight: 32),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Summary
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total (${controller.itemCount} item)',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Obx(() => Text(
                            AppUtils.formatCurrency(controller.totalPrice),
                            style: const TextStyle(
                              color: AppTheme.primaryGreen,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    text: 'Lanjut Checkout',
                    onPressed: () => Get.toNamed(AppRoutes.CHECKOUT),
                    icon: Icons.arrow_forward_rounded,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
