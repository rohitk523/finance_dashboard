// lib/services/auth_service.dart

import 'package:dio/dio.dart';
import '../config/api_constants.dart';

class AuthService {
  final Dio _dio;

  AuthService(this._dio) {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  Future<bool> verifyToken(String token) async {
    try {
      final response = await _dio.get(
        ApiConstants.verifyToken,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('Attempting login with username: $email and password: $password');

      // Add logging interceptor temporarily
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ));

      final response = await _dio.post(
        ApiConstants.login,
        data: FormData.fromMap({
          'username': email,
          'password': password,
        }),
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
        ),
      );

      print('Login response status: ${response.statusCode}');
      print('Login response data: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data == null) {
          print('WARNING: Response data is null despite 200 status code');
          throw Exception('Server returned empty response');
        }
        return response.data;
      } else {
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.type}');
      print('Error message: ${e.message}');
      print('Response data: ${e.response?.data}');
      print('Status code: ${e.response?.statusCode}');

      if (e.response != null) {
        throw Exception(e.response?.data['message'] ??
            'Login failed with status ${e.response?.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Login failed: $e');
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        },
      );

      if (response.statusCode != 201) {
        throw Exception('Registration failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Registration failed');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> logout(String? token) async {
    if (token == null) return;

    try {
      await _dio.post(
        ApiConstants.logout,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      // Even if logout fails, we'll clear the token locally
      // So just log the error
      print('Logout error: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      final response = await _dio.post(
        ApiConstants.resetPassword,
        data: {
          'email': email,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Reset password failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Reset password failed');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Reset password failed: $e');
    }
  }

  Future<Map<String, dynamic>> updateProfile(
      String token, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(
        ApiConstants.updateProfile,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['user'];
      } else {
        throw Exception('Profile update failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Profile update failed');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Profile update failed: $e');
    }
  }

  Future<void> changePassword(
      String token, String currentPassword, String newPassword) async {
    try {
      final response = await _dio.post(
        ApiConstants.changePassword,
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Password change failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            e.response?.data['message'] ?? 'Password change failed');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Password change failed: $e');
    }
  }
}
