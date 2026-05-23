import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'order_detail_controller.dart';
import '../../themes/app_theme.dart';
import '../../utils/app_utils.dart';
import '../../widgets/state_widgets.dart';

class OrderDetailView extends StatelessWidget {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderDetailController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
        leading: IconButton(
            onPressed: Get.back,
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const LoadingWidget();
        final order = controller.order.value;
        if (order == null) {
          return const ErrorStateWidget(message: 'Pesanan tidak ditemukan');
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryGreen, AppTheme.lightGreen],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.receipt_long_rounded,
                        color: Colors.white, size: 40),
                    const SizedBox(height: 8),
                    Text(
                      order.statusLabel,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '#${order.id}',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8), fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Order Info
              _SectionCard(
                isDark: isDark,
                title: 'Informasi Pesanan',
                children: [
                  _InfoRow('Tanggal', AppUtils.formatDateTime(order.createdAt)),
                  _InfoRow('Status Bayar', order.statusLabel),
                  _InfoRow('Status Kirim', order.shippingLabel),
                  _InfoRow('Alamat', order.shippingAddress),
                ],
              ),
              const SizedBox(height: 16),

              // Items
              _SectionCard(
                isDark: isDark,
                title: 'Produk Dipesan',
                children: order.items
                    .map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.productName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500)),
                                    Text(
                                        '${item.quantity}x ${AppUtils.formatCurrency(item.price)}',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.grey400)),
                                  ],
                                ),
                              ),
                              Text(AppUtils.formatCurrency(item.subtotal),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),

              // Total
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.softGreen,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Pembayaran',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryGreen)),
                    Text(
                      AppUtils.formatCurrency(order.totalAmount),
                      style: const TextStyle(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool isDark;
  const _SectionCard(
      {required this.title, required this.children, required this.isDark});

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
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const Divider(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(color: AppTheme.grey400, fontSize: 13)),
          ),
          Expanded(
            child: Text(value,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
