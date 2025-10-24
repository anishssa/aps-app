import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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

  await Firebase.initializeApp();
  Api.initializeInterceptors();

  var authController = Get.put(AuthController());
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  String? token = await _fcm.getToken();
  if (token != null) {
    print(token);
    await Api.saveFcmToken(token);
  }
  // Listen for foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Received a message in foreground!');
    print('Message data: ${message}');
    print('Message data: ${message.data}');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  await authController.init();

  runApp(
    GetMaterialApp(
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
      home: authController.isLoggedIn.value ?  Service() : const Login(),
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/', page: () => const Login()),
        GetPage(name: '/register', page: () => const Register()),
        GetPage(name: '/service', page: () => Service()),
        GetPage(name: '/service-add', page: () => const ServiceAction()),
        GetPage(name: '/profile', page: () => const Profile()),
        GetPage(name: '/product', page: () => const Product()),
        GetPage(name: '/profile-edit', page: () => const ProfileAction()),
        GetPage(name: '/address-action', page: () => const AddressAction()),
        GetPage(name: '/change-password', page: () => const ChangePassword()),
        GetPage(name: '/forgot-password', page: () => const ForgotPassword()),
      ],
    ),
  );
}
