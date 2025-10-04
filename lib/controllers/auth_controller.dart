import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';
import '../api.dart';

class AuthController extends GetxController {
  var loading = false.obs;
  var user = {}.obs;
  var email = '';
  var password = '';
  var token = '';
  var refreshToken = '';
  var isLoggedIn = false.obs;
  var action = 'view'.obs;

  var name = '';
  var address = '';
  var mobileNo = '';
  var pinCodeId = '';
  var cityId = '';
  var message = ''.obs;

  var service = AuthService();

  @override
  void onInit() async {
    super.onInit();
    await init();
  }

  Future<void> init() async {
    isLoggedIn.value = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    var userString = prefs.getString('user');
    if (userString == null) {
      return;
    }
    isLoggedIn.value = true;
    user.value = jsonDecode(userString);

    if (token.isNotEmpty) {
      Api.setAuth(token);
    }
  }

  Future<void> login() async {
    loading.value = true;
    try {
      var data = await service.login(email, password);
      user.value = data;
      token = data['token'];
      refreshToken = data['refresh_token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('token', token);
      prefs.setString('refresh_token', refreshToken);
      prefs.setString('user', jsonEncode(data));
      Api.setAuth(token);
      isLoggedIn.value = true;
    } finally {
      loading.value = false;
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String mobile,
  ) async {
    loading.value = true;
    try {
      var data = await service.register(name, email, password, mobile);
    } finally {
      loading.value = false;
    }
  }

  Future<void> getMe() async {
    loading.value = true;
    try {
      var data = await service.getMe();
      user.value = data;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user', jsonEncode(data));
    } finally {
      loading.value = false;
    }
  }

  Future<void> updateMe() async {
    loading.value = true;
    try {
      var data = {'name': name, 'email': email, 'mobile_number': mobileNo};
      var result = await service.updateMe(data);

      message.value = result;
    } finally {
      loading.value = false;
    }
  }

  Future<void> updateProfile(imageData) async {
    loading.value = true;
    try {
      var data = {'full_name': name};
      var result = await service.updateProfile(data, imageData);

      message.value = result;
    } finally {
      loading.value = false;
    }
  }

  Future<void> deletePhoto() async {
    loading.value = true;
    try {
      var result = await service.deletePhoto();
      message.value = result;
    } finally {
      loading.value = false;
    }
  }

  Future<void> changePassword(oldPass, newPass, conPass) async {
    loading.value = true;
    try {
      var data = await service.changePassword(oldPass, newPass, conPass);
      message.value = data;
    } finally {
      loading.value = false;
    }
  }

  Future<void> logout() async {
    loading.value = true;
    try {
      user.value = {};
      token = '';
      refreshToken = '';
      isLoggedIn.value = false;
      Api.removeAuth();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      var result = await service.logout();
      message.value = result;
    } finally {
      loading.value = false;
    }
  }
}
