import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gymify/network/http.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:flutter/material.dart';

class AuthService {
  Future<bool> checkUsername(String username) async {
    try {
      final response = await httpClient
          .post('/auth/check-username', data: {'user_name': username});
      return response.data['status'] == 'success';
    } catch (e) {
      throw 'Error checking username: $e';
    }
  }

  Future<bool> checkEmail(String email) async {
    try {
      final response =
          await httpClient.post('/auth/check-email', data: {'email': email});
      return response.data['status'] == 'success';
    } catch (e) {
      throw 'Error checking email: $e';
    }
  }

  Future<bool> checkPhoneNumber(String phoneNumber) async {
    try {
      final response = await httpClient.post('/auth/check-phone-number',
          data: {'phone_number': phoneNumber});
      return response.data['status'] == 'success';
    } catch (e) {
      throw 'Error checking phone number: $e';
    }
  }

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
    required String birthdate, 
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
        'birthdate':
            birthdate, // Send birthdate directly as a string (in the format 'YYYY-MM-DD')
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
      Response response = await httpClient.post('/auth/register',
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

// Example DatePicker Widget
class DatePickerWidget extends StatelessWidget {
  final Function(String) onDateSelected;

  const DatePickerWidget({super.key, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (selectedDate != null) {
          final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
          onDateSelected(formattedDate); // Return selected date as 'YYYY-MM-DD'
        }
      },
      child: const Text('Select Birthdate'),
    );
  }
}
