import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';
import '../../themes/app_theme.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/storage_service.dart';

class ProfileView extends StatelessWidget {
  final bool isEmbedded;
  const ProfileView({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final authService = Get.find<AuthService>();
    final storageService = Get.find<StorageService>();

    return Obx(() {
      if (!authService.isLoggedIn.value) {
        return Scaffold(
          appBar: AppBar(title: const Text('Profil Saya')),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person_off_outlined,
                      size: 64, color: AppTheme.grey400),
                  const SizedBox(height: 16),
                  Text('Kamu belum login',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  const Text(
                    'Login untuk melihat profil dan riwayat pesananmu.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.grey400),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Get.offAllNamed(AppRoutes.LOGIN),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                    ),
                    child: const Text('Login Sekarang'),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      final user = authService.currentUser.value;
      final isDark = Theme.of(context).brightness == Brightness.dark;

      return Scaffold(
        appBar: AppBar(title: const Text('Profil Saya')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                color: isDark ? AppTheme.darkSurface : AppTheme.white,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: AppTheme.softGreen,
                          backgroundImage:
                              (user?.avatar != null && user!.avatar!.isNotEmpty)
                                  ? CachedNetworkImageProvider(user.avatar!)
                                  : null,
                          child: (user?.avatar == null || user!.avatar!.isEmpty)
                              ? Text(
                                  (user?.name.isNotEmpty == true
                                          ? user!.name[0]
                                          : 'U')
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    color: AppTheme.primaryGreen,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.EDIT_PROFILE),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryGreen,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit_rounded,
                                  color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(user?.name ?? '',
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 4),
                    Text(user?.email ?? '',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.softGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        user?.role == 'seller' ? '🏪 Penjual' : '🛍️ Pembeli',
                        style: const TextStyle(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              _MenuSection(
                isDark: isDark,
                title: 'Akun',
                items: [
                  _MenuItem(
                    icon: Icons.person_outline_rounded,
                    label: 'Edit Profil',
                    onTap: () => Get.toNamed(AppRoutes.EDIT_PROFILE),
                  ),
                  _MenuItem(
                    icon: Icons.receipt_long_outlined,
                    label: 'Riwayat Pesanan',
                    onTap: () => Get.toNamed(AppRoutes.ORDER_LIST),
                  ),
                  _MenuItem(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Chat',
                    onTap: () => Get.toNamed(AppRoutes.CHAT_LIST),
                  ),
                  _MenuItem(
                    icon: Icons.notifications_outlined,
                    label: 'Notifikasi',
                    onTap: () => Get.toNamed(AppRoutes.NOTIFICATION),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (authService.isSeller) ...[
                _MenuSection(
                  isDark: isDark,
                  title: 'Seller',
                  items: [
                    _MenuItem(
                      icon: Icons.dashboard_outlined,
                      label: 'Dashboard Penjual',
                      onTap: () => Get.toNamed(AppRoutes.SELLER_DASHBOARD),
                    ),
                    _MenuItem(
                      icon: Icons.inventory_2_outlined,
                      label: 'Kelola Produk',
                      onTap: () =>
                          Get.toNamed(AppRoutes.SELLER_PRODUCT_MANAGEMENT),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],

              // FIX: Dark mode toggle — JANGAN pakai Obx untuk Switch,
              // gunakan StatefulBuilder agar tidak ada Obx kosong
              _MenuSection(
                isDark: isDark,
                title: 'Preferensi',
                items: [
                  _MenuItem(
                    icon: isDark
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    label: isDark ? 'Mode Terang' : 'Mode Gelap',
                    onTap: controller.toggleDarkMode,
                    // FIX: trailing tanpa Obx, pakai value langsung
                    // Switch tidak perlu reaktif karena tema sudah rebuild
                    // seluruh tree saat ThemeMode berubah
                    trailing: Switch(
                      value: storageService.isDarkMode,
                      onChanged: (_) => controller.toggleDarkMode(),
                      activeThumbColor: AppTheme.primaryGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Logout
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListTile(
                  onTap: () => Get.dialog(AlertDialog(
                    title: const Text('Keluar'),
                    content: const Text('Yakin ingin keluar dari akun?'),
                    actions: [
                      TextButton(
                          onPressed: Get.back, child: const Text('Batal')),
                      TextButton(
                        onPressed: controller.logout,
                        child: const Text('Keluar',
                            style: TextStyle(color: AppTheme.errorRed)),
                      ),
                    ],
                  )),
                  leading: const Icon(Icons.logout_rounded,
                      color: AppTheme.errorRed),
                  title: const Text('Keluar',
                      style: TextStyle(
                          color: AppTheme.errorRed,
                          fontWeight: FontWeight.w500)),
                  tileColor: isDark ? AppTheme.darkCard : AppTheme.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      );
    });
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;
  final bool isDark;

  const _MenuSection(
      {required this.title, required this.items, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 4),
            child: Text(title,
                style: const TextStyle(
                    color: AppTheme.grey400,
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
          ),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkCard : AppTheme.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: isDark ? const Color(0xFF2D4A38) : AppTheme.grey200),
            ),
            child: Column(
              children: items.asMap().entries.map((entry) {
                final isLast = entry.key == items.length - 1;
                return Column(
                  children: [
                    entry.value,
                    if (!isLast) const Divider(height: 1, indent: 56),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppTheme.primaryGreen),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      // FIX: Bungkus trailing dengan SizedBox agar tidak memakan
      // seluruh lebar tile (penyebab "Trailing widget consumes entire width")
      trailing: trailing != null
          ? SizedBox(width: 56, child: trailing)
          : const Icon(Icons.chevron_right_rounded, color: AppTheme.grey400),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    );
  }
}
