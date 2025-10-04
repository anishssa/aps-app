import 'package:get/get.dart';

import '../services/auth_service.dart';

class ForgotPasswordController extends GetxController {
  var loading = false.obs;
  var email = '';
  var password = '';
  var confirmPassword = '';
  var otp = '';
  var form = 'email'.obs;

  var message = ''.obs;

  var service = AuthService();

  Future<void> getOtp() async {
    loading.value = true;
    try {
      var data = await service.forgotPassword(email);
      message.value = data;

    } finally {
      loading.value = false;
    }
  }

  Future<void> checkOtp() async {
    loading.value = true;
    try {
      var data = await service.verifyOtp(email, otp);
      message.value = data;

    } finally {
      loading.value = false;
    }
  }

  Future<void> resetPassword() async {
    loading.value = true;
    try {
      var data = await service.resetPassword(email, password, confirmPassword, otp);
      message.value = data;
    } finally {
      loading.value = false;
    }
  }
}
