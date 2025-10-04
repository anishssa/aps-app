import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import './constant.dart';

class Api {
  static final _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    headers: {'Content-Type': 'application/json'},
  ));

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
    print('--------------------------- intercept init  ---------------------------');

    _dio.interceptors.clear();
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) async {
        print('--------------------------- intercept error  ---------------------------');

        if (isUnauthorized(error.response?.statusCode ?? 0)) {
          print('--------------------------- intercept error 401 ---------------------------');

          // Attempt to refresh token
          final refreshed = await _refreshToken();
          if (refreshed) {
            print('--------------------------- intercept error 401 refreshed ---------------------------');
            // Retry the original request with new token
            final opts = error.requestOptions;
            print('--------------------------- opts  ---------------------------');
            print(opts);
            opts.headers['Authorization'] = _dio.options.headers['Authorization'];
            try {
              final response = await _dio.fetch(opts);
              return handler.resolve(response);
            } catch (e) {
              // If retry fails, fall through to redirect
            }
          }
          // If refresh fails, remove auth and redirect to login
          removeAuth();
          _redirectToLogin();
        }
        return handler.next(error);
      },
    ));
  }

  static Future<bool> _refreshToken() async {
    print('--------------------------- intercept error 401 _refreshToken ---------------------------');

    try {
      final refreshToken = await _getRefreshToken();
      if (refreshToken == null) return false;
      final response = await _dio.post(
        '/refresh',
        options: Options(
          headers: {'Authorization': 'Bearer $refreshToken', 'Content-Type': 'application/json'},
        ),
      );
      if (isSuccess(response.statusCode ?? 0)) {
        print('--------------------------- intercept error 401 _refreshToken succes ---------------------------');

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
    print('--------------------------- _getRefreshToken ---------------------------');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  static Future<void> _saveAccessToken(data) async {
    print('--------------------------- _saveAccessToken ---------------------------');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', data['token']);
    prefs.setString('refresh_token', data['refresh_token']);
    prefs.setString('user', jsonEncode(data));
  }

  static Future<void> _redirectToLogin() async {

    print('--------------------------- _redirectToLogin ---------------------------');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('refresh_token');
    prefs.remove('user');
    Get.offAllNamed('/login');
  }


}
