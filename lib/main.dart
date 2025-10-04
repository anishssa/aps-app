import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import './pages/login.dart';
import './pages/register.dart';
import './pages/service.dart';
import './pages/service_action.dart';
import './pages/profile.dart';
import './pages/change_password.dart';
import './pages/profile_action.dart';
import './controllers/auth_controller.dart';
import './pages/forgot_password.dart';
import './pages/address_action.dart';
import './pages/product.dart';
import 'api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Api.initializeInterceptors();

  // Request storage permissions at startup
  await _requestStoragePermission();

  var authController = Get.put(AuthController());

  await authController.init();

  runApp(GetMaterialApp(
    title: 'APS',
    theme: ThemeData(
      primaryColor: Colors.white,
      colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.black),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2.0),
        ),
      ),
    ),
    home: authController.isLoggedIn.value ? const Service() : const Login(),
    debugShowCheckedModeBanner: false,
    getPages: [
      GetPage(name: '/', page: () => const Login()),
      GetPage(name: '/register', page: () => const Register()),
      GetPage(name: '/service', page: () => const Service()),
      GetPage(name: '/service-add', page: () => const ServiceAction()),
      GetPage(name: '/profile', page: () => const Profile()),
      GetPage(name: '/product', page: () => const Product()),
      GetPage(name: '/profile-edit', page: () => const ProfileAction()),
      GetPage(name: '/address-action', page: () => const AddressAction()),
      GetPage(name: '/change-password', page: () => const ChangePassword()),
      GetPage(name: '/forgot-password', page: () => const ForgotPassword()),
    ],
  ));
}

Future<void> _requestStoragePermission() async {
  if (await Permission.storage.request().isDenied) {
    // You can show a dialog or message to the user here if needed
    await Permission.storage.request();
  }
  // For Android 11+ MANAGE_EXTERNAL_STORAGE
  if (await Permission.manageExternalStorage.isDenied) {
    await Permission.manageExternalStorage.request();
  }
}
