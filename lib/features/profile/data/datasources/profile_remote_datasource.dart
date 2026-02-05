// features/profile/data/datasources/profile_remote_datasource.dart

import 'package:dio/dio.dart';
import 'package:listys_app/features/profile/data/models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getProfile();
  Future<UserModel> updateProfile({
    required String name,
    required String email,
    String? imagePath,
  });
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  });
  Future<void> changeLanguage(String locale);
  Future<void> deleteAccount();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await dio.get('/profile');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true && data['data'] != null) {
          return UserModel.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Failed to load profile');
        }
      } else {
        throw Exception('Failed to load profile');
      }
    } on DioException catch (e) {
  final message =
      e.response?.data is Map
          ? e.response?.data['message']
          : e.message;

  throw Exception(message ?? 'Network error');
}
  catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

 @override
Future<UserModel> updateProfile({
  required String name,
  required String email,
  String? imagePath,
}) async {
  try {
    final formData = FormData.fromMap({
      'name': name,
      'email': email,
      if (imagePath != null && imagePath.isNotEmpty)
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        ),
    });

    final response = await dio.post(
      '/profile/update',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      if (data['status'] == true && data['data'] != null) {
        return UserModel.fromJson(data['data']);
      }
      throw Exception(data['message'] ?? 'Failed to update profile');
    }

    throw Exception('Failed to update profile');
  } on DioException catch (e) {
    final message =
        e.response?.data is Map
            ? e.response?.data['message']
            : e.message;

    throw Exception(message ?? 'Network error');
  }
}


  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final response = await dio.post(
        '/profile/password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': newPasswordConfirmation,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] != true) {
          throw Exception(data['message'] ?? 'Failed to change password');
        }
      } else {
        throw Exception('Failed to change password');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Network error occurred');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> changeLanguage(String locale) async {
    try {
      final response = await dio.post(
        '/profile/language',
        data: {
          'locale': locale,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] != true) {
          throw Exception(data['message'] ?? 'Failed to change language');
        }
      } else {
        throw Exception('Failed to change language');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Network error occurred');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      print('📡 API Call: DELETE /profile');
      
      final response = await dio.delete(
        '/profile',
        options: Options(
          validateStatus: (status) {
            // Accept 200, 204, and even 404 as success for delete operations
            return status != null && status >= 200 && status < 300;
          },
        ),
      );
      
      print('📡 Response Status: ${response.statusCode}');
      print('📡 Response Data: ${response.data}');
      
      // Consider both 200 and 204 as success
      if (response.statusCode == 200 || response.statusCode == 204) {
        // Check if there's a response body
        if (response.data != null && response.data is Map) {
          final data = response.data as Map<String, dynamic>;
          
          // If there's a status field, check it
          if (data.containsKey('status') && data['status'] == false) {
            throw Exception(data['message'] ?? 'Failed to delete account');
          }
        }
        
        print('✅ Account deleted successfully');
        return;
      } else {
        throw Exception('Failed to delete account: Unexpected status ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ DioException during delete: ${e.type}');
      print('❌ Response: ${e.response?.data}');
      print('❌ Status Code: ${e.response?.statusCode}');
      
      // Handle specific error responses
      if (e.response != null) {
        final data = e.response!.data;
        if (data is Map && data['message'] != null) {
          throw Exception(data['message']);
        }
        throw Exception('Failed to delete account: ${e.response!.statusCode}');
      }
      
      throw Exception(e.message ?? 'Network error occurred');
    } catch (e) {
      print('❌ Unexpected error during delete: $e');
      throw Exception('Error deleting account: $e');
    }
  }
}