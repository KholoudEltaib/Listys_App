import 'package:flutter/material.dart';
import 'package:listys_app/services/auth_service.dart';

enum AuthStatus {
  uninitialized,
  authenticating,
  authenticated,
  unauthenticated
}

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  String? _token;
  AuthStatus _status = AuthStatus.uninitialized;

  AuthStatus get status => _status;
  String? get token => _token;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> loginWithInstagram() async {
    try {
      final data = await _authService.loginWithInstagram();
      if (data.containsKey('token')) {
        _token = data['token'];
        await _authService.saveToken(_token!);
        _status = AuthStatus.authenticated;
        notifyListeners();
      } else {
        _status = AuthStatus.unauthenticated;
        notifyListeners();
      }
    } catch (e) {
      print('Login failed: $e');
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _token = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    _status = AuthStatus.authenticating;
    notifyListeners();
    print(
        '[AuthProvider] tryAutoLogin started - Splash screen should be visible now');
    final start = DateTime.now();
    try {
      _token = await _authService.getToken().timeout(const Duration(seconds: 5),
          onTimeout: () {
        print('[AuthProvider] getToken timed out');
        return null;
      });
      print('[AuthProvider] Token from storage: $_token');
      if (_token != null) {
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e, stack) {
      print('[AuthProvider] Error in tryAutoLogin: ${e.toString()}');
      print(stack);
      _status = AuthStatus.unauthenticated;
      _token = null;
    }
    // Ensure splash is visible for at least 2 seconds
    final elapsed = DateTime.now().difference(start);
    if (elapsed < const Duration(seconds: 2)) {
      print(
          '[AuthProvider] Waiting ${2 - elapsed.inMilliseconds}ms to ensure splash visibility');
      await Future.delayed(const Duration(seconds: 2) - elapsed);
    }
    print(
        '[AuthProvider] tryAutoLogin finished, status: $_status - Splash screen will disappear now');
    notifyListeners();
  }

  Future<void> loginWithEmail(String email, String password) async {
    try {
      final data = await _authService.loginWithEmail(email, password);
      if (data.containsKey('token')) {
        _token = data['token'];
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      rethrow;
    }
    notifyListeners();
  }

  Future<void> register(String name, String email, String password) async {
    try {
      final data =
          await _authService.register(name, email, password);
      if (data.containsKey('token')) {
        _token = data['token'];
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      print('Registration failed: $e');
      _status = AuthStatus.unauthenticated;
      rethrow;
    }
    notifyListeners();
  }

  Future<void> loginWithFacebook() async {
    try {
      final data = await _authService.loginWithFacebook();
      if (data.containsKey('token')) {
        _token = data['token'];
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      print('Facebook login failed: $e');
      _status = AuthStatus.unauthenticated;
      rethrow;
    }
    notifyListeners();
  }
}
