import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'product_list_controller.dart';
import '../../themes/app_theme.dart';
import '../../widgets/product_card.dart';
import '../../widgets/state_widgets.dart';

class ProductListView extends StatelessWidget {
  final bool isEmbedded;
  const ProductListView({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductListController>();

    Widget body = Column(
      children: [
        // Search + Filter
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: TextField(
            controller: controller.searchController,
            onChanged: (v) {
              Future.delayed(const Duration(milliseconds: 500), () {
                if (controller.searchController.text == v) {
                  controller.onSearch(v);
                }
              });
            },
            decoration: const InputDecoration(
              hintText: 'Cari produk upcycle...',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
        ),
        // Category Filter
        Obx(() => SizedBox(
              height: 52,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                itemCount: controller.categories.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isAll = index == 0;
                  final cat = isAll ? '' : controller.categories[index - 1];
                  final isSelected = isAll
                      ? controller.selectedCategory.value.isEmpty
                      : controller.selectedCategory.value == cat;
                  return GestureDetector(
                    onTap: () => isAll
                        ? controller.selectCategory('')
                        : controller.selectCategory(cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryGreen
                            : AppTheme.grey100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isAll ? 'Semua' : cat,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.grey600,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
            )),
        // Products Grid
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: 6,
                itemBuilder: (_, __) => const ProductCardSkeleton(),
              );
            }
            if (controller.products.isEmpty) {
              return EmptyStateWidget(
                title: 'Produk Tidak Ditemukan',
                subtitle: 'Coba kata kunci atau kategori lain',
                icon: Icons.search_off_rounded,
                buttonText: 'Reset Filter',
                onButtonPressed: () {
                  controller.searchController.clear();
                  controller.selectedCategory.value = '';
                  controller.loadProducts(refresh: true);
                },
              );
            }
            return RefreshIndicator(
              onRefresh: controller.refresh,
              color: AppTheme.primaryGreen,
              child: GridView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: controller.products.length +
                    (controller.hasMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= controller.products.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation(AppTheme.primaryGreen),
                        ),
                      ),
                    );
                  }
                  return ProductCard(product: controller.products[index]);
                },
              ),
            );
          }),
        ),
      ],
    );

    if (isEmbedded) {
      return Scaffold(
        appBar: AppBar(title: const Text('Semua Produk')),
        body: body,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Produk'),
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: body,
    );
  }
}
