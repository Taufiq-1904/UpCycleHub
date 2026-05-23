import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'register_controller.dart';
import '../../themes/app_theme.dart';
import '../../utils/app_utils.dart';
import '../../widgets/app_button.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegisterController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Akun'),
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daftar Sekarang',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Isi data diri kamu untuk membuat akun',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),

                // Role Selector
                Text(
                  'Daftar Sebagai',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Obx(() => Row(
                      children: [
                        _RoleCard(
                          label: 'Pembeli',
                          icon: Icons.shopping_bag_outlined,
                          isSelected: controller.selectedRole.value == 'buyer',
                          onTap: () => controller.setRole('buyer'),
                        ),
                        const SizedBox(width: 12),
                        _RoleCard(
                          label: 'Penjual',
                          icon: Icons.storefront_outlined,
                          isSelected: controller.selectedRole.value == 'seller',
                          onTap: () => controller.setRole('seller'),
                        ),
                      ],
                    )),
                const SizedBox(height: 24),

                // Name
                Text('Nama Lengkap',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller.nameController,
                  validator: (v) => AppUtils.validateRequired(v, 'Nama'),
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'Nama lengkap kamu',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                ),
                const SizedBox(height: 20),

                // Email
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

                // Password
                Text('Password',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Obx(() => TextFormField(
                      controller: controller.passwordController,
                      obscureText: controller.obscurePassword.value,
                      validator: AppUtils.validatePassword,
                      decoration: InputDecoration(
                        hintText: 'Minimal 6 karakter',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          onPressed: controller.obscurePassword.toggle,
                          icon: Icon(controller.obscurePassword.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                        ),
                      ),
                    )),
                const SizedBox(height: 20),

                // Confirm Password
                Text('Konfirmasi Password',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Obx(() => TextFormField(
                      controller: controller.confirmPasswordController,
                      obscureText: controller.obscureConfirm.value,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Konfirmasi password wajib diisi';
                        }
                        if (v != controller.passwordController.text) {
                          return 'Password tidak cocok';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Ulangi password',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          onPressed: controller.obscureConfirm.toggle,
                          icon: Icon(controller.obscureConfirm.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                        ),
                      ),
                    )),
                const SizedBox(height: 32),

                Obx(() => AppButton(
                      text: 'Daftar Sekarang',
                      onPressed: controller.register,
                      isLoading: controller.isLoading.value,
                    )),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: Get.back,
                      child: const Text(
                        'Masuk',
                        style: TextStyle(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.softGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppTheme.primaryGreen : AppTheme.grey200,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? AppTheme.primaryGreen : AppTheme.grey400,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppTheme.primaryGreen : AppTheme.grey600,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
