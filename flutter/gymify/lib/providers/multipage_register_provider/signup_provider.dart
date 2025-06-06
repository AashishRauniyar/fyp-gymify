import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:gymify/network/http.dart';

class SignupProvider with ChangeNotifier {
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _otp = '';
  bool _isOtpSent = false;
  bool _isVerified = false;
  bool _isLoading = false;
  String _error = '';

  // Getters
  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  String get otp => _otp;
  bool get isOtpSent => _isOtpSent;
  bool get isVerified => _isVerified;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Setters
  void setEmail(String email) {
    _email = email;
    clearError();
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    clearError();
    notifyListeners();
  }

  void setConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
    clearError();
    notifyListeners();
  }

  void setOtp(String otp) {
    _otp = otp;
    clearError();
    notifyListeners();
  }

  void setError(String error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clear() {
    _email = '';
    _password = '';
    _confirmPassword = '';
    _otp = '';
    _isOtpSent = false;
    _isVerified = false;
    _isLoading = false;
    _error = '';
    notifyListeners();
  }

  // Check if email exists
  Future<bool> checkEmailExists() async {
    setLoading(true);
    clearError();

    try {
      final response = await httpClient.post('/check-email', data: {
        'email': _email,
      });

      if (response.data['exists']) {
        if (response.data['verified']) {
          setError('Email is already registered and verified.');
          return true; // Email exists and verified
        } else {
          _isOtpSent = true;
          notifyListeners();
          return false; // Email exists but is not verified
        }
      }
      return false; // Email does not exist
    } on DioException catch (e) {
      setError(_handleDioError(e));
      return true;
    } finally {
      setLoading(false);
    }
  }

  // Register User
  Future<bool> register() async {
    if (!RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
        .hasMatch(_email)) {
      setError("Invalid email format");
      return false;
    }

    if (!RegExp(
            r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{8,}$")
        .hasMatch(_password)) {
      setError(
          "Password must contain at least 8 characters, one uppercase, one lowercase, a number, and a special character.");
      return false;
    }

    if (_password != _confirmPassword) {
      setError("Passwords do not match.");
      return false;
    }

    setLoading(true);
    clearError();

    try {
      final response = await httpClient.post('/auth/register', data: {
        'email': _email,
        'password': _password,
      });

      if (response.data['status'] == 'success') {
        _isOtpSent = true;
        if (response.data.containsKey('data') &&
            response.data['data'] != null) {
          _email = response.data['data']['email'];
        }
        notifyListeners();
        return true;
      } else {
        setError(response.data['message'] ?? 'Registration failed');
        return false;
      }
    } on DioException catch (e) {
      setError(_handleDioError(e));
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Verify OTP
  Future<bool> verifyOtp() async {
    if (_otp.isEmpty || _otp.length != 6) {
      setError('Please enter a valid OTP');
      return false;
    }

    setLoading(true);
    clearError();

    try {
      final response = await httpClient.post('/auth/verify-otp', data: {
        'email': _email,
        'otp': _otp,
      });

      if (response.data['status'] == 'success') {
        _isVerified = true;
        notifyListeners();
        return true;
      } else {
        setError(response.data['message'] ?? 'OTP verification failed');
        return false;
      }
    } on DioException catch (e) {
      setError(_handleDioError(e));
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Resend OTP
  Future<bool> resendOtp() async {
    if (_email.isEmpty) {
      setError('Email is required to resend OTP');
      return false;
    }

    setLoading(true);
    clearError();

    try {
      final response = await httpClient.post('/auth/resend-otp', data: {
        'email': _email,
      });

      if (response.data['status'] == 'success') {
        _isOtpSent = true;
        notifyListeners();
        return true;
      } else {
        setError(response.data['message'] ?? 'Failed to resend OTP');
        return false;
      }
    } on DioException catch (e) {
      setError(_handleDioError(e));
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Complete profile
  Future<bool> completeProfile({
    required String email,
    required String userName,
    required String fullName,
    required String phoneNumber,
    required String address,
    required String gender,
    required String birthdate,
    required double height,
    required double currentWeight,
    required String fitnessLevel,
    required String goalType,
    required String allergies,
    required int calorieGoals,
    File? profileImage,
  }) async {
    setLoading(true);
    clearError();

    try {
      // Create FormData for multipart request
      final formData = FormData.fromMap({
        'email': email,
        'user_name': userName,
        'full_name': fullName,
        'phone_number': phoneNumber,
        'address': address,
        'gender': gender,
        'birthdate': birthdate,
        'height': height.toString(),
        'current_weight': currentWeight.toString(),
        'fitness_level': fitnessLevel,
        'goal_type': goalType,
        'allergies': allergies,
        'calorie_goals': calorieGoals.toString(),
        if (profileImage != null)
          'profile_image': await MultipartFile.fromFile(
            profileImage.path,
            filename: 'profile_image.jpeg',
            contentType: getContentType(profileImage),
          ),
      });

      final response = await httpClient.post(
        '/auth/complete-profile',
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data'
          },
        ),
      );

      if (response.data['status'] == 'success') {
        return true;
      } else {
        setError(response.data['message'] ?? 'Failed to complete profile');
        return false;
      }
    } on DioException catch (e) {
      setError(_handleDioError(e));
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Check if username is available
  Future<bool> checkUsername(String username) async {
    if (username.isEmpty) {
      setError('Username is required');
      return false;
    }

    setLoading(true);
    clearError();

    try {
      final response = await httpClient.post(
        '/auth/check-username',
        data: {'user_name': username},
      );

      setLoading(false);
      return response.data['status'] == 'success';
    } on DioException catch (e) {
      setError(_handleDioError(e));
      setLoading(false);
      return false;
    }
  }

  Future<bool> checkPhoneNumber(String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      setError('Phone number is required');
      return false;
    }

    setLoading(true);
    clearError();

    try {
      final response = await httpClient.post(
        '/auth/check-phone-number',
        data: {'phone_number': phoneNumber},
      );

      setLoading(false);

      // Check the status from the API response
      if (response.data['status'] == 'failure') {
        // If the status is 'failure', it means the phone number already exists
        setError(response.data['message']);
        return false; // Phone number is already registered
      }

      // If status is 'success', it means phone number is not registered
      return true; // Phone number is available
    } on DioException catch (e) {
      setError(_handleDioError(e));
      setLoading(false);
      return false;
    }
  }

  // Forgot Password: Send OTP for password reset
  Future<bool> forgotPassword(String email) async {
    if (email.isEmpty) {
      setError('Email is required for password reset');
      return false;
    }

    setLoading(true);
    clearError();

    try {
      final response = await httpClient.post('/auth/forgot-password', data: {
        'email': email,
      });

      if (response.data['status'] == 'success') {
        _isOtpSent = true;
        notifyListeners();
        return true;
      } else {
        setError(response.data['message'] ??
            'Failed to send OTP for password reset');
        return false;
      }
    } on DioException catch (e) {
      setError(_handleDioError(e));
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Reset Password: Verify OTP and update password
  Future<bool> resetPassword(
      String newPassword, String email, String otp) async {
    if (email.isEmpty) {
      setError('Email is required');
      return false;
    }
    if (otp.isEmpty || otp.length != 6) {
      setError('Please enter a valid 6-digit OTP');
      return false;
    }
    // Validate new password meets criteria
    if (!RegExp(
            r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{8,}$")
        .hasMatch(newPassword)) {
      setError(
          "Password must contain at least 8 characters, one uppercase letter, one lowercase letter, one number, and one special character.");
      return false;
    }

    setLoading(true);
    clearError();

    try {
      final response = await httpClient.post('/auth/reset-password', data: {
        'email': email,
        'otp': otp,
        'newPassword': newPassword,
      });

      if (response.data['status'] == 'success') {
        _isVerified = true;
        notifyListeners();
        return true;
      } else {
        setError(response.data['message'] ?? 'Failed to reset password');
        return false;
      }
    } on DioException catch (e) {
      setError(_handleDioError(e));
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> resendOtpForPasswordRecovery(String email) async {
    if (email.isEmpty) {
      setError('Email is required to resend OTP');
      return false;
    }

    setLoading(true);
    clearError();

    try {
      final response = await httpClient.post('/auth/resend-otp', data: {
        'email': email,
      });

      if (response.data['status'] == 'success') {
        _isOtpSent = true;
        notifyListeners();
        return true;
      } else {
        setError(response.data['message'] ?? 'Failed to resend OTP');
        return false;
      }
    } on DioException catch (e) {
      setError(_handleDioError(e));
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Handle API errors
  String _handleDioError(DioException e) {
    if (e.response != null && e.response?.data is Map) {
      final data = e.response?.data as Map<String, dynamic>;
      if (data.containsKey('message') && data['message'] is String) {
        return data['message'];
      }
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.receiveTimeout:
        return 'Server took too long to respond';
      case DioExceptionType.badResponse:
        return 'Bad response from server';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      default:
        return 'Something went wrong';
    }
  }
}
