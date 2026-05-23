import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'chat_room_controller.dart';
import '../../themes/app_theme.dart';

class ChatRoomView extends StatelessWidget {
  const ChatRoomView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatRoomController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: Get.back,
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.softGreen,
              child: Text(
                controller.otherName.isNotEmpty
                    ? controller.otherName[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                    color: AppTheme.primaryGreen, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(controller.otherName,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
                const Text('Online',
                    style:
                        TextStyle(fontSize: 11, color: AppTheme.successGreen)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: Obx(() => ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final msg = controller.messages[index];
                    final isMe = controller.isMe(msg.senderId);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: isMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (!isMe) ...[
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: AppTheme.softGreen,
                              child: Text(msg.senderName[0].toUpperCase(),
                                  style: const TextStyle(
                                      color: AppTheme.primaryGreen,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700)),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Column(
                            crossAxisAlignment: isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.65),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? AppTheme.primaryGreen
                                      : (isDark
                                          ? AppTheme.darkCard
                                          : AppTheme.grey100),
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(16),
                                    topRight: const Radius.circular(16),
                                    bottomLeft: Radius.circular(isMe ? 16 : 4),
                                    bottomRight: Radius.circular(isMe ? 4 : 16),
                                  ),
                                ),
                                child: Text(
                                  msg.text,
                                  style: TextStyle(
                                    color: isMe ? Colors.white : null,
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                timeago.format(msg.timestamp, locale: 'id'),
                                style: const TextStyle(
                                    fontSize: 10, color: AppTheme.grey400),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                )),
          ),

          // Input
          Container(
            padding: EdgeInsets.fromLTRB(
                16, 8, 16, MediaQuery.of(context).viewInsets.bottom + 16),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkSurface : AppTheme.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -2)),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.messageController,
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Tulis pesan...',
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      filled: true,
                      fillColor: isDark ? AppTheme.darkCard : AppTheme.grey100,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none),
                    ),
                    onSubmitted: (_) => controller.sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                Obx(() => GestureDetector(
                      onTap: controller.sendMessage,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 46,
                        height: 46,
                        decoration: const BoxDecoration(
                            color: AppTheme.primaryGreen,
                            shape: BoxShape.circle),
                        child: controller.isSending.value
                            ? const Center(
                                child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white)))
                            : const Icon(Icons.send_rounded,
                                color: Colors.white, size: 20),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
