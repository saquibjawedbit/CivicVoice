import 'dart:convert';
import 'dart:io' show File, Platform;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:civic_voice/services/token_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class ApiClient {
  // Dynamically determine the base URL based on platform and environment
  static String get baseUrl {
    // If running on Android emulator
    if (Platform.isAndroid && !kReleaseMode) {
      return 'http://10.0.2.2:5000/api'; // Android emulator localhost
    }
    // If running on iOS simulator
    else if (Platform.isIOS && !kReleaseMode) {
      return 'http://localhost:5000'; // iOS simulator localhost
    }
    // For real devices or production mode
    else {
      // Replace with your production API URL
      return 'https://yourproductionapiurl.com';
      // For development on real device, you would use your computer's actual IP
      // Example: return 'http://192.168.1.10:5000';
    }
  }

  // Variable to store temporary token for specific requests
  static String? _customHeaderToken;

  // Get the stored token
  static Future<String?> getToken() async {
    return await TokenStorage.getToken();
  }

  // Store the token
  static Future<void> setToken(String token) async {
    await TokenStorage.saveToken(token);
  }

  // Clear the token on logout
  static Future<void> clearToken() async {
    await TokenStorage.clearToken();
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
      final message = errorMap['message'] ?? 'Error ${response.statusCode}';
      debugPrint('API Error Response: ${response.body}');
      return message;
    } catch (e) {
      debugPrint('Error parsing API error response: $e');
      return 'Error ${response.statusCode}: ${response.reasonPhrase}';
    }
  }

  // POST request
  static Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final headers = await _getHeaders();
      final url = Uri.parse('$baseUrl$endpoint');
      debugPrint('Making POST request to: $url');

      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(data),
      );

      debugPrint('Response status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json.decode(response.body);
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      debugPrint('API POST Error: $e');
      if (e is FormatException) {
        throw 'Failed to connect to the server. Please check your internet connection.';
      }
      rethrow;
    }
  }

  // GET request
  static Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final headers = await _getHeaders();
      final url = Uri.parse('$baseUrl$endpoint');
      debugPrint('Making GET request to: $url');

      final response = await http.get(
        url,
        headers: headers,
      );

      debugPrint('Response status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json.decode(response.body);
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      debugPrint('API GET Error: $e');
      if (e is FormatException) {
        throw 'Failed to connect to the server. Please check your internet connection.';
      }
      rethrow;
    }
  }

  // POST multipart form data with file upload
  static Future<Map<String, dynamic>> postFormData(
      String endpoint, Map<String, dynamic> fields, List<File> files,
      {List<String> fileFieldNames = const ['image']}) async {
    try {
      final headers = await _getHeaders();
      // Remove the Content-Type header as it will be set by the multipart request
      headers.remove('Content-Type');

      final url = Uri.parse('$baseUrl$endpoint');
      debugPrint('Making POST form data request to: $url');

      final request = http.MultipartRequest('POST', url);

      // Add headers
      request.headers.addAll(headers);

      // Add text fields
      fields.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add files
      for (int i = 0; i < files.length; i++) {
        final file = files[i];
        final fileName = basename(file.path);
        // Use the provided field name or default to 'image'
        final fieldName =
            i < fileFieldNames.length ? fileFieldNames[i] : 'image';

        // Determine content type based on file extension
        final fileExtension = fileName.split('.').last.toLowerCase();
        String contentType = 'application/octet-stream';
        String subtype = 'octet-stream';

        if (['jpg', 'jpeg'].contains(fileExtension)) {
          contentType = 'image/jpeg';
          subtype = 'jpeg';
        } else if (fileExtension == 'png') {
          contentType = 'image/png';
          subtype = 'png';
        } else if (fileExtension == 'gif') {
          contentType = 'image/gif';
          subtype = 'gif';
        }

        final fileStream = http.ByteStream(file.openRead());
        final fileLength = await file.length();

        final multipartFile = http.MultipartFile(
          fieldName,
          fileStream,
          fileLength,
          filename: fileName,
          contentType: MediaType.parse(contentType).change(subtype: subtype),
        );

        request.files.add(multipartFile);
      }

      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('Response status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json.decode(response.body);
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      debugPrint('API POST FormData Error: $e');
      if (e is FormatException) {
        throw 'Failed to connect to the server. Please check your internet connection.';
      }
      rethrow;
    }
  }

  // Check if user is authenticated by checking for a valid token
  static Future<bool> isAuthenticated() async {
    return await TokenStorage.hasValidToken();
  }
}
