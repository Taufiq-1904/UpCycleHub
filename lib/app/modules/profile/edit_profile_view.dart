import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';
import '../../themes/app_theme.dart';
import '../../widgets/app_button.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        leading: IconButton(
            onPressed: Get.back,
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Avatar
            Center(
              child: Obx(() => GestureDetector(
                    onTap: controller.pickAvatar,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 56,
                          backgroundColor: AppTheme.softGreen,
                          backgroundImage: controller.newAvatar.value != null
                              ? FileImage(controller.newAvatar.value!)
                                  as ImageProvider
                              : null,
                          child: controller.newAvatar.value == null
                              ? const Icon(Icons.person_rounded,
                                  size: 48, color: AppTheme.primaryGreen)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryGreen,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt_rounded,
                                color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            const SizedBox(height: 32),

            _buildField(context, 'Nama Lengkap', controller.nameController,
                Icons.person_outline_rounded),
            const SizedBox(height: 20),
            _buildField(context, 'Nomor Telepon', controller.phoneController,
                Icons.phone_outlined, TextInputType.phone),
            const SizedBox(height: 20),
            _buildField(context, 'Alamat', controller.addressController,
                Icons.location_on_outlined, TextInputType.multiline, 3),
            const SizedBox(height: 32),

            Obx(() => AppButton(
                  text: 'Simpan Perubahan',
                  onPressed: controller.updateProfile,
                  isLoading: controller.isLoading.value,
                  icon: Icons.save_outlined,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildField(BuildContext context, String label,
      TextEditingController ctrl, IconData icon,
      [TextInputType type = TextInputType.text, int lines = 1]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          keyboardType: type,
          maxLines: lines,
          decoration: InputDecoration(prefixIcon: Icon(icon)),
        ),
      ],
    );
  }
}
