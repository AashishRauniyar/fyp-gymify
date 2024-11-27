class User {
  final String id;
  final String userName;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final String gender;
  final String role;
  final String fitnessLevel;
  final String goalType;
  final int age;
  final double height;
  final double weight;
  final String calorieGoals;
  final String cardNumber;
  final String allergies;
  final String? profilePictureUrl;

  User({
    required this.id,
    required this.userName,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.gender,
    required this.role,
    required this.fitnessLevel,
    required this.goalType,
    required this.age,
    required this.height,
    required this.weight,
    required this.calorieGoals,
    required this.cardNumber,
    required this.allergies,
    this.profilePictureUrl,
  });

  // A factory method to create a User from a map (API response)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      userName: map['user_name'],
      fullName: map['full_name'],
      email: map['email'],
      phoneNumber: map['phone_number'],
      address: map['address'],
      gender: map['gender'],
      role: map['role'],
      fitnessLevel: map['fitness_level'],
      goalType: map['goal_type'],
      age: map['age'],
      height: map['height'],
      weight: map['weight'],
      calorieGoals: map['calorie_goals'],
      cardNumber: map['card_number'],
      allergies: map['allergies'],
      profilePictureUrl: map['profile_image'],
    );
  }

  // A method to convert User to a map (for request)
  Map<String, dynamic> toMap() {
    return {
      'user_name': userName,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
      'gender': gender,
      'role': role,
      'fitness_level': fitnessLevel,
      'goal_type': goalType,
      'age': age,
      'height': height,
      'weight': weight,
      'calorie_goals': calorieGoals,
      'card_number': cardNumber,
      'allergies': allergies,
      'profile_image': profilePictureUrl,
    };
  }
}
