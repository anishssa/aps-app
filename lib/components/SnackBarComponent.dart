import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBarComponent {
  static void showSuccess(BuildContext context, String? message) {
    Get.snackbar(
      'Success',
      message ?? 'Operation completed successfully.',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.teal.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 12,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      boxShadows: [
        BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2)),
      ],
    );
  }

  static void showError(BuildContext context, String? message) {
    message = message?.replaceAll('Exception: ', '');
    Get.snackbar(
      'Error',
      message ?? 'An unexpected error occurred.',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 12,
      icon: const Icon(Icons.error, color: Colors.white),
      boxShadows: [
        BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2)),
      ],
    );
  }
}
