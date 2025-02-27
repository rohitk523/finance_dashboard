// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;

  Map<String, dynamic>? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  AuthProvider(this._authService) {
    _checkToken();
  }

  // Getters
  Map<String, dynamic>? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  // Methods
  Future<void> _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('authToken');
    final storedUser = prefs.getString('user');

    if (storedToken != null && storedUser != null) {
      try {
        // Verify token with server
        final isValid = await _authService.verifyToken(storedToken);

        if (isValid) {
          _token = storedToken;
          _user = json.decode(storedUser);
          _isAuthenticated = true;
          notifyListeners();
        } else {
          // Token is invalid or expired, clear storage
          await _clearStoredAuth();
        }
      } catch (e) {
        // Error checking token, clear storage
        await _clearStoredAuth();
      }
    }
  }

  Future<void> _clearStoredAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('user');

    _token = null;
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _setLoading(true);

    try {
      final response = await _authService.login(email, password);

      _token = response['token'];
      _user = response['user'];
      _isAuthenticated = true;

      // Save to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', _token!);
      await prefs.setString('user', json.encode(_user));

      notifyListeners();
    } catch (e) {
      _setError('Login failed: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _setLoading(true);

    try {
      await _authService.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );

      // Note: Not setting authentication here as typically
      // registration doesn't automatically log you in
      notifyListeners();
    } catch (e) {
      _setError('Registration failed: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);

    try {
      await _authService.logout(_token);
      await _clearStoredAuth();
    } catch (e) {
      _setError('Logout failed: $e');

      // Even if server logout fails, clear local auth
      await _clearStoredAuth();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resetPassword(String email) async {
    _setLoading(true);

    try {
      await _authService.resetPassword(email);
      notifyListeners();
    } catch (e) {
      _setError('Password reset failed: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    _setLoading(true);

    try {
      final updatedUser = await _authService.updateProfile(_token!, data);
      _user = updatedUser;

      // Update stored user data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', json.encode(_user));

      notifyListeners();
    } catch (e) {
      _setError('Profile update failed: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    _setLoading(true);

    try {
      await _authService.changePassword(_token!, currentPassword, newPassword);
      notifyListeners();
    } catch (e) {
      _setError('Password change failed: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
