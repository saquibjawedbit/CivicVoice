import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadProfileImage(String userId, File imageFile) async {
    try {
      final ref = _storage.ref().child('profile_images/$userId.jpg');
      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<List<String>> uploadComplaintImages(
      String complaintId, List<File> images) async {
    try {
      List<String> downloadUrls = [];
      for (var i = 0; i < images.length; i++) {
        final ref =
            _storage.ref().child('complaint_images/$complaintId/image_$i.jpg');
        await ref.putFile(images[i]);
        final downloadUrl = await ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }
      return downloadUrls;
    } catch (e) {
      print('Error uploading complaint images: $e');
      return [];
    }
  }
}
