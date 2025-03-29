class ComplainModel {
  final String? id;
  final String title;
  final String description;
  final String category;
  final DateTime complaintDate;
  final String address;
  final String? landMark;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final int status;
  final DateTime? resolvedDate;
  final String userId;
  final String? adminId;

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
      'address': processAddress(address),
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

  static List<String> processAddress(String address) {
    // Use RegExp to remove punctuation and split by spaces
    return address
        .toLowerCase() // Convert to lowercase
        .replaceAll(RegExp(r'[^\w\s]'), '') // Remove punctuation
        .split(' ') // Split by spaces
        .where((word) => word.isNotEmpty) // Remove empty strings
        .toList();
  }

  static String convertTokensToAddress(List<dynamic> tokens) {
    return tokens.where((word) => word.isNotEmpty).join(' ');
  }

  // Factory method to create an instance from a map
  factory ComplainModel.fromMap(Map<String, dynamic> map, String? documentId) {
    // Handle address properly - might be a string or list of tokens
    String add = map['address'] is List
        ? convertTokensToAddress(map['address'])
        : map['address'] ?? '';

    // Parse the complaint date
    DateTime complaintDate;
    if (map['complaintDate'] is DateTime) {
      complaintDate = map['complaintDate'];
    } else if (map['complaintDate'] is String) {
      complaintDate = DateTime.parse(map['complaintDate']);
    } else if (map['complaintDate'] is int) {
      complaintDate = DateTime.fromMillisecondsSinceEpoch(map['complaintDate']);
    } else {
      complaintDate = DateTime.now(); // Fallback
    }

    // Parse the resolved date if present
    DateTime? resolvedDate;
    if (map['resolvedDate'] != null) {
      if (map['resolvedDate'] is DateTime) {
        resolvedDate = map['resolvedDate'];
      } else if (map['resolvedDate'] is String) {
        try {
          resolvedDate = DateTime.parse(map['resolvedDate']);
        } catch (_) {
          resolvedDate = null;
        }
      } else if (map['resolvedDate'] is int) {
        resolvedDate = DateTime.fromMillisecondsSinceEpoch(map['resolvedDate']);
      }
    }

    // Parse latitude and longitude
    double latitude;
    if (map['latitude'] is double) {
      latitude = map['latitude'];
    } else if (map['latitude'] is String) {
      latitude = double.tryParse(map['latitude']) ?? 0.0;
    } else if (map['latitude'] is int) {
      latitude = (map['latitude'] as int).toDouble();
    } else {
      latitude = 0.0;
    }

    double longitude;
    if (map['longitude'] is double) {
      longitude = map['longitude'];
    } else if (map['longitude'] is String) {
      longitude = double.tryParse(map['longitude']) ?? 0.0;
    } else if (map['longitude'] is int) {
      longitude = (map['longitude'] as int).toDouble();
    } else {
      longitude = 0.0;
    }

    return ComplainModel(
      id: documentId ?? map['id']?.toString(),
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      complaintDate: complaintDate,
      address: add,
      landMark: map['landMark'] ?? map['landmark'],
      imageUrl: map['imageUrl'] ?? map['image_url'] ?? '',
      status: map['status'] is int
          ? map['status']
          : int.tryParse(map['status']?.toString() ?? '0') ?? 0,
      resolvedDate: resolvedDate,
      userId: map['userId'] ?? '',
      adminId: map['adminId'],
      latitude: latitude,
      longitude: longitude,
    );
  }
}
