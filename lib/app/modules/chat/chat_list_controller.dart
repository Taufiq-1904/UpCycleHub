import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../data/models/chat_model.dart';
import '../../services/auth_service.dart';

class ChatListController extends GetxController {
  final RxList<ChatRoomModel> chatRooms = <ChatRoomModel>[].obs;
  final RxBool isLoading = false.obs;

  late final AuthService _authService;
  final _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _authService = Get.find<AuthService>();
    _listenChatRooms();
  }

  void _listenChatRooms() {
    final userId = _authService.userId;
    final field = _authService.isSeller ? 'sellerId' : 'buyerId';

    _firestore
        .collection('chatRooms')
        .where(field, isEqualTo: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .listen((snapshot) {
      chatRooms.value =
          snapshot.docs.map((doc) => ChatRoomModel.fromFirestore(doc)).toList();
    });
  }

  bool hasUnread(ChatRoomModel room) {
    return _authService.isSeller ? !room.isReadBySeller : !room.isReadByBuyer;
  }
}
