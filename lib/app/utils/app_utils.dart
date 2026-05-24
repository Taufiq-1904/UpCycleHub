import 'package:intl/intl.dart';

class AppUtils {
  // Currency formatter
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // Date formatter
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy', 'id_ID').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  // Validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Format email tidak valid';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
    if (value.length < 6) return 'Password minimal 6 karakter';
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) return 'Harga tidak boleh kosong';
    final price =
        double.tryParse(value.replaceAll('.', '').replaceAll(',', ''));
    if (price == null) return 'Harga tidak valid';
    if (price <= 0) return 'Harga harus lebih dari 0';
    return null;
  }

  // Verification status color
  static String verificationLabel(String status) {
    switch (status) {
      case 'approved':
        return 'Disetujui';
      case 'rejected':
        return 'Ditolak';
      default:
        return 'Menunggu Review';
    }
  }

  // Generate chat room ID
  static String generateChatRoomId(
      String pembeliId, String penjualId, String productId) {
    final ids = [pembeliId, penjualId, productId]..sort();
    return ids.join('_');
  }
}
