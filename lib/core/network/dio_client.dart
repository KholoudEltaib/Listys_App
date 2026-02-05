import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../constants/api_endpoints.dart';
import '../utils/storage_helper.dart';

/// Dio client with interceptors for logging, token handling, and error management
class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _setupInterceptors(); 
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

 void _setupInterceptors() {
  _dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        print('📤 === OUTGOING REQUEST ===');
        print('   URL: ${options.uri}');
        print('   Method: ${options.method}');
        
        // Get token
        final token = await StorageHelper.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
          print('   🔐 Token: ${token.substring(0, 20)}...');
        }

        // Get locale
        final locale = await StorageHelper.getLocale();
        print('   🌍 Locale from storage: $locale');
        
        if (locale != null) {
          options.headers['Accept-Language'] = locale;
          options.headers['lang'] = locale;
          print('   ✅ Added language headers: $locale');
        } else {
          print('   ⚠️ No locale found, using default');
          options.headers['Accept-Language'] = 'en';
          options.headers['lang'] = 'en';
        }

        print('   📋 Final Headers: ${options.headers}');
        print('========================');
        
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('📥 === INCOMING RESPONSE ===');
        print('   Status: ${response.statusCode}');
        print('   Headers: ${response.headers}');
        print('========================');
        return handler.next(response);
      },
      onError: (error, handler) async {
        print('❌ === ERROR ===');
        print('   Status: ${error.response?.statusCode}');
        print('   Message: ${error.message}');
        print('================');
        
        if (error.response?.statusCode == 401) {
          await StorageHelper.clearCache();
        }
        return handler.next(error);
      },
    ),
  );

  // PrettyDioLogger for additional debugging
  if (const bool.fromEnvironment('dart.vm.product') == false) {
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: false,  // Set to false for full details
      ),
    );
  }
}

  String _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('message')) {
        return data['message'].toString();
      }
      if (data.containsKey('error')) {
        return data['error'].toString();
      }
    }
    return 'An error occurred';
  }

  /// Get Dio instance
  Dio get dio => _dio;

  /// Update token in headers
  Future<void> updateToken(String? token) async {
    if (token != null && token.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  /// Clear token from headers
  void clearToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Reset Dio instance
  void reset() {
    _dio.options.headers.clear();
    _dio.options.headers.addAll({
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    });
  }
}