import 'package:cloud_firestore/cloud_firestore.dart';

class ComplainModel {
  final String? id;
  final String title;
  final String description;
  final String category;
  final DateTime complaintDate;
  final String address;
  final String? landMark;
  final String imageUrl;
  final int status;
  final DateTime? resolvedDate;
  final String userId;
  final DocumentReference? adminId;

  ComplainModel({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.complaintDate,
    required this.address,
    this.landMark,
    required this.imageUrl,
    required this.userId,
    this.adminId,
    this.resolvedDate,
    this.status = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'complaintDate': complaintDate.toIso8601String(),
      'address': address,
      'landMark': landMark,
      'imageUrl': imageUrl,
      'status': status,
      'resolvedDate': resolvedDate?.toIso8601String(),
      'userId': userId,
      'adminId': adminId,
    };
  }
}
