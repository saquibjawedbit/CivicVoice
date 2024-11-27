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

  ComplainModel({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.complaintDate,
    required this.address,
    required this.landMark,
    required this.imageUrl,
    this.resolvedDate,
    this.status = 0,
  });
}
