import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/networking/api_constants.dart';

class AuthService {
  Future<Map<String, dynamic>> loginWithInstagram() async {
    throw Exception(
      'Social login needs provider access token. Please integrate provider SDK first.',
    );
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<String?> getToken() async {
    try {
      print('[AuthService] getToken called');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      print('[AuthService] getToken returning: \\${token ?? 'null'}');
      return token;
    } catch (e, stack) {
      print('[AuthService] Error in getToken: \\${e.toString()}');
      print(stack);
      return null;
    }
  }

  Future<Map<String, dynamic>> loginWithEmail(
      String email, String password) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final payload = (data is Map<String, dynamic>) ? data : <String, dynamic>{};
      final token = (payload['data'] ?? payload)['access_token'] ??
          payload['token'];
      if (token != null) {
        await saveToken(token.toString());
      }
      return payload;
    } else {
      // Parse the error response to extract the message field
      try {
        final errorData = json.decode(response.body);
        final message = (errorData is Map && errorData['message'] != null)
            ? errorData['message']
            : 'Login failed';
        throw Exception(message.toString());
      } catch (parseError) {
        throw Exception('Login failed');
      }
    }
  }

  Future<Map<String, dynamic>> register(String name, String email,
      String password) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.register}');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      final payload = (data is Map<String, dynamic>) ? data : <String, dynamic>{};
      final token = (payload['data'] ?? payload)['access_token'] ??
          payload['token'];
      if (token != null) {
        await saveToken(token.toString());
      }
      return payload;
    } else {
      // Parse the error response to extract the message field robustly
      String message = 'Registration failed';
      try {
        final errorData = json.decode(response.body);
        if (errorData is Map && errorData['message'] != null) {
          message = errorData['message'];
        } else {
          message = response.body.toString();
        }
      } catch (parseError) {
        // If not JSON, show raw response
        message = response.body.toString();
      }
      throw Exception(message);
    }
  }

  Future<Map<String, dynamic>> loginWithFacebook() async {
    throw Exception(
      'Social login needs provider access token. Please integrate provider SDK first.',
    );
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    final token = await getToken();
    if (token == null) throw Exception('No auth token');
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.profile}');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is Map<String, dynamic>) {
        return data['data'] ?? data;
      }
      return {'data': data};
    } else {
      throw Exception('Failed to fetch user profile: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> updateUserProfile(
      {required String name, required String email}) async {
    final token = await getToken();
    if (token == null) throw Exception('No auth token');
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.profileUpdate}');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'name': name,
        'email': email,
      }),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }

  Future<void> changePassword(
      {required String currentPassword,
      required String newPassword,
      required String passwordConfirmation}) async {
    final token = await getToken();
    if (token == null) throw Exception('No auth token');
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.changePassword}');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'current_password': currentPassword,
        'password': newPassword,
        'password_confirmation': passwordConfirmation,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to change password: ${response.body}');
    }
  }

  Future<void> deleteAccount() async {
    final token = await getToken();
    if (token == null) throw Exception('No auth token');
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.deleteAccount}');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete account: ${response.body}');
    }
  }
}
