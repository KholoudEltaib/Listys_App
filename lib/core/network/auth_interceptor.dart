// core/network/auth_interceptor.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:listys_app/core/constants/app_constants.dart';
import 'package:listys_app/core/routes/app_routes.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;
  final GlobalKey<NavigatorState> navigatorKey;

  static const _authPaths = [
    '/auth/login',
    '/auth/register',
    '/auth/google',
  ];

  AuthInterceptor({
    required this.secureStorage,
    required this.navigatorKey,
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final path = err.requestOptions.path;
      final isAuthEndpoint = _authPaths.any((p) => path.contains(p));

      if (isAuthEndpoint) {
        handler.next(err);
        return;
      }

      // Expired/invalid session on a protected endpoint → force logout.
      print('🔒 Session expired — clearing cache and redirecting to login');

      await secureStorage.delete(key: AppConstants.tokenKey);
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.userDataKey);

      final context = navigatorKey.currentContext;
      if (context != null && context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.loginScreen,
          (route) => false,
        );
      }

      handler.resolve(
        Response(
          requestOptions: err.requestOptions,
          statusCode: 401,
        ),
      );
      return;
    }

    handler.next(err);
  }
}