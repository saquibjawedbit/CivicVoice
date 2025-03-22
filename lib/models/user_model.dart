class UserModel {
  String? id;
  String email;
  String? password;
  String? phoneNumber;
  String? name;
  int complaintCount;

  UserModel({
    this.id,
    required this.email,
    this.password,
    this.phoneNumber,
    this.name,
    this.complaintCount = 0,
  });

  // Convert UserModel to a map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'name': name,
      'complaintCount': complaintCount,
    };
  }

  // Factory constructor to create a UserModel instance from a map
  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      id: uid, // Assuming the 'id' field is also in the map
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      name: map['name'],
      complaintCount: map['complaintCount'] ?? 0,
    );
  }
}
