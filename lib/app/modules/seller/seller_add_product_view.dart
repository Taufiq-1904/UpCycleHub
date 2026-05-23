import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'seller_product_controller.dart';
import '../../themes/app_theme.dart';
import '../../utils/app_utils.dart';
import '../../widgets/app_button.dart';

class SellerAddProductView extends StatelessWidget {
  final bool isEdit;
  const SellerAddProductView({super.key, this.isEdit = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SellerProductController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Produk' : 'Tambah Produk'),
        leading: IconButton(
            onPressed: Get.back,
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Images
              Text('Foto Produk',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Obx(() => SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        // Add button
                        GestureDetector(
                          onTap: controller.pickImages,
                          child: Container(
                            width: 90,
                            height: 90,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color:
                                  isDark ? AppTheme.darkCard : AppTheme.grey100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.grey200),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate_outlined,
                                    color: AppTheme.primaryGreen, size: 28),
                                Text('Tambah',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: AppTheme.primaryGreen)),
                              ],
                            ),
                          ),
                        ),
                        // Selected images
                        ...controller.selectedImages
                            .asMap()
                            .entries
                            .map((entry) => Stack(
                                  children: [
                                    Container(
                                      width: 90,
                                      height: 90,
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          image: FileImage(entry.value),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 2,
                                      right: 12,
                                      child: GestureDetector(
                                        onTap: () =>
                                            controller.removeImage(entry.key),
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: const BoxDecoration(
                                              color: AppTheme.errorRed,
                                              shape: BoxShape.circle),
                                          child: const Icon(Icons.close_rounded,
                                              color: Colors.white, size: 14),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                      ],
                    ),
                  )),
              const SizedBox(height: 24),

              // Name
              _buildLabel(context, 'Nama Produk'),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.nameController,
                validator: (v) => AppUtils.validateRequired(v, 'Nama produk'),
                decoration:
                    const InputDecoration(hintText: 'Nama produk upcycle-mu'),
              ),
              const SizedBox(height: 20),

              // Category
              _buildLabel(context, 'Kategori'),
              const SizedBox(height: 8),
              Obx(() => DropdownButtonFormField<String>(
                    initialValue: controller.selectedCategory.value.isNotEmpty
                        ? controller.selectedCategory.value
                        : null,
                    hint: const Text('Pilih kategori'),
                    onChanged: (v) =>
                        controller.selectedCategory.value = v ?? '',
                    validator: (v) => v == null ? 'Pilih kategori' : null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: isDark ? AppTheme.darkCard : AppTheme.grey100,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppTheme.grey200)),
                    ),
                    items: controller.categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                  )),
              const SizedBox(height: 20),

              // Price + Stock
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel(context, 'Harga (Rp)'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: controller.priceController,
                          keyboardType: TextInputType.number,
                          validator: AppUtils.validatePrice,
                          decoration: const InputDecoration(hintText: '0'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel(context, 'Stok'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: controller.stockController,
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              AppUtils.validateRequired(v, 'Stok'),
                          decoration: const InputDecoration(hintText: '0'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Description
              _buildLabel(context, 'Deskripsi'),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.descriptionController,
                maxLines: 5,
                validator: (v) => AppUtils.validateRequired(v, 'Deskripsi'),
                decoration: const InputDecoration(
                    hintText: 'Ceritakan produk upcycle-mu...'),
              ),
              const SizedBox(height: 32),

              Obx(() => AppButton(
                    text: isEdit ? 'Simpan Perubahan' : 'Tambah Produk',
                    onPressed: controller.saveProduct,
                    isLoading: controller.isSaving.value,
                    icon: isEdit
                        ? Icons.save_outlined
                        : Icons.add_circle_outline_rounded,
                  )),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Text(text, style: Theme.of(context).textTheme.titleMedium);
  }
}
