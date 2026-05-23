import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'checkout_controller.dart';
import '../cart/cart_controller.dart';
import '../../themes/app_theme.dart';
import '../../utils/app_utils.dart';
import '../../widgets/app_button.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CheckoutController>();
    final cartController = Get.find<CartController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Items
              Text('Ringkasan Pesanan',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkCard : AppTheme.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color:
                          isDark ? const Color(0xFF2D4A38) : AppTheme.grey200),
                ),
                child: Column(
                  children: [
                    ...cartController.items.map((item) => Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.productName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13)),
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
                        )),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                          Text(
                            AppUtils.formatCurrency(cartController.totalPrice),
                            style: const TextStyle(
                              color: AppTheme.primaryGreen,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Shipping Address
              Text('Alamat Pengiriman',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.addressController,
                maxLines: 3,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Alamat wajib diisi';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Masukkan alamat lengkap pengiriman...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 48),
                    child: Icon(Icons.location_on_outlined),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Payment Method
              Text('Metode Pembayaran',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkCard : AppTheme.softGreen,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.accentGreen),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.account_balance_outlined,
                        color: AppTheme.primaryGreen),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Transfer Bank',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryGreen)),
                        Text('BCA: 1234567890 - UpCycleHub',
                            style: TextStyle(
                                fontSize: 12, color: AppTheme.primaryGreen)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Payment Proof
              Text('Bukti Pembayaran',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Obx(() => GestureDetector(
                    onTap: controller.pickPaymentProof,
                    child: Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.darkCard : AppTheme.grey100,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: controller.paymentProof.value != null
                              ? AppTheme.primaryGreen
                              : AppTheme.grey200,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: controller.paymentProof.value != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.file(
                                controller.paymentProof.value!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.upload_file_outlined,
                                    size: 40, color: AppTheme.grey400),
                                SizedBox(height: 8),
                                Text('Tap untuk upload bukti pembayaran',
                                    style: TextStyle(
                                        color: AppTheme.grey400, fontSize: 13)),
                              ],
                            ),
                    ),
                  )),
              const SizedBox(height: 32),

              Obx(() => AppButton(
                    text: 'Buat Pesanan',
                    onPressed: controller.checkout,
                    isLoading: controller.isLoading.value,
                    icon: Icons.check_circle_outline_rounded,
                  )),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
