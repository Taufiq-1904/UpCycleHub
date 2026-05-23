import 'package:get/get.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/providers/api_client.dart';

class OrderDetailController extends GetxController {
  final Rxn<OrderModel> order = Rxn<OrderModel>();
  final RxBool isLoading = false.obs;
  late final OrderRepository _repo;

  @override
  void onInit() {
    super.onInit();
    _repo = OrderRepository(ApiClient());
    final id = Get.arguments;
    if (id is String) {
      loadOrder(id);
    } else if (id is OrderModel) order.value = id;
  }

  Future<void> loadOrder(String id) async {
    isLoading.value = true;
    try {
      order.value = await _repo.getOrderById(id);
    } finally {
      isLoading.value = false;
    }
  }
}
