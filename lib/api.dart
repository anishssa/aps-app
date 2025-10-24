import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import './constant.dart';

class Api {
  static final _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static setAuth(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  static removeAuth() {
    _dio.options.headers.remove('Authorization');
  }

  static Dio dio() {
    return _dio;
  }

  static bool isSuccess(statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  static bool isFailed(statusCode) {
    return !isSuccess(statusCode);
  }

  static bool isUnauthorized(statusCode) {
    return statusCode == 401;
  }

  static String getErrorMessage(dynamic e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data != null) {
        final error = data['error'];
        if (error is List) return data['message'] ?? 'Unknown error';
        if (error is Map) return error.values.first[0];
        return error.toString();
      }
      return e.message ?? 'Unknown error';
    }
    return e.toString();
  }

  static Future<bool> isNetworkConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  static void initializeInterceptors() {
    _dio.interceptors.clear();
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          if (isUnauthorized(error.response?.statusCode ?? 0)) {
            // Attempt to refresh token
            final refreshed = await _refreshToken();
            if (refreshed) {
              final opts = error.requestOptions;
              opts.headers['Authorization'] =
                  _dio.options.headers['Authorization'];
              try {
                final response = await _dio.fetch(opts);
                return handler.resolve(response);
              } catch (e) {}
            }

            removeAuth();
            _redirectToLogin();
          }
          return handler.next(error);
        },
      ),
    );
  }

  static Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _getRefreshToken();
      if (refreshToken == null) return false;
      final response = await _dio.post(
        '/refresh',
        options: Options(
          headers: {
            'Authorization': 'Bearer $refreshToken',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (isSuccess(response.statusCode ?? 0)) {
        final newToken = response.data['token'];
        setAuth(newToken);
        await _saveAccessToken(response.data);
        return true;
      }
    } catch (e) {
      // Handle refresh error
    }
    return false;
  }

  static Future<String?> _getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  static Future<void> _saveAccessToken(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', data['token']);
    prefs.setString('refresh_token', data['refresh_token']);
    prefs.setString('user', jsonEncode(data));
  }

  static Future<void> _redirectToLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('refresh_token');
    prefs.remove('user');
    Get.offAllNamed('/login');
  }

  static Future<void> saveFcmToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('fcm_token', token);
  }

  static Future<String?> getFcmToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcm_token');
  }
}
