import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/auth_result_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResultModel> loginWithEmail(String email, String password);
  Future<AuthResultModel> register(String name, String email, String password);
  Future<AuthResultModel> loginWithInstagram();
  Future<AuthResultModel> loginWithFacebook();
  Future<AuthResultModel> loginWithGoogle();
  Future<UserModel> getUserProfile(String token);
  Future<UserModel> updateUserProfile(String token, {required String name, required String email});
  Future<void> changePassword(String token, {
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  });
  Future<void> deleteAccount(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['message'] != null) return data['message'].toString();
      if (data['error'] != null) return data['error'].toString();
    }
    return null;
  }

  @override
  Future<AuthResultModel> loginWithEmail(String email, String password) async {
    try {
      final loginResponse = await dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      if (loginResponse.statusCode == null ||
          loginResponse.statusCode! < 200 ||
          loginResponse.statusCode! >= 300) {
        final message = _extractMessage(loginResponse.data) ?? 'Login failed';
        throw ServerException(message, statusCode: loginResponse.statusCode);
      }

      final data = loginResponse.data is Map<String, dynamic>
          ? loginResponse.data as Map<String, dynamic>
          : throw const ServerException('Invalid response format');

      print('🔍 Login response: $data');

      final responseData = data['data'] as Map<String, dynamic>?;
      if (responseData == null) {
        throw const ServerException('Invalid response: missing data');
      }

      final token = responseData['token'] as String?;
      if (token == null || token.isEmpty) {
        final accessToken = responseData['access_token'] as String?;
        if (accessToken == null || accessToken.isEmpty) {
          throw ServerException('Invalid response: missing token. Available keys: ${responseData.keys}');
        }
        
        final userJson = responseData['user'] as Map<String, dynamic>?;
        if (userJson == null) {
          final userModel = await getUserProfile(accessToken);
          return AuthResultModel(token: accessToken, user: userModel);
        }
        
        final userModel = UserModel.fromJson(userJson);
        return AuthResultModel(token: accessToken, user: userModel);
      }
      
      final userJson = responseData['user'] as Map<String, dynamic>?;
      if (userJson == null) {
        final userModel = await getUserProfile(token);
        return AuthResultModel(token: token, user: userModel);
      }
      
      final userModel = UserModel.fromJson(userJson);
      return AuthResultModel(token: token, user: userModel);
      
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      if (e.response != null) {
        final message = _extractMessage(e.response?.data) ?? 'Login failed';
        throw ServerException(message, statusCode: e.response?.statusCode);
      }
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<AuthResultModel> register(String name, String email, String password) async {
    try {
      final registerResponse = await dio.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      if (registerResponse.statusCode == null ||
          registerResponse.statusCode! < 200 ||
          registerResponse.statusCode! >= 300) {
        final message = _extractMessage(registerResponse.data) ?? 'Registration failed';
        throw ServerException(message, statusCode: registerResponse.statusCode);
      }

      final data = registerResponse.data is Map<String, dynamic>
          ? registerResponse.data as Map<String, dynamic>
          : throw const ServerException('Invalid response format');

      print('🔍 Register response: $data');

      final responseData = data['data'] as Map<String, dynamic>?;
      if (responseData == null) {
        throw const ServerException('Invalid response: missing data');
      }

      print('🔍 Response data: $responseData');

      final token = responseData['token'] as String?;
      if (token == null || token.isEmpty) {
        final accessToken = responseData['access_token'] as String?;
        if (accessToken == null || accessToken.isEmpty) {
          throw ServerException('Invalid response: missing token. Available keys: ${responseData.keys}');
        }
        print('✅ Using access_token: $accessToken');
        
        final userJson = responseData['user'] as Map<String, dynamic>?;
        if (userJson == null) {
          throw const ServerException('Invalid response: missing user data');
        }
        
        final userModel = UserModel.fromJson(userJson);
        return AuthResultModel(token: accessToken, user: userModel);
      }
      
      print('✅ Using token: $token');
      
      final userJson = responseData['user'] as Map<String, dynamic>?;
      if (userJson == null) {
        throw const ServerException('Invalid response: missing user data');
      }
      
      final userModel = UserModel.fromJson(userJson);
      return AuthResultModel(token: token, user: userModel);
      
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      if (e.response != null) {
        final message = _extractMessage(e.response?.data) ?? 'Registration failed';
        throw ServerException(message, statusCode: e.response?.statusCode);
      }
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<AuthResultModel> loginWithGoogle() async {
    try {
      print('🔵 Google Login: Starting SDK authentication...');
      
      // Initialize Google Sign-In if needed
      await GoogleSignIn.instance.initialize(
        clientId: '184288028654-eimu7b64g2roh0v9r60giiicl0s36amj.apps.googleusercontent.com', // Add your client ID here
      );
      
      // Step 1: Sign in with Google SDK
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance.authenticate();
      
      if (googleUser == null) {
        print('❌ Google sign in cancelled');
        throw const ServerException('Google sign in cancelled');
      }
      
      print('🟢 Google user signed in: ${googleUser.email}');
      
      // Step 2: Get authentication details
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      
      if (idToken == null) {
        print('❌ Failed to get Google ID token');
        throw const ServerException('Failed to get Google ID token');
      }
      
      print('🟢 Google ID token: ${idToken.substring(0, 20)}...');
      
      // Step 3: Send token to backend using the correct endpoint format
      print('🔵 Sending token to backend: POST /auth/social/google');
      final response = await dio.post(
        '/auth/social/google',
        data: {
          'access_token': idToken,
        },
      );
      
      print('🟢 Backend response: ${response.statusCode}');
      
      if (response.statusCode != 200) {
        final message = _extractMessage(response.data) ?? 'Google login failed';
        throw ServerException(message, statusCode: response.statusCode);
      }
      
      final data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : throw const ServerException('Invalid response format');
      
      final responseData = data['data'] as Map<String, dynamic>?;
      if (responseData == null) {
        throw const ServerException('Invalid response: missing data');
      }
      
      final token = responseData['access_token'] as String?;
      if (token == null || token.isEmpty) {
        throw const ServerException('Invalid response: missing access token');
      }
      
      print('🟢 JWT token received: ${token.substring(0, 20)}...');
      
      // Check if user is in response
      final userJson = responseData['user'] as Map<String, dynamic>?;
      if (userJson != null) {
        final userModel = UserModel.fromJson(userJson);
        return AuthResultModel(token: token, user: userModel);
      }
      
      // If no user in response, fetch it
      final userModel = await getUserProfile(token);
      return AuthResultModel(token: token, user: userModel);
      
    } on DioException catch (e) {
      print('❌ Dio error: ${e.message}');
      if (e.error is ServerException) rethrow;
      if (e.response != null) {
        final message = _extractMessage(e.response?.data) ?? 'Google login failed';
        throw ServerException(message, statusCode: e.response?.statusCode);
      }
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      print('❌ Error: $e');
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException('Google login error: $e');
    }
  }

  @override
  Future<AuthResultModel> loginWithFacebook() async {
    try {
      print('🔵 Facebook Login: Starting SDK authentication...');
      
      // Step 1: Sign in with Facebook SDK
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );
      
      if (result.status != LoginStatus.success) {
        print('❌ Facebook login failed: ${result.status}');
        throw ServerException('Facebook login ${result.status}: ${result.message}');
      }
      
      final AccessToken? accessToken = result.accessToken;
      if (accessToken == null) {
        print('❌ Failed to get Facebook access token');
        throw const ServerException('Failed to get Facebook access token');
      }
      
      print('🟢 Facebook access token: ${accessToken.tokenString.substring(0, 20)}...');
      
      // Step 2: Send token to backend using the correct endpoint format
      print('🔵 Sending token to backend: POST /auth/social/facebook');
      final response = await dio.post(
        '/auth/social/facebook',
        data: {
          'access_token': accessToken.tokenString,
        },
      );
      
      print('🟢 Backend response: ${response.statusCode}');
      
      if (response.statusCode != 200) {
        final message = _extractMessage(response.data) ?? 'Facebook login failed';
        throw ServerException(message, statusCode: response.statusCode);
      }
      
      final data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : throw const ServerException('Invalid response format');
      
      final responseData = data['data'] as Map<String, dynamic>?;
      if (responseData == null) {
        throw const ServerException('Invalid response: missing data');
      }
      
      final token = responseData['access_token'] as String?;
      if (token == null || token.isEmpty) {
        throw const ServerException('Invalid response: missing access token');
      }
      
      print('🟢 JWT token received: ${token.substring(0, 20)}...');
      
      // Check if user is in response
      final userJson = responseData['user'] as Map<String, dynamic>?;
      if (userJson != null) {
        final userModel = UserModel.fromJson(userJson);
        return AuthResultModel(token: token, user: userModel);
      }
      
      // If no user in response, fetch it
      final userModel = await getUserProfile(token);
      return AuthResultModel(token: token, user: userModel);
      
    } on DioException catch (e) {
      print('❌ Dio error: ${e.message}');
      if (e.error is ServerException) rethrow;
      if (e.response != null) {
        final message = _extractMessage(e.response?.data) ?? 'Facebook login failed';
        throw ServerException(message, statusCode: e.response?.statusCode);
      }
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      print('❌ Error: $e');
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException('Facebook login error: $e');
    }
  }

  @override
  Future<AuthResultModel> loginWithInstagram() async {
    throw const ServerException(
      'Instagram login not yet implemented. Please contact support.',
    );
  }

  @override
  Future<UserModel> getUserProfile(String token) async {
    try {
      final response = await dio.get(
        ApiEndpoints.profile,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.statusCode == 200) {
        final data = (response.data is Map<String, dynamic>)
            ? response.data as Map<String, dynamic>
            : <String, dynamic>{};
        final userData = data['data'] ?? data['user'] ?? data;
        return UserModel.fromJson(
          (userData is Map<String, dynamic>) ? userData : <String, dynamic>{},
        );
      }
      final message =
          _extractMessage(response.data) ?? 'Failed to fetch user profile';
      throw ServerException(message, statusCode: response.statusCode);
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      if (e.response != null) {
        final message = _extractMessage(e.response?.data) ??
            'Failed to fetch user profile';
        throw ServerException(message, statusCode: e.response?.statusCode);
      }
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<UserModel> updateUserProfile(String token, {required String name, required String email}) async {
    try {
      final response = await dio.post(
        ApiEndpoints.profileUpdate,
        data: FormData.fromMap({
          'name': name,
          'email': email,
        }),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.statusCode == 200) {
        final data = (response.data is Map<String, dynamic>)
            ? response.data as Map<String, dynamic>
            : <String, dynamic>{};
        final userData = data['data'] ?? data['user'] ?? data;
        return UserModel.fromJson(
          (userData is Map<String, dynamic>) ? userData : <String, dynamic>{},
        );
      }
      final message =
          _extractMessage(response.data) ?? 'Failed to update profile';
      throw ServerException(message, statusCode: response.statusCode);
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      if (e.response != null) {
        final message =
            _extractMessage(e.response?.data) ?? 'Failed to update profile';
        throw ServerException(message, statusCode: e.response?.statusCode);
      }
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<void> changePassword(String token, {
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await dio.post(
        ApiEndpoints.profilePassword,
        data: {
          'current_password': currentPassword,
          'password': newPassword,
          'password_confirmation': passwordConfirmation,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.statusCode != 200) {
        final message =
            _extractMessage(response.data) ?? 'Failed to change password';
        throw ServerException(message, statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      if (e.response != null) {
        final message = _extractMessage(e.response?.data) ??
            'Failed to change password';
        throw ServerException(message, statusCode: e.response?.statusCode);
      }
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<void> deleteAccount(String token) async {
    try {
      final response = await dio.delete(
        ApiEndpoints.profileDelete,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        final message = response.data['message'] ?? 'Failed to delete account';
        throw ServerException(message, statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      if (e.response != null) {
        final message = e.response?.data['message'] ?? 'Failed to delete account';
        throw ServerException(message, statusCode: e.response?.statusCode);
      }
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException('Unexpected error: $e');
    }
  }
}