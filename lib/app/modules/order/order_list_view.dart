import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'order_list_controller.dart';
import '../../themes/app_theme.dart';
import '../../utils/app_utils.dart';
import '../../widgets/state_widgets.dart';
import '../../routes/app_routes.dart';

class OrderListView extends StatelessWidget {
  final bool isEmbedded;
  const OrderListView({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderListController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget body = Obx(() {
      if (controller.isLoading.value) return const LoadingWidget();
      if (controller.orders.isEmpty) {
        return EmptyStateWidget(
          title: 'Belum Ada Pesanan',
          subtitle: 'Yuk mulai belanja produk upcycle!',
          icon: Icons.receipt_long_outlined,
          buttonText: 'Mulai Belanja',
          onButtonPressed: () => Get.offAllNamed(AppRoutes.MAIN),
        );
      }
      return RefreshIndicator(
        onRefresh: controller.loadOrders,
        color: AppTheme.primaryGreen,
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.orders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final order = controller.orders[index];
            return GestureDetector(
              onTap: () =>
                  Get.toNamed(AppRoutes.ORDER_DETAIL, arguments: order.id),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkCard : AppTheme.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? const Color(0xFF2D4A38) : AppTheme.grey200,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '#${order.id}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        _StatusChip(status: order.paymentStatus),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppUtils.formatDateTime(order.createdAt),
                      style: const TextStyle(
                          fontSize: 12, color: AppTheme.grey400),
                    ),
                    const SizedBox(height: 12),
                    ...order.items.take(2).map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '• ${item.productName} (x${item.quantity})',
                            style: const TextStyle(fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
                    if (order.items.length > 2)
                      Text(
                        '+${order.items.length - 2} produk lainnya',
                        style: const TextStyle(
                            fontSize: 12, color: AppTheme.grey400),
                      ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Pengiriman',
                                style: TextStyle(
                                    fontSize: 11, color: AppTheme.grey400)),
                            Text(order.shippingLabel,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 13)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Total',
                                style: TextStyle(
                                    fontSize: 11, color: AppTheme.grey400)),
                            Text(
                              AppUtils.formatCurrency(order.totalAmount),
                              style: const TextStyle(
                                color: AppTheme.primaryGreen,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        leading: isEmbedded
            ? null
            : IconButton(
                onPressed: Get.back,
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
      ),
      body: body,
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case 'paid':
        color = AppTheme.successGreen;
        label = 'Dibayar';
        break;
      case 'confirmed':
        color = AppTheme.infoBlue;
        label = 'Dikonfirmasi';
        break;
      case 'rejected':
        color = AppTheme.errorRed;
        label = 'Ditolak';
        break;
      default:
        color = AppTheme.warningOrange;
        label = 'Menunggu';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style:
            TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
