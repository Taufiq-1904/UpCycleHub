import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final String id;
  final String buyerId;
  final String buyerName;
  final String? buyerAvatar;
  final String sellerId;
  final String sellerName;
  final String? sellerAvatar;
  final String productId;
  final String productName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final bool isReadByBuyer;
  final bool isReadBySeller;

  ChatRoomModel({
    required this.id,
    required this.buyerId,
    required this.buyerName,
    this.buyerAvatar,
    required this.sellerId,
    required this.sellerName,
    this.sellerAvatar,
    required this.productId,
    required this.productName,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.isReadByBuyer,
    required this.isReadBySeller,
  });

  factory ChatRoomModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatRoomModel(
      id: doc.id,
      buyerId: data['buyerId'] ?? '',
      buyerName: data['buyerName'] ?? '',
      buyerAvatar: data['buyerAvatar'],
      sellerId: data['sellerId'] ?? '',
      sellerName: data['sellerName'] ?? '',
      sellerAvatar: data['sellerAvatar'],
      productId: data['productId'] ?? '',
      productName: data['productName'] ?? '',
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime:
          (data['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isReadByBuyer: data['isReadByBuyer'] ?? true,
      isReadBySeller: data['isReadBySeller'] ?? true,
    );
  }

  Map<String, dynamic> toMap() => {
        'buyerId': buyerId,
        'buyerName': buyerName,
        'buyerAvatar': buyerAvatar,
        'sellerId': sellerId,
        'sellerName': sellerName,
        'sellerAvatar': sellerAvatar,
        'productId': productId,
        'productName': productName,
        'lastMessage': lastMessage,
        'lastMessageTime': Timestamp.fromDate(lastMessageTime),
        'isReadByBuyer': isReadByBuyer,
        'isReadBySeller': isReadBySeller,
      };
}

class MessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime timestamp;
  final bool isRead;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
    required this.isRead,
  });

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? '',
      text: data['text'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: data['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        'senderId': senderId,
        'senderName': senderName,
        'text': text,
        'timestamp': Timestamp.fromDate(timestamp),
        'isRead': isRead,
      };
}
