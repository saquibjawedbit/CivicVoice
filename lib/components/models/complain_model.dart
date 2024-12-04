import 'package:cloud_firestore/cloud_firestore.dart';

class ComplainModel {
  final String? id;
  final String title;
  final String description;
  final String category;
  final Timestamp complaintDate;
  final String address;
  final String? landMark;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final int status;
  final Timestamp? resolvedDate;
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
    required this.latitude,
    required this.longitude,
    this.adminId,
    this.resolvedDate,
    this.status = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'complaintDate': complaintDate,
      'address': address,
      'landMark': landMark,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'status': status,
      'resolvedDate': resolvedDate,
      'userId': userId,
      'adminId': adminId,
    };
  }

  // Factory method to create an instance from a map
  factory ComplainModel.fromMap(Map<String, dynamic> map, String? documentId) {
    return ComplainModel(
      id: documentId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      complaintDate: (map['complaintDate'] as Timestamp),
      address: map['address'] ?? '',
      landMark: map['landMark'],
      imageUrl: map['imageUrl'] ?? '',
      status: map['status'] ?? 0,
      resolvedDate: map['resolvedDate'] != null
          ? (map['resolvedDate'] as Timestamp)
          : null,
      userId: map['userId'] ?? '',
      adminId: map['adminId'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}
