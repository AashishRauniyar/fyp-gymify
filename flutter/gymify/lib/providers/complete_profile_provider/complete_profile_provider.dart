import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:gymify/network/http.dart';
import 'package:gymify/models/api_response.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfileProvider with ChangeNotifier {
  // User details
  String _userName = '';
  String _fullName = '';
  String _phoneNumber = '';
  String _address = '';
  String _gender = '';
  String _birthdate = '';
  double _height = 0.0;
  double _weight = 0.0;
  String _fitnessLevel = '';
  String _goalType = '';
  String _allergies = '';
  String _calorieGoals = '';
  String _cardNumber = '';
  File? _profileImage;

  // Error states
  String? _userNameError;
  String? _phoneNumberError;
  String? _generalError;
  
  // Loading state
  bool _isLoading = false;
  bool _isSubmitting = false;
  
  // Current page index for PageView
  int _currentPageIndex = 0;

  // Getters
  String get userName => _userName;
  String get fullName => _fullName;
  String get phoneNumber => _phoneNumber;
  String get address => _address;
  String get gender => _gender;
  String get birthdate => _birthdate;
  double get height => _height;
  double get weight => _weight;
  String get fitnessLevel => _fitnessLevel;
  String get goalType => _goalType;
  String get allergies => _allergies;
  String get calorieGoals => _calorieGoals;
  String get cardNumber => _cardNumber;
  File? get profileImage => _profileImage;
  
  String? get userNameError => _userNameError;
  String? get phoneNumberError => _phoneNumberError;
  String? get generalError => _generalError;
  
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  
  int get currentPageIndex => _currentPageIndex;

  // Setters with validation
  void setUserName(String value) async {
    _userName = value;
    if (value.isNotEmpty) {
      _userNameError = await checkUserNameAvailability(value);
    } else {
      _userNameError = 'Username cannot be empty';
    }
    notifyListeners();
  }

  void setFullName(String value) {
    _fullName = value;
    notifyListeners();
  }

  void setPhoneNumber(String value) async {
    _phoneNumber = value;
    if (value.isNotEmpty) {
      _phoneNumberError = await checkPhoneNumberAvailability(value);
    } else {
      _phoneNumberError = 'Phone number cannot be empty';
    }
    notifyListeners();
  }

  void setAddress(String value) {
    _address = value;
    notifyListeners();
  }

  void setGender(String value) {
    _gender = value;
    notifyListeners();
  }

  void setBirthdate(String value) {
    _birthdate = value;
    notifyListeners();
  }

  void setHeight(double value) {
    _height = value;
    notifyListeners();
  }

  void setWeight(double value) {
    _weight = value;
    notifyListeners();
  }

  void setFitnessLevel(String value) {
    _fitnessLevel = value;
    notifyListeners();
  }

  void setGoalType(String value) {
    _goalType = value;
    notifyListeners();
  }

  void setAllergies(String value) {
    _allergies = value;
    notifyListeners();
  }

  void setCalorieGoals(String value) {
    _calorieGoals = value;
    notifyListeners();
  }

  void setCardNumber(String value) {
    _cardNumber = value;
    notifyListeners();
  }

  void setProfileImage(File? file) {
    _profileImage = file;
    notifyListeners();
  }

  void setCurrentPageIndex(int index) {
    _currentPageIndex = index;
    notifyListeners();
  }

  // Check if username is available
  Future<String?> checkUserNameAvailability(String userName) async {
    if (userName.isEmpty) return 'Username cannot be empty';
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final response = await httpClient.post(
        '/check-username',
        data: {'user_name': userName},
      );
      
      final apiResponse = ApiResponse<void>.fromJson(
        response.data,
        (data) => null,
      );
      
      _isLoading = false;
      notifyListeners();
      
      if (apiResponse.status == 'failure') {
        return 'Username already exists';
      }
      return null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'Error checking username';
    }
  }

  // Check if phone number is available
  Future<String?> checkPhoneNumberAvailability(String phoneNumber) async {
    if (phoneNumber.isEmpty) return 'Phone number cannot be empty';
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final response = await httpClient.post(
        '/check-phone-number',
        data: {'phone_number': phoneNumber},
      );
      
      final apiResponse = ApiResponse<void>.fromJson(
        response.data,
        (data) => null,
      );
      
      _isLoading = false;
      notifyListeners();
      
      if (apiResponse.status == 'failure') {
        return 'Phone number already exists';
      }
      return null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'Error checking phone number';
    }
  }

  // Method to pick profile image from gallery
  Future<void> pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      _profileImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  // Method to determine content type for image upload
  ContentType getContentType(File file) {
    final fileName = file.path.toLowerCase();
    if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg')) {
      return ContentType.parse('image/jpeg');
    } else if (fileName.endsWith('.png')) {
      return ContentType.parse('image/png');
    } else {
      return ContentType.parse('application/octet-stream');
    }
  }

  // Submit the completed profile
  Future<Map<String, dynamic>> submitProfile(String email) async {
    if (_profileImage == null) {
      return {
        'success': false,
        'message': 'Profile image is required'
      };
    }
    
    _isSubmitting = true;
    _generalError = null;
    notifyListeners();
    
    try {
      FormData formData = FormData.fromMap({
        'email': email,
        'user_name': _userName,
        'full_name': _fullName,
        'phone_number': _phoneNumber,
        'address': _address,
        'gender': _gender,
        'birthdate': _birthdate,
        'height': _height.toString(),
        'current_weight': _weight.toString(),
        'fitness_level': _fitnessLevel,
        'goal_type': _goalType,
        'allergies': _allergies,
        'calorie_goals': _calorieGoals,
        'card_number': _cardNumber,
        'profile_image': await MultipartFile.fromFile(
          _profileImage!.path,
          filename: 'profile_image.jpg',
        ),
      });
      
      final response = await httpClient.post(
        '/complete-profile',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );
      
      _isSubmitting = false;
      notifyListeners();
      
      if (apiResponse.status == 'success') {
        return {
          'success': true,
          'message': 'Profile completed successfully',
          'data': apiResponse.data
        };
      } else {
        _generalError = apiResponse.message;
        return {
          'success': false,
          'message': apiResponse.message
        };
      }
    } catch (e) {
      _isSubmitting = false;
      _generalError = 'Error submitting profile: $e';
      notifyListeners();
      
      return {
        'success': false,
        'message': 'Error submitting profile: $e'
      };
    }
  }

  // Reset all fields
  void reset() {
    _userName = '';
    _fullName = '';
    _phoneNumber = '';
    _address = '';
    _gender = '';
    _birthdate = '';
    _height = 0.0;
    _weight = 0.0;
    _fitnessLevel = '';
    _goalType = '';
    _allergies = '';
    _calorieGoals = '';
    _cardNumber = '';
    _profileImage = null;
    
    _userNameError = null;
    _phoneNumberError = null;
    _generalError = null;
    
    _isLoading = false;
    _isSubmitting = false;
    _currentPageIndex = 0;
    
    notifyListeners();
  }
}