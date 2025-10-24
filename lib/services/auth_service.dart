import 'dart:math';

import './../api.dart';
import 'package:dio/dio.dart';

class AuthService {
  Future<Map> login(String email, String password) async {
    final token = await Api.getFcmToken();
    var res = await Api.dio().post<Map<String, dynamic>>('/login',
        data: {'email_or_mobile': email, 'password': password, 'fcm_token' : token}).catchError((e) {
      if (Api.isFailed(e.response.statusCode)) {
        throw Exception(Api.getErrorMessage(e));
      }
    });

    if (Api.isFailed(res.statusCode)) {
      throw Exception('Login failed. ${res.data!['message']}');
    }

    return res.data!['data'];
  }

  Future<Map> register(
      String name, String email, String password, String mobile) async {
    var res = await Api.dio().post<Map<String, dynamic>>('/register', data: {
      'name': name,
      'email': email,
      'password': password,
      'mobile_number': mobile
    }).catchError((e) {
      if (Api.isFailed(e.response.statusCode)) {
        throw Exception(Api.getErrorMessage(e));
      }
    });

    if (Api.isFailed(res.statusCode)) {
      throw Exception('Register failed. ${res.data!['message']}');
    }

    return res.data!['data'];
  }

  Future<Map> getMe() async {
    var res = await Api.dio().get('/get-me').catchError((e) {
      if (Api.isFailed(e.response.statusCode)) {
        throw Exception(Api.getErrorMessage(e));
      }
    });

    if (Api.isFailed(res.statusCode)) {
      throw Exception('Profile failed. ${res.data!['message']}');
    }
    return res.data!['data'];
  }

  Future<String> updateProfile(data, profileImage) async {
    var frmData = {
      'name': data['name'],
    };
    if (profileImage != null) {
      frmData['profile_photo'] = await MultipartFile.fromFile(profileImage.path);
    }

    final formData = FormData.fromMap(frmData);

    var res = await Api.dio()
        .post<Map<String, dynamic>>('/profile-update',
            data: formData,
            options: Options(contentType: 'multipart/form-data'))
        .catchError((e) {
      if (Api.isFailed(e.response.statusCode)) {
        throw Exception(Api.getErrorMessage(e));
      }
    });
    if (Api.isFailed(res.statusCode)) {
      throw Exception('Profile Update failed. ${res.data!['message']}');
    }
    return res.data!['message'];
  }

  Future<String> updateMe(data) async {
    var frmData = {
      'name': data['name'],
      'email': data['email'],
      'mobile_number': data['mobile_number'],
    };
    final formData = FormData.fromMap(frmData);

    var res = await Api.dio()
        .post<Map<String, dynamic>>('/update',
        data: formData,)
        .catchError((e) {
      if (Api.isFailed(e.response.statusCode)) {
        throw Exception(Api.getErrorMessage(e));
      }
    });
    if (Api.isFailed(res.statusCode)) {
      throw Exception('Profile failed. ${res.data!['message']}');
    }
    return res.data!['message'];
  }

  Future<String> deletePhoto() async {
    var res = await Api.dio()
        .delete<Map<String, dynamic>>('/profile-delete')
        .catchError((e) {
      if (Api.isFailed(e.response.statusCode)) {
        throw Exception(Api.getErrorMessage(e));
      }
    });

    if (Api.isFailed(res.statusCode)) {
      throw Exception('Photo Delete failed. ${res.data!['message']}');
    }

    return res.data!['message'];
  }


  Future<String> changePassword(
      String oldPass, String newPass, String conPass) async {
    var res =
        await Api.dio().post<Map<String, dynamic>>('/change-password', data: {
      'currentpassword': oldPass,
      'newpassword': newPass,
      'newpassword_confirmation': conPass
    }).catchError((e) {
      if (Api.isFailed(e.response.statusCode)) {
        throw Exception(Api.getErrorMessage(e));
      }
    });

    if (Api.isFailed(res.statusCode)) {
      throw Exception('Login failed. ${res.data!['message']}');
    }

    return res.data!['message'];
  }

  Future<String> logout() async {
    var res =
        await Api.dio().post<Map<String, dynamic>>('/logout').catchError((e) {
      if (Api.isFailed(e.response.statusCode)) {
        throw Exception(Api.getErrorMessage(e));
      }
    });

    if (Api.isFailed(res.statusCode)) {
      throw Exception('Logout failed. ${res.data!['message']}');
    }

    return res.data!['message'];
  }

  Future<String> forgotPassword(String email) async {
    var res = await Api.dio().post<Map<String, dynamic>>('/forgot-otp',
        data: {'email': email}).catchError((e) {
      if (Api.isFailed(e.response.statusCode)) {
        throw Exception(Api.getErrorMessage(e));
      }
    });

    if (Api.isFailed(res.statusCode)) {
      throw Exception('Forgot password failed. ${res.data!['message']}');
    }

    return res.data!['message'];
  }

  Future<String> verifyOtp(String email, String otp) async {
    var res = await Api.dio().post<Map<String, dynamic>>('/verify-otp',
        data: {'email': email, 'otp': otp}).catchError((e) {
      if (Api.isFailed(e.response.statusCode)) {
        throw Exception(Api.getErrorMessage(e));
      }
    });

    if (Api.isFailed(res.statusCode)) {
      throw Exception('Verify OTP failed. ${res.data!['message']}');
    }

    return res.data!['message'];
  }

  Future<String> resetPassword(
      String email, String password, String conPassword, String otp) async {
    var res = await Api.dio().post<Map<String, dynamic>>('/password-change',
        data: {
          'email': email,
          'newpassword': password,
          'newpassword_confirmation': conPassword,
          'otp': otp
        }).catchError((e) {
      if (Api.isFailed(e.response.statusCode)) {
        throw Exception(Api.getErrorMessage(e));
      }
    });

    if (Api.isFailed(res.statusCode)) {
      throw Exception('Reset password failed. ${res.data!['message']}');
    }

    return res.data!['message'];
  }
}
