class UserModel {
  final int userId;
  final String userName;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final int age;
  final double height;
  final double currentWeight;
  final String gender;
  final String role;
  final String fitnessLevel;
  final String goalType;
  final String allergies;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.userId,
    required this.userName,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.age,
    required this.height,
    required this.currentWeight,
    required this.gender,
    required this.role,
    required this.fitnessLevel,
    required this.goalType,
    required this.allergies,
    this.profileImage,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      userName: json['user_name'],
      fullName: json['full_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      age: json['age'],
      height: double.parse(json['height'].toString()),
      currentWeight: double.parse(json['current_weight'].toString()),
      gender: json['gender'],
      role: json['role'],
      fitnessLevel: json['fitness_level'],
      goalType: json['goal_type'],
      allergies: json['allergies'],
      profileImage: json['profile_image'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Method to convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
      'age': age,
      'height': height.toString(),
      'current_weight': currentWeight.toString(),
      'gender': gender,
      'role': role,
      'fitness_level': fitnessLevel,
      'goal_type': goalType,
      'allergies': allergies,
      'profile_image': profileImage,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
