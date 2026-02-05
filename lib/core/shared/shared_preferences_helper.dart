import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:listys_app/core/shared/shared_preferences_key.dart';

class SharedPreferencesHelper {
  SharedPreferencesHelper._();

  static const flutterSecureStorage = FlutterSecureStorage();

  /// Saves a [value] with a [key] in the FlutterSecureStorage.
  static Future<void> setSecuredString(String key, String value) async {
    debugPrint(
      "FlutterSecureStorage : setSecuredString with key : $key and value : $value",
    );
    await flutterSecureStorage.write(key: key, value: value);
  }

  /// Gets an String value from FlutterSecureStorage with given [key].
  static Future<String> getSecuredString(String key) async {
    debugPrint('FlutterSecureStorage : getSecuredString with key : $key');
    return await flutterSecureStorage.read(key: key) ?? '';
  }

  static Future<void> deleteSecuredString(String key) async {
    debugPrint("FlutterSecureStorage : deleteSecuredString with key : $key");
    await flutterSecureStorage.delete(key: key);
  }

  static Future<void> deleteSharedPreferKeys() async{
     await flutterSecureStorage.delete(key: SharedPreferencesKey.apiTokenKey);
     await flutterSecureStorage.delete(key: SharedPreferencesKey.verificationTokenKey);
  }
}
