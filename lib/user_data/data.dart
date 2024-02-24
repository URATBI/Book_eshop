class UserData {
  final String userId;
  final String email;
  final String name;
  final String rollNumber;
  final String department;

  UserData({
    required this.userId,
    required this.email,
    required this.name,
    required this.rollNumber,
    required this.department,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'rollNumber': rollNumber,
      'department': department,
    };
  }
}
