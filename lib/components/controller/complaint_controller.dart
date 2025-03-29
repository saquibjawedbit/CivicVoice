import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:civic_voice/services/complaint_service.dart';

class ComplaintController extends GetxController {
  // Services
  final ComplaintService _complaintService = ComplaintService();

  // State variables
  var isLoading = false.obs;
  var complaints = <Map<String, dynamic>>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserComplaints();
  }

  // Post a new complaint with an image
  Future<bool> postComplaint({
    required String title,
    required String description,
    required String location,
    required String category,
    required File imageFile,
    required String landmark,
    String? latitude,
    String? longitude,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _complaintService.postComplaint(
        title: title,
        description: description,
        location: location,
        landmark: landmark,
        category: category,
        imageFile: imageFile,
        latitude: latitude,
        longitude: longitude,
      );

      // After successfully posting a complaint, refresh the list
      await fetchUserComplaints();

      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint('Error posting complaint: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Get all complaints for the current user
  Future<void> fetchUserComplaints() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final fetchedComplaints = await _complaintService.getUserComplaints();
      complaints.assignAll(fetchedComplaints);
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint('Error fetching user complaints: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Get a specific complaint by ID
  Future<Map<String, dynamic>?> getComplaintDetails(String complaintId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final complaintDetails =
          await _complaintService.getComplaintById(complaintId);
      return complaintDetails;
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint('Error getting complaint details: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
