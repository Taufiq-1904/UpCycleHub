import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'notification_controller.dart';
import '../../themes/app_theme.dart';
import '../../widgets/state_widgets.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        leading: IconButton(
            onPressed: Get.back,
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        actions: [
          Obx(() => controller.unreadCount > 0
              ? TextButton(
                  onPressed: controller.markAllRead,
                  child: const Text('Tandai Semua Dibaca'),
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return const EmptyStateWidget(
            title: 'Tidak Ada Notifikasi',
            subtitle: 'Semua notifikasi kamu akan muncul di sini',
            icon: Icons.notifications_none_rounded,
          );
        }
        return ListView.separated(
          itemCount: controller.notifications.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final notif = controller.notifications[index];
            return InkWell(
              onTap: () => controller.markAsRead(notif.id),
              child: Container(
                color: notif.isRead
                    ? null
                    : (isDark
                        ? AppTheme.darkCard
                        : AppTheme.softGreen.withOpacity(0.4)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.darkSurface : AppTheme.grey100,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                          child: Text(notif.icon,
                              style: const TextStyle(fontSize: 22))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(notif.title,
                                    style: TextStyle(
                                      fontWeight: notif.isRead
                                          ? FontWeight.w500
                                          : FontWeight.w700,
                                    )),
                              ),
                              if (!notif.isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                      color: AppTheme.primaryGreen,
                                      shape: BoxShape.circle),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(notif.body,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? AppTheme.grey400
                                    : AppTheme.grey600,
                              )),
                          const SizedBox(height: 4),
                          Text(
                            timeago.format(notif.createdAt, locale: 'id'),
                            style: const TextStyle(
                                fontSize: 11, color: AppTheme.grey400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
