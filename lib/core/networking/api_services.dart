// lib/core/networking/api_services.dart
import 'package:dio/dio.dart';
import 'package:listys_app/core/localization/locale_cubit/locale_cubit.dart';
import 'api_constants.dart';
import 'api_error_handler.dart';
import 'dio_factory.dart';

class ApiServices {
  final Dio _dio;

  ApiServices.internal(this._dio);

  static Future<ApiServices> init() async {
    final dio = await DioFactory.getDio();
    return ApiServices.internal(dio);
  }

  /// POST method
  Future<Response<T>> post<T>({
    required String endpoint,
    required dynamic requestBody,
    bool requiresAuth = true,
  }) async {
    try {
      // 🔄 Refresh headers before request
      await DioFactory.addDioHeaders(includeAuth: requiresAuth);
      
      final response = await _dio.post<T>(
        '${ApiConstants.baseUrl}$endpoint',
        data: requestBody,
      );
      return response;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  /// GET method
  Future<Response<T>> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      // 🔄 Refresh headers before request
      await DioFactory.addDioHeaders(includeAuth: requiresAuth);

      final response = await _dio.get<T>(
        '${ApiConstants.baseUrl}$endpoint',
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  /// PATCH method
  Future<Response<T>> patch<T>({
    required String endpoint,
    required dynamic requestBody,
    bool requiresAuth = true,
  }) async {
    try {
      // 🔄 Refresh headers before request
      await DioFactory.addDioHeaders(includeAuth: requiresAuth);

      final response = await _dio.patch<T>(
        '${ApiConstants.baseUrl}$endpoint',
        data: requestBody,
      );
      return response;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  /// DELETE method
  Future<Response<T>> delete<T>({
    required String endpoint,
    dynamic requestBody,
    bool requiresAuth = true,
  }) async {
    try {
      // 🔄 Refresh headers before request
      await DioFactory.addDioHeaders(includeAuth: requiresAuth);

      final response = await _dio.delete<T>(
        '${ApiConstants.baseUrl}$endpoint',
        data: requestBody,
      );
      return response;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}