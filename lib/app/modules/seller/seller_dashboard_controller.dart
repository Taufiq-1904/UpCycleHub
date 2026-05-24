import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/providers/api_client.dart';

class penjualDashboardController extends GetxController {
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt totalProducts = 0.obs;
  final RxInt approvedProducts = 0.obs;
  final RxInt pendingProducts = 0.obs;
  final RxDouble totalRevenue = 0.0.obs;
  late final ProductRepository _repo;

  @override
  void onInit() {
    super.onInit();
    _repo = ProductRepository(ApiClient());
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    isLoading.value = true;
    try {
      products.value = await _repo.getpenjualProducts();
      totalProducts.value = products.length;
      approvedProducts.value =
          products.where((p) => p.verificationStatus == 'approved').length;
      pendingProducts.value =
          products.where((p) => p.verificationStatus == 'pending').length;
      totalRevenue.value =
          products.fold(0, (sum, p) => sum + (p.price * p.soldCount));
    } finally {
      isLoading.value = false;
    }
  }
}
