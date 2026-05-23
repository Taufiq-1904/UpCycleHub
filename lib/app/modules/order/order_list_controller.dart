import 'package:get/get.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/providers/api_client.dart';

class OrderListController extends GetxController {
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;

  late final OrderRepository _repo;

  @override
  void onInit() {
    super.onInit();
    _repo = OrderRepository(ApiClient());
    loadOrders();
  }

  Future<void> loadOrders() async {
    isLoading.value = true;
    try {
      orders.value = await _repo.getOrders();
    } finally {
      isLoading.value = false;
    }
  }
}
