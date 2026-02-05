/*
* class change depend on error json return in response
* this I make before to check in all key error because error's key change
* */
class ApiErrorModel {
  final String? message;
  final Map<String, dynamic>? fieldErrors;
  final int? statusCode;
  final bool? showToast;
  final dynamic rawData;

  ApiErrorModel({
    this.message,
    this.fieldErrors,
    this.statusCode,
    this.showToast,
    this.rawData,
  });

  factory ApiErrorModel.fromJson(Map<String, dynamic> json, {int? statusCode}) {
    String? message;

    // Known keys for generic messages
    final possibleMessageKeys = [
      'message',
      'detail',
      'error',
      'msg',
      'description'
    ];
    for (var key in possibleMessageKeys) {
      if (json.containsKey(key) && json[key] is String) {
        message = json[key];
        break;
      }
    }

    // Extract field-specific errors from "data" or "errors"
    Map<String, dynamic>? fieldErrors;
    if (json['data'] is Map) {
      fieldErrors = Map<String, dynamic>.from(json['data']);
    } else if (json['errors'] is Map) {
      fieldErrors = Map<String, dynamic>.from(json['errors']);
    }

    return ApiErrorModel(
      message: message,
      fieldErrors: fieldErrors,
      statusCode: statusCode ?? json['status'] as int?,
      showToast: json['showToast'] as bool?,
      rawData: json,
    );
  }

  /// Returns the best user-friendly message
  String get displayMessage {
    // 1. If there are field-specific errors, return all of them
    if (fieldErrors != null && fieldErrors!.isNotEmpty) {
      final messages = <String>[];

      fieldErrors!.forEach((key, value) {
        if (value is List && value.isNotEmpty) {
          messages.addAll(value.map((e) => e.toString()));
        } else if (value is String && value.isNotEmpty) {
          messages.add(value);
        }
      });

      if (messages.isNotEmpty) {
        return messages.join('\n'); // Join with newlines
      }
    }

    // 2. Otherwise return the general message
    if (message != null && message!.isNotEmpty) {
      return message!;
    }

    // 3. Fallback to HTTP status default
    if (statusCode != null) {
      return _getDefaultMessageForStatusCode(statusCode!);
    }

    // 4. Last resort
    return 'Unknown error occurred';
  }

  static String _getDefaultMessageForStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Resource not found';
      case 422:
        return 'Validation error';
      case 500:
        return 'Internal server error';
      default:
        return 'Unknown error occurred';
    }
  }

  @override
  String toString() =>
      'ApiErrorModel(message: $message, fieldErrors: $fieldErrors, statusCode: $statusCode, showToast: $showToast, rawData: $rawData)';
}
