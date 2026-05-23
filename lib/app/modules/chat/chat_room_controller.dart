import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/chat_model.dart';
import '../../data/models/product_model.dart';
import '../../services/auth_service.dart';
import '../../utils/app_utils.dart';

class ChatRoomController extends GetxController {
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxBool isSending = false.obs;
  late String chatRoomId;
  late ChatRoomModel? chatRoom;
  late ProductModel? product;

  late final AuthService _authService;
  final _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _authService = Get.find<AuthService>();

    final args = Get.arguments;
    if (args is ChatRoomModel) {
      chatRoom = args;
      chatRoomId = args.id;
      product = null;
    } else if (args is Map<String, dynamic> && args['product'] != null) {
      product = args['product'] as ProductModel;
      chatRoom = null;
      chatRoomId = AppUtils.generateChatRoomId(
          _authService.userId, product!.sellerId, product!.id);
      _ensureChatRoomExists();
    }

    _listenMessages();
    _markAsRead();
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> _ensureChatRoomExists() async {
    if (product == null) return;
    final doc = await _firestore.collection('chatRooms').doc(chatRoomId).get();
    if (!doc.exists) {
      final user = _authService.currentUser.value!;
      await _firestore.collection('chatRooms').doc(chatRoomId).set({
        'buyerId': user.id,
        'buyerName': user.name,
        'buyerAvatar': user.avatar,
        'sellerId': product!.sellerId,
        'sellerName': product!.sellerName,
        'sellerAvatar': product!.sellerAvatar,
        'productId': product!.id,
        'productName': product!.name,
        'lastMessage': '',
        'lastMessageTime': Timestamp.now(),
        'isReadByBuyer': true,
        'isReadBySeller': true,
      });
    }
  }

  void _listenMessages() {
    _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) {
      messages.value =
          snapshot.docs.map((d) => MessageModel.fromFirestore(d)).toList();
      _scrollToBottom();
    });
  }

  void _markAsRead() {
    final isSeller = _authService.isSeller;
    _firestore.collection('chatRooms').doc(chatRoomId).update({
      isSeller ? 'isReadBySeller' : 'isReadByBuyer': true,
    }).catchError((_) {});
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;
    messageController.clear();
    isSending.value = true;

    final user = _authService.currentUser.value!;
    final isSeller = _authService.isSeller;

    try {
      final msg = {
        'senderId': user.id,
        'senderName': user.name,
        'text': text,
        'timestamp': Timestamp.now(),
        'isRead': false,
      };
      await _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .add(msg);

      await _firestore.collection('chatRooms').doc(chatRoomId).update({
        'lastMessage': text,
        'lastMessageTime': Timestamp.now(),
        isSeller ? 'isReadByBuyer' : 'isReadBySeller': false,
      });
    } finally {
      isSending.value = false;
    }
  }

  bool isMe(String senderId) => senderId == _authService.userId;

  String get otherName {
    if (chatRoom != null) {
      return _authService.isSeller ? chatRoom!.buyerName : chatRoom!.sellerName;
    }
    return product?.sellerName ?? '';
  }
}
