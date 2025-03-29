class ComplainModel {
  final String? id;
  final String title;
  final String description;
  final String category;
  final DateTime complaintDate; // createdAt in the backend
  final String address;
  final String? landMark; // landmark in the backend
  final String? imageUrl; // image.url in the backend
  final double latitude; // location.coordinates[1] in the backend
  final double longitude; // location.coordinates[0] in the backend
  final String status; // progress in the backend
  final DateTime? updatedAt;
  final String userId;
  final String? employeeId; // instead of adminId in previous version

  ComplainModel({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.complaintDate,
    required this.address,
    this.landMark,
    this.imageUrl,
    required this.userId,
    required this.latitude,
    required this.longitude,
    this.employeeId,
    this.updatedAt,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'createdAt': complaintDate,
      'address': address,
      'landmark': landMark,
      'location': {
        'type': 'Point',
        'coordinates': [
          longitude,
          latitude
        ], // [longitude, latitude] as per backend format
      },
      'image': {'url': imageUrl},
      'progress': status,
      'updatedAt': updatedAt,
      'userId': userId,
      'employeeId': employeeId,
    };
  }

  // Convert status string to numeric code for UI purposes
  int get statusCode {
    switch (status) {
      case 'pending':
        return 0;
      case 'in-progress':
        return 0; // Both pending and in-progress show as "Working on it!"
      case 'resolved':
        return 2;
      case 'rejected':
        return 1; // Rejected is treated as "Not Resolved" in UI
      default:
        return 0;
    }
  }

  // Factory method to create an instance from a map
  factory ComplainModel.fromMap(Map<String, dynamic> map, String? documentId) {
    // Handle address
    String address = map['address'] ?? '';

    // Handle complaint date (createdAt)
    DateTime complaintDate;
    if (map['createdAt'] is DateTime) {
      complaintDate = map['createdAt'];
    } else if (map['createdAt'] is String) {
      complaintDate = DateTime.parse(map['createdAt']);
    } else {
      complaintDate = DateTime.now(); // Fallback
    }

    // Handle updatedAt
    DateTime? updatedAt;
    if (map['updatedAt'] != null) {
      if (map['updatedAt'] is DateTime) {
        updatedAt = map['updatedAt'];
      } else if (map['updatedAt'] is String) {
        try {
          updatedAt = DateTime.parse(map['updatedAt']);
        } catch (_) {
          updatedAt = null;
        }
      }
    }

    // Handle location coordinates
    double latitude = 0.0;
    double longitude = 0.0;

    if (map['location'] != null &&
        map['location']['coordinates'] != null &&
        map['location']['coordinates'] is List &&
        map['location']['coordinates'].length >= 2) {
      // Backend format: [longitude, latitude]
      longitude = _parseCoordinate(map['location']['coordinates'][0]);
      latitude = _parseCoordinate(map['location']['coordinates'][1]);
    } else {
      // Fallbacks for direct properties if location object isn't present
      latitude = _parseCoordinate(map['latitude']);
      longitude = _parseCoordinate(map['longitude']);
    }

    // Handle image URL
    String? imageUrl;
    if (map['image'] != null && map['image']['url'] != null) {
      imageUrl = map['image']['url'];
    } else {
      imageUrl = map['imageUrl'] ?? map['image_url'] ?? '';
    }

    return ComplainModel(
      id: documentId ?? map['_id']?.toString() ?? map['id']?.toString(),
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      complaintDate: complaintDate,
      address: address,
      landMark: map['landmark'] ?? map['landMark'],
      imageUrl: imageUrl,
      status: map['progress'] ?? 'pending', // Use progress from backend
      updatedAt: updatedAt,
      userId: map['userId']?.toString() ?? '',
      employeeId: map['employeeId']?.toString(),
      latitude: latitude,
      longitude: longitude,
    );
  }

  // Helper method to parse coordinates safely
  static double _parseCoordinate(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
}
