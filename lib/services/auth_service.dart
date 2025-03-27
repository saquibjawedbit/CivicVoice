import 'package:flutter/foundation.dart';
import 'package:civic_voice/services/api_client.dart';
import 'package:civic_voice/services/token_storage.dart';

class AuthService {
  static const String allowedDomain = 'bitmesra.ac.in';

  // Signup API endpoint
  Future<Map<String, dynamic>> signup(
      String name, String email, String password) async {
    try {
      final response = await ApiClient.post('/auth/signup', {
        'name': name,
        'email': email,
        'password': password,
      });

      // Store token if provided in the response
      if (response.containsKey('token')) {
        await TokenStorage.saveToken(response['token']);
      }

      return response;
    } catch (e) {
      debugPrint('Signup error: $e');
      rethrow;
    }
  }

  // Login API endpoint
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await ApiClient.post('/auth/login', {
        'email': email,
        'password': password,
      });

      // Store token if provided in the response
      if (response.containsKey('token')) {
        await TokenStorage.saveToken(response['token']);
      }

      return response;
    } catch (e) {
      debugPrint('Login error: $e');
      rethrow;
    }
  }

  // Forgot password API endpoint
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await ApiClient.post('/auth/forgot-password', {
        'email': email,
      });

      return response;
    } catch (e) {
      debugPrint('Forgot password error: $e');
      rethrow;
    }
  }

  // Get current user info
  Future<Map<String, dynamic>> getMe() async {
    try {
      final response = await ApiClient.get('/auth/me');
      // Refresh token expiry on successful me request
      await TokenStorage.refreshTokenExpiry();
      return response;
    } catch (e) {
      debugPrint('Get user info error: $e');
      rethrow;
    }
  }

  // Verify OTP
  Future<Map<String, dynamic>> verifyOTP(String otp, {String? token}) async {
    try {
      // Set custom token for this request if provided
      if (token != null) {
        await ApiClient.setCustomHeaderToken(token);
      }

      final response = await ApiClient.post('/auth/verify-otp', {
        'otp': otp,
      });

      // Store or update token if provided in the response
      if (response.containsKey('token')) {
        await TokenStorage.saveToken(response['token']);
      }

      // Clear custom token header after request
      if (token != null) {
        await ApiClient.clearCustomHeaderToken();
      }

      return response;
    } catch (e) {
      // Clear custom token header in case of error
      if (token != null) {
        await ApiClient.clearCustomHeaderToken();
      }
      debugPrint('Verify OTP error: $e');
      rethrow;
    }
  }

  // Resend OTP
  Future<Map<String, dynamic>> resendOTP({String? token}) async {
    try {
      // Set custom token for this request if provided
      if (token != null) {
        await ApiClient.setCustomHeaderToken(token);
      }

      final response = await ApiClient.post('/resend-otp', {});

      // Clear custom token header after request
      if (token != null) {
        await ApiClient.clearCustomHeaderToken();
      }

      return response;
    } catch (e) {
      // Clear custom token header in case of error
      if (token != null) {
        await ApiClient.clearCustomHeaderToken();
      }
      debugPrint('Resend OTP error: $e');
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await ApiClient.get('/logout');
      await TokenStorage.clearToken();
    } catch (e) {
      debugPrint('Logout error: $e');
      rethrow;
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return await TokenStorage.hasValidToken();
  }
}
