import 'package:cloud_firestore/cloud_firestore.dart';

class QueryModel {
  final String userId;
  final String title;
  final String description;
  final Timestamp createdAt;
  final String? adminId;

  QueryModel({
    required this.userId,
    required this.title,
    required this.description,
    required this.createdAt,
    this.adminId,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'adminId': adminId ?? "",
    };
  }
}
