import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

/// A service for storing and retrieving authentication tokens securely
class TokenStorage {
  static const String tokenKey = 'auth_token';
  static const String tokenExpiryKey = 'auth_token_expiry';

  /// Store the authentication token and its expiry date
  static Future<void> saveToken(String token, {int expiryInDays = 30}) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save token
      await prefs.setString(tokenKey, token);

      // Save expiry date (current time + expiryInDays)
      final expiryDate = DateTime.now()
          .add(Duration(days: expiryInDays))
          .millisecondsSinceEpoch;
      await prefs.setInt(tokenExpiryKey, expiryDate);

      debugPrint('Token saved successfully with expiry in $expiryInDays days');
    } catch (e) {
      debugPrint('Error saving token: $e');
      rethrow;
    }
  }

  /// Get the stored authentication token
  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(tokenKey);

      // Check if token exists and is still valid
      if (token != null) {
        final expiryTimestamp = prefs.getInt(tokenExpiryKey);
        if (expiryTimestamp != null) {
          final expiryDate =
              DateTime.fromMillisecondsSinceEpoch(expiryTimestamp);
          if (DateTime.now().isAfter(expiryDate)) {
            // Token has expired, clear it
            debugPrint('Token has expired, clearing it');
            await clearToken();
            return null;
          }
        }
      }

      return token;
    } catch (e) {
      debugPrint('Error retrieving token: $e');
      return null;
    }
  }

  /// Clear the stored authentication token
  static Future<void> clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(tokenKey);
      await prefs.remove(tokenExpiryKey);
      debugPrint('Token cleared successfully');
    } catch (e) {
      debugPrint('Error clearing token: $e');
      rethrow;
    }
  }

  /// Check if a token exists and is valid
  static Future<bool> hasValidToken() async {
    final token = await getToken();
    return token != null;
  }

  /// Update expiry date of existing token
  static Future<void> refreshTokenExpiry({int expiryInDays = 30}) async {
    try {
      final token = await getToken();
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        final expiryDate = DateTime.now()
            .add(Duration(days: expiryInDays))
            .millisecondsSinceEpoch;
        await prefs.setInt(tokenExpiryKey, expiryDate);
        debugPrint('Token expiry refreshed for $expiryInDays days');
      }
    } catch (e) {
      debugPrint('Error refreshing token expiry: $e');
      rethrow;
    }
  }
}
