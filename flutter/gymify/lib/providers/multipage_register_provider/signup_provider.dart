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
            r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$")
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
