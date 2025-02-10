class Complaint {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime timestamp;
  final List<String> imageUrls;
  final String status;

  Complaint({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.imageUrls,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'timestamp': timestamp,
      'imageUrls': imageUrls,
      'status': status,
    };
  }
}
