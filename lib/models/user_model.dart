class UserModel {
  final String id;
  final String email;
  final String name;
  final String phone;
  final UserRole role;
  final String? photoUrl;
  final double civicScore;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.role,
    this.photoUrl,
    this.civicScore = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role.toString(),
      'photoUrl': photoUrl,
      'civicScore': civicScore,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      name: map['name'],
      phone: map['phone'],
      role: _parseUserRole(map['role']),
      photoUrl: map['photoUrl'],
      civicScore: map['civicScore']?.toDouble() ?? 0,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  static UserRole _parseUserRole(String? roleString) {
    if (roleString == null) return UserRole.citizen;

    // Handle both formats: "UserRole.admin" and "admin"
    String cleanRole = roleString.replaceAll('UserRole.', '');

    switch (cleanRole.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'staffmanager':
      case 'staff_manager':
        return UserRole.staffManager;
      case 'citizen':
      default:
        return UserRole.citizen;
    }
  }
}

enum UserRole { citizen, admin, staffManager }