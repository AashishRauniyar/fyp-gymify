import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gymify/network/http.dart';
// Import your http.dart configuration

class AuthService {
  /// Register a new user
  Future<Map<String, dynamic>> registerUser({
    required String userName,
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required String address,
    required String gender,
    required String role,
    required String fitnessLevel,
    required String goalType,
    required int age,
    required double height,
    required double weight,
    required String calorieGoals,
    required String cardNumber,
    required String allergies,
    File? profilePicture,
  }) async {
    try {
      // If there's a profile picture, ensure it is properly encoded
      if (profilePicture != null) {
        profilePicture = await reEncodeImage(profilePicture);
      }

      // Create the form data
      final formData = FormData.fromMap({
        'user_name': userName,
        'full_name': fullName,
        'email': email,
        'password': password,
        'phone_number': phoneNumber,
        'address': address,
        'gender': gender,
        'role': role,
        'fitness_level': fitnessLevel,
        'goal_type': goalType,
        'age': age.toString(),
        'height': height.toString(),
        'weight': weight.toString(),
        'calorie_goals': calorieGoals,
        'card_number': cardNumber,
        'allergies': allergies,
        'current_weight': weight.toString(),
        if (profilePicture != null)
          'profile_image': await MultipartFile.fromFile(
            profilePicture.path,
            filename: 'profile_image.jpeg',
            contentType: getContentType(profilePicture),
          ),
      });

      // Send the request
      Response response = await httpClient.post('/register',
          options: Options(
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'multipart/form-data',
            },
          ),
          data: formData);

      if (response.statusCode == 201) {
        return {'success': true, 'data': response.data};
      } else {
        return {'success': false, 'message': response.data['message']};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
