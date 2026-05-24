import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'seller_product_controller.dart';
import '../../data/models/kategori_model.dart';
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
              // ── Foto Produk ───────────────────────────────────────────
              _label(context, 'Foto Produk'),
              const SizedBox(height: 4),
              Text(
                'Foto diupload ke Cloudinary Storage, URL disimpan di backend',
                style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.grey400,
                    fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 10),
              Obx(() => SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        // Tombol tambah foto
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
                        // Preview foto LAMA dari Firebase (mode edit)
                        ...controller.existingImageUrls
                            .asMap()
                            .entries
                            .map((entry) => Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: 90,
                                      height: 90,
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          image: NetworkImage(entry.value),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: -6,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () => controller
                                            .removeExistingImage(entry.key),
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: const BoxDecoration(
                                            color: AppTheme.errorRed,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.close_rounded,
                                              color: Colors.white, size: 13),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                        // Preview foto BARU yang dipilih dari galeri (File lokal)
                        ...controller.selectedImages
                            .asMap()
                            .entries
                            .map((entry) => Stack(
                                  clipBehavior: Clip.none,
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
                                      top: -6,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () =>
                                            controller.removeImage(entry.key),
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: const BoxDecoration(
                                            color: AppTheme.errorRed,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.close_rounded,
                                              color: Colors.white, size: 13),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                      ],
                    ),
                  )),
              const SizedBox(height: 24),

              // ── Nama Produk ───────────────────────────────────────────
              _label(context, 'Nama Produk'),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.nameController,
                validator: (v) => AppUtils.validateRequired(v, 'Nama produk'),
                decoration:
                    const InputDecoration(hintText: 'Nama produk upcycle-mu'),
              ),
              const SizedBox(height: 20),

              // ── Kategori ─────────────────────────────────────────────
              _label(context, 'Kategori'),
              const SizedBox(height: 8),
              Obx(() {
                if (controller.categories.isEmpty) {
                  return Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.darkCard : AppTheme.grey100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.grey200),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: AppTheme.primaryGreen),
                          ),
                          SizedBox(width: 10),
                          Text('Memuat kategori...',
                              style: TextStyle(
                                  color: AppTheme.grey400, fontSize: 13)),
                        ],
                      ),
                    ),
                  );
                }

                return DropdownButtonFormField<KategoriModel>(
                  value: controller.selectedCategory.value,
                  hint: const Text('Pilih kategori'),
                  isExpanded: true,
                  onChanged: (KategoriModel? picked) =>
                      controller.selectedCategory.value = picked,
                  validator: (v) => v == null ? 'Pilih kategori produk' : null,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isDark ? AppTheme.darkCard : AppTheme.grey100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppTheme.grey200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: AppTheme.primaryGreen, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: AppTheme.errorRed, width: 1.5),
                    ),
                  ),
                  items: controller.categories
                      .map((k) => DropdownMenuItem<KategoriModel>(
                            value: k,
                            child: Text(k.nama),
                          ))
                      .toList(),
                );
              }),
              const SizedBox(height: 20),

              // ── Harga + Stok ──────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label(context, 'Harga (Rp)'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: controller.priceController,
                          keyboardType: TextInputType.number,
                          validator: AppUtils.validatePrice,
                          decoration: const InputDecoration(hintText: '50000'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label(context, 'Stok'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: controller.stockController,
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              AppUtils.validateRequired(v, 'Stok'),
                          decoration: const InputDecoration(hintText: '1'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Deskripsi ─────────────────────────────────────────────
              _label(context, 'Deskripsi'),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.descriptionController,
                maxLines: 5,
                validator: (v) => AppUtils.validateRequired(v, 'Deskripsi'),
                decoration: const InputDecoration(
                    hintText: 'Ceritakan produk upcycle-mu...'),
              ),
              const SizedBox(height: 32),

              // ── Tombol Simpan / Progress Upload ───────────────────────
              Obx(() {
                if (controller.isUploadingImages.value) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.softGreen,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.accentGreen),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.5, color: AppTheme.primaryGreen),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Mengupload foto ke Cloudinary...',
                          style: TextStyle(
                            color: AppTheme.primaryGreen,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return AppButton(
                  text: isEdit ? 'Simpan Perubahan' : 'Tambah Produk',
                  onPressed: controller.saveProduct,
                  isLoading: controller.isSaving.value,
                  icon: isEdit
                      ? Icons.save_outlined
                      : Icons.add_circle_outline_rounded,
                );
              }),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(BuildContext context, String text) =>
      Text(text, style: Theme.of(context).textTheme.titleMedium);
}
