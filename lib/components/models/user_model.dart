class UserModel {
  String? id;
  String? email;
  String phoneNumber;
  String? name;
  int complaintCount;

  UserModel({
    this.id,
    this.email,
    required this.phoneNumber,
    this.name,
    this.complaintCount = 0,
  });

  // Convert UserModel to a map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'phoneNumber': phoneNumber,
      'name': name,
      'complaintCount': complaintCount,
    };
  }
}
