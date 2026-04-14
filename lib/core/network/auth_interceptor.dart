// core/network/auth_interceptor.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:listys_app/core/constants/app_constants.dart';
import 'package:listys_app/features/sining/login_screen.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;
  final GlobalKey<NavigatorState> navigatorKey;

  AuthInterceptor({
    required this.secureStorage,
    required this.navigatorKey,
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // 1. Clear all stored credentials
      await secureStorage.delete(key: AppConstants.tokenKey);
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.userDataKey);

      // 2. Navigate to login, removing all previous routes
      final context = navigatorKey.currentContext;
      if (context != null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
      return;
    }

    handler.next(err);
  }
}