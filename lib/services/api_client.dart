import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static const String baseUrl =
      'http://localhost:5000'; // Replace with your actual API base URL
  static const String tokenKey = 'auth_token';

  // Variable to store temporary token for specific requests
  static String? _customHeaderToken;

  // Get the stored token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  // Store the token
  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  // Clear the token on logout
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  // Set a custom token for a specific request
  static Future<void> setCustomHeaderToken(String token) async {
    _customHeaderToken = token;
  }

  // Clear the custom token after request is complete
  static Future<void> clearCustomHeaderToken() async {
    _customHeaderToken = null;
  }

  // Headers with auth token
  static Future<Map<String, String>> _getHeaders() async {
    // Use custom token if available, otherwise use stored token
    String? token = _customHeaderToken;

    token ??= await getToken();

    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Error handler
  static String _handleError(http.Response response) {
    try {
      final errorMap = json.decode(response.body);
      return errorMap['message'] ?? 'Error ${response.statusCode}';
    } catch (e) {
      return 'Error ${response.statusCode}: ${response.reasonPhrase}';
    }
  }

  // POST request
  static Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json.decode(response.body);
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      debugPrint('API Error: $e');
      rethrow;
    }
  }

  // GET request
  static Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json.decode(response.body);
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      debugPrint('API Error: $e');
      rethrow;
    }
  }
}
