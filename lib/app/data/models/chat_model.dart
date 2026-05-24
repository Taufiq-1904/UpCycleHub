import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final String id;
  final String pembeliId;
  final String pembeliName;
  final String? pembeliAvatar;
  final String penjualId;
  final String penjualName;
  final String? penjualAvatar;
  final String productId;
  final String productName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final bool isReadBypembeli;
  final bool isReadBypenjual;

  ChatRoomModel({
    required this.id,
    required this.pembeliId,
    required this.pembeliName,
    this.pembeliAvatar,
    required this.penjualId,
    required this.penjualName,
    this.penjualAvatar,
    required this.productId,
    required this.productName,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.isReadBypembeli,
    required this.isReadBypenjual,
  });

  factory ChatRoomModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatRoomModel(
      id: doc.id,
      pembeliId: data['pembeliId'] ?? '',
      pembeliName: data['pembeliName'] ?? '',
      pembeliAvatar: data['pembeliAvatar'],
      penjualId: data['penjualId'] ?? '',
      penjualName: data['penjualName'] ?? '',
      penjualAvatar: data['penjualAvatar'],
      productId: data['productId'] ?? '',
      productName: data['productName'] ?? '',
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime:
          (data['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isReadBypembeli: data['isReadBypembeli'] ?? true,
      isReadBypenjual: data['isReadBypenjual'] ?? true,
    );
  }

  Map<String, dynamic> toMap() => {
        'pembeliId': pembeliId,
        'pembeliName': pembeliName,
        'pembeliAvatar': pembeliAvatar,
        'penjualId': penjualId,
        'penjualName': penjualName,
        'penjualAvatar': penjualAvatar,
        'productId': productId,
        'productName': productName,
        'lastMessage': lastMessage,
        'lastMessageTime': Timestamp.fromDate(lastMessageTime),
        'isReadBypembeli': isReadBypembeli,
        'isReadBypenjual': isReadBypenjual,
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
