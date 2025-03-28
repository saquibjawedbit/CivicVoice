import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:civic_voice/services/api_client.dart';

class ComplaintService {
  // Post a complaint with an image
  Future<Map<String, dynamic>> postComplaint({
    required String title,
    required String description,
    required String location,
    required String category,
    required File imageFile,
    String? latitude,
    String? longitude,
  }) async {
    try {
      // Prepare the data fields
      final fields = {
        'title': title,
        'description': description,
        'location': location,
        'category': category,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      };

      debugPrint('Posting complaint with fields: $fields');

      // Make the API request with the image file
      final response = await ApiClient.postFormData(
        '/complaints',
        fields,
        [imageFile],
        fileFieldNames: ['image'],
      );

      return response;
    } catch (e) {
      debugPrint('Post complaint error: $e');
      rethrow;
    }
  }

  // Get all complaints for the current user
  Future<List<Map<String, dynamic>>> getUserComplaints() async {
    try {
      final response = await ApiClient.get('/complaints/user');

      // Check if the response has the correct format
      if (response.containsKey('complaints') &&
          response['complaints'] is List) {
        return List<Map<String, dynamic>>.from(response['complaints']);
      }

      return [];
    } catch (e) {
      debugPrint('Get user complaints error: $e');
      return [];
    }
  }

  // Get a specific complaint by ID
  Future<Map<String, dynamic>?> getComplaintById(String complaintId) async {
    try {
      final response = await ApiClient.get('/complaints/$complaintId');
      return response;
    } catch (e) {
      debugPrint('Get complaint by ID error: $e');
      return null;
    }
  }
}
