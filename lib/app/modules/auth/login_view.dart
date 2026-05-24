import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_controller.dart';
import '../../routes/app_routes.dart';
import '../../themes/app_theme.dart';
import '../../utils/app_utils.dart';
import '../../widgets/app_button.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // Logo
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.recycling_rounded,
                            color: Colors.white, size: 40),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'UpCycleHub',
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: AppTheme.primaryGreen,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Marketplace Upcycling Terpercaya',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // ── Demo info card ────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.softGreen,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.accentGreen),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline_rounded,
                              size: 16, color: AppTheme.primaryGreen),
                          SizedBox(width: 6),
                          Text('Akun Demo (tanpa backend)',
                              style: TextStyle(
                                  color: AppTheme.primaryGreen,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13)),
                        ],
                      ),
                      SizedBox(height: 10),
                      _DemoRow(
                        icon: Icons.shopping_bag_outlined,
                        label: 'Pembeli',
                        email: 'buyer@demo.com',
                        description:
                            'Browsing, cart, checkout, chat dengan seller',
                      ),
                      SizedBox(height: 6),
                      _DemoRow(
                        icon: Icons.storefront_outlined,
                        label: 'Penjual',
                        email: 'seller@demo.com',
                        description:
                            'Dashboard, tambah/edit produk, kelola toko',
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Password keduanya: password123',
                        style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.primaryGreen,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Email field
                Text('Email', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: AppUtils.validateEmail,
                  decoration: const InputDecoration(
                    hintText: 'email@example.com',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 20),

                // Password field
                Text('Password',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Obx(() => TextFormField(
                      controller: controller.passwordController,
                      obscureText: controller.obscurePassword.value,
                      validator: AppUtils.validatePassword,
                      decoration: InputDecoration(
                        hintText: 'Masukkan password',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          onPressed: controller.togglePassword,
                          icon: Icon(controller.obscurePassword.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                        ),
                      ),
                    )),
                const SizedBox(height: 28),

                // Login button
                Obx(() => AppButton(
                      text: 'Masuk',
                      onPressed: controller.login,
                      isLoading: controller.isLoading.value,
                    )),
                const SizedBox(height: 16),

                // Demo shortcut buttons
                Row(
                  children: [
                    Expanded(
                      child: _DemoButton(
                        icon: Icons.shopping_bag_outlined,
                        label: 'Demo Pembeli',
                        color: AppTheme.primaryGreen,
                        onTap: () => controller.loginDemo(role: 'buyer'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DemoButton(
                        icon: Icons.storefront_outlined,
                        label: 'Demo Penjual',
                        color: AppTheme.lightGreen,
                        onTap: () => controller.loginDemo(role: 'seller'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Belum punya akun? ',
                        style: Theme.of(context).textTheme.bodyMedium),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.REGISTER),
                      child: const Text(
                        'Daftar Sekarang',
                        style: TextStyle(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Baris info akun demo
class _DemoRow extends StatelessWidget {
  final IconData icon;
  final String label, email, description;

  const _DemoRow({
    required this.icon,
    required this.label,
    required this.email,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppTheme.darkGreen),
        const SizedBox(width: 6),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 12, color: AppTheme.darkGreen),
              children: [
                TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                TextSpan(
                    text: email,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline)),
                TextSpan(text: ' — $description'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Tombol demo dengan ikon
class _DemoButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _DemoButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
