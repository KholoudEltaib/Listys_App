// lib/core/networking/dio_factory.dart
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../utils/storage_helper.dart';

class DioFactory {
  static Dio? _dio;

  static Future<Dio> getDio() async {
    Duration timeOut = const Duration(seconds: 30);

    if (_dio == null) {
      _dio = Dio();
      _dio!
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut;

      await addDioHeaders();
      _addDioInterceptor();
      
      return _dio!;
    } else {
      await addDioHeaders();
      return _dio!;
    }
  }

  static Future<void> addDioHeaders({bool includeAuth = true}) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    // 🌍 Add language header
    final locale = await StorageHelper.getLocale();
    final lang = locale ?? 'en'; // Default to English
    
    headers['Accept-Language'] = lang;
    headers['lang'] = lang;
    headers['Language'] = lang;

    // 🔐 Add auth token
    if (includeAuth) {
      final token = await StorageHelper.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    _dio?.options.headers = headers;
  }

  static void _addDioInterceptor() {
    // Request Interceptor - Always refresh language header
    _dio?.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 🔄 Always get fresh locale on each request
          final locale = await StorageHelper.getLocale();
          final lang = locale ?? 'en';
          
          options.headers['Accept-Language'] = lang;
          options.headers['lang'] = lang;
          options.headers['Language'] = lang;

          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await StorageHelper.clearCache();
          }
          return handler.next(error);
        },
      ),
    );

    // Logger (debug mode only)
    if (const bool.fromEnvironment('dart.vm.product') == false) {
      _dio?.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
    }
  }

  static void resetDio() {
    _dio = null;
  }
}