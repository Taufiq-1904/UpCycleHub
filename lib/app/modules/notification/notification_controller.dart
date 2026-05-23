import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../data/models/notification_model.dart';
import '../../services/auth_service.dart';

class NotificationController extends GetxController {
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;

  late final AuthService _authService;
  final _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _authService = Get.find<AuthService>();
    _listenNotifications();
  }

  void _listenNotifications() {
    _firestore
        .collection('notifications')
        .where('userId', isEqualTo: _authService.userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snap) {
      notifications.value =
          snap.docs.map((d) => NotificationModel.fromFirestore(d)).toList();
    });
  }

  Future<void> markAsRead(String id) async {
    await _firestore
        .collection('notifications')
        .doc(id)
        .update({'isRead': true});
  }

  Future<void> markAllRead() async {
    final batch = _firestore.batch();
    for (final n in notifications.where((n) => !n.isRead)) {
      batch.update(
          _firestore.collection('notifications').doc(n.id), {'isRead': true});
    }
    await batch.commit();
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;
}
