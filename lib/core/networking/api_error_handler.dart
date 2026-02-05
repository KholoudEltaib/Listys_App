import 'dart:convert';

import 'package:dio/dio.dart';

import 'api_error_model.dart';

class ApiErrorHandler {
  static ApiErrorModel handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionError:
          return ApiErrorModel(message: "Connection to server failed");
        case DioExceptionType.cancel:
          return ApiErrorModel(message: "Request to the server was cancelled");
        case DioExceptionType.connectionTimeout:
          return ApiErrorModel(message: "Connection timeout with the server");
        case DioExceptionType.unknown:
          return ApiErrorModel(
              message:
                  "Connection to the server failed due to internet connection");
        case DioExceptionType.receiveTimeout:
          return ApiErrorModel(
              message: "Receive timeout in connection with the server");
        case DioExceptionType.badResponse:
          return _handleBadResponse(error);
        case DioExceptionType.sendTimeout:
          return ApiErrorModel(
              message: "Send timeout in connection with the server");
        default:
          return ApiErrorModel(message: "Something went wrong");
      }
    } else {
      return ApiErrorModel(message: "Unknown error occurred");
    }
  }

  static ApiErrorModel _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    try {
      if (data is Map<String, dynamic>) {
        return ApiErrorModel.fromJson(data, statusCode: statusCode);
      } else if (data is String) {
        try {
          final jsonData = jsonDecode(data) as Map<String, dynamic>;
          return ApiErrorModel.fromJson(jsonData, statusCode: statusCode);
        } catch (_) {
          return ApiErrorModel(
              message: data, statusCode: statusCode, rawData: data);
        }
      }
    } catch (_) {
      return ApiErrorModel(
        message: "Failed to parse error response",
        statusCode: statusCode,
        rawData: data,
      );
    }

    return ApiErrorModel(
      message: "Unexpected error format",
      statusCode: statusCode,
      rawData: data,
    );
  }
}
