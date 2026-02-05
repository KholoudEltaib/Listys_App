import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../../features/auth/data/models/user_model.dart';

/// Helper class for managing secure storage and shared preferences
class StorageHelper {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ==================== Token Management (Secure Storage) ====================

  /// Save authentication token to secure storage
  static Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(
        key: AppConstants.tokenKey,
        value: token,
      );
    } catch (e) {
      throw Exception('Failed to save token: $e');
    }
  }

  /// Get authentication token from secure storage
  static Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: AppConstants.tokenKey);
    } catch (e) {
      return null;
    }
  }

  /// Remove authentication token from secure storage
  static Future<void> removeToken() async {
    try {
      await _secureStorage.delete(key: AppConstants.tokenKey);
    } catch (e) {
      // Ignore errors when removing token
    }
  }

  /// Check if token exists
  static Future<bool> hasToken() async {
    try {
      final token = await getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // ==================== User Data Management (SharedPreferences) ====================

  /// Save user data to SharedPreferences
  static Future<void> saveUserData(UserModel user) async {
    try {
      await init();
      final userJson = json.encode(user.toJson());
      await _prefs!.setString(AppConstants.userDataKey, userJson);
    } catch (e) {
      throw Exception('Failed to save user data: $e');
    }
  }

  /// Get cached user data from SharedPreferences
  static Future<UserModel?> getCachedUser() async {
    try {
      await init();
      final userJson = _prefs!.getString(AppConstants.userDataKey);
      if (userJson != null) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Remove user data from SharedPreferences
  static Future<void> removeUserData() async {
    try {
      await init();
      await _prefs!.remove(AppConstants.userDataKey);
    } catch (e) {
      // Ignore errors
    }
  }

  // ==================== Locale Management ====================

    /// Save app locale
    static Future<void> saveLocale(String locale) async {
    print('💾 Saving locale: $locale');
    await _prefs?.setString(AppConstants.localeKey, locale);
    final saved = await getLocale();
    print('✅ Verified saved locale: $saved');
  }

  static Future<String?> getLocale() async {
    final locale = _prefs?.getString(AppConstants.localeKey);
    print('📖 Reading locale from storage: $locale');
    return locale;
  }

  // ==================== Onboarding Management ====================

  /// Mark onboarding as completed
  static Future<void> setOnboardingCompleted(bool completed) async {
    try {
      await init();
      await _prefs!.setBool(AppConstants.onboardingKey, completed);
    } catch (e) {
      // Ignore errors
    }
  }

  /// Check if onboarding is completed
  static Future<bool> isOnboardingCompleted() async {
    try {
      await init();
      return _prefs!.getBool(AppConstants.onboardingKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  // ==================== Clear All Cache ====================

  /// Clear all cached data (token, user data, etc.)
  static Future<void> clearCache() async {
    try {
      await removeToken();
      await removeUserData();
    } catch (e) {
      // Ignore errors
    }
  }
}

