import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'chat_list_controller.dart';
import '../../themes/app_theme.dart';
import '../../routes/app_routes.dart';
import '../../widgets/state_widgets.dart';
import '../../services/auth_service.dart';

class ChatListView extends StatelessWidget {
  final bool isEmbedded;
  const ChatListView({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatListController>();
    final authService = Get.find<AuthService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Obx(() {
        if (controller.chatRooms.isEmpty) {
          return const EmptyStateWidget(
            title: 'Belum Ada Chat',
            subtitle: 'Mulai chat dengan penjual dari halaman produk',
            icon: Icons.chat_bubble_outline_rounded,
          );
        }
        return ListView.separated(
          itemCount: controller.chatRooms.length,
          separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
          itemBuilder: (context, index) {
            final room = controller.chatRooms[index];
            final ispenjual = authService.ispenjual;
            final otherName = ispenjual ? room.pembeliName : room.penjualName;
            final hasUnread = controller.hasUnread(room);

            return ListTile(
              onTap: () => Get.toNamed(AppRoutes.CHAT_ROOM, arguments: room),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                radius: 26,
                backgroundColor: AppTheme.softGreen,
                child: Text(
                  otherName.isNotEmpty ? otherName[0].toUpperCase() : '?',
                  style: const TextStyle(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.w700,
                      fontSize: 18),
                ),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(otherName,
                        style: TextStyle(
                            fontWeight:
                                hasUnread ? FontWeight.w700 : FontWeight.w500)),
                  ),
                  Text(
                    timeago.format(room.lastMessageTime, locale: 'id'),
                    style: TextStyle(
                      fontSize: 11,
                      color:
                          hasUnread ? AppTheme.primaryGreen : AppTheme.grey400,
                      fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
              subtitle: Row(
                children: [
                  Expanded(
                    child: Text(
                      room.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: hasUnread ? null : AppTheme.grey400,
                        fontWeight:
                            hasUnread ? FontWeight.w500 : FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  if (hasUnread)
                    Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.only(left: 8),
                      decoration: const BoxDecoration(
                          color: AppTheme.primaryGreen, shape: BoxShape.circle),
                    ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
