import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gymify/models/api_response.dart';
import 'package:gymify/models/user_model.dart';
import 'package:gymify/models/weight_history_model.dart';
import 'package:gymify/network/http.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ProfileProvider with ChangeNotifier {
  Users? _user;
  Users? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<WeightHistory>? _weightHistory;
  List<WeightHistory>? get weightHistory => _weightHistory;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? message) {
    _hasError = message != null;
    _errorMessage = message;
    notifyListeners();
  }

  // Public method to reset error state
  void resetError() {
    _hasError = false;
    _errorMessage = null;
    notifyListeners();
  }

  // Helper method to determine content type from file
  MediaType? _getContentType(File file) {
    final mimeType = lookupMimeType(file.path);
    if (mimeType == null) return null;

    final parts = mimeType.split('/');
    if (parts.length == 2) {
      return MediaType(parts[0], parts[1]);
    }
    return null;
  }

  // Fetch user profile
  Future<void> fetchProfile() async {
    _setLoading(true);
    try {
      final response = await httpClient.get('/profile');
      final apiResponse = ApiResponse<Users>.fromJson(
        response.data,
        (data) => Users.fromJson(data as Map<String, dynamic>),
      );

      if (apiResponse.status == 'success') {
        _user = apiResponse.data;
        resetError();
      } else {
        _setError(apiResponse.message);
      }
    } catch (e) {
      _setError('Error fetching profile: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Update user profile with optional image upload
  Future<void> updateProfile(Map<String, dynamic> updatedData,
      [File? imageFile]) async {
    if (updatedData.isEmpty && imageFile == null) {
      _setError('No fields to update.');
      return;
    }

    _setLoading(true);
    try {
      // If we have an image file, we need to use FormData for multipart request
      if (imageFile != null) {
        // Create FormData for multipart request
        final formData = dio.FormData.fromMap({
          ...updatedData,
          'profile_image': await dio.MultipartFile.fromFile(
            imageFile.path,
            filename: 'profile_image.jpg',
            contentType: _getContentType(imageFile),
          ),
        });

        // Send multipart request
        final response = await httpClient.put(
          '/profile',
          data: formData,
          options: dio.Options(
            headers: {
              'Content-Type': 'multipart/form-data',
            },
          ),
        );

        final apiResponse = ApiResponse<Users>.fromJson(
          response.data,
          (data) => Users.fromJson(data as Map<String, dynamic>),
        );

        if (apiResponse.status == 'success') {
          _user = apiResponse.data;
          resetError();
        } else {
          _setError(apiResponse.message);
        }
      } else {
        // Regular update without image
        final response = await httpClient.put('/profile', data: updatedData);
        final apiResponse = ApiResponse<Users>.fromJson(
          response.data,
          (data) => Users.fromJson(data as Map<String, dynamic>),
        );

        if (apiResponse.status == 'success') {
          _user = apiResponse.data;
          resetError();
        } else {
          _setError(apiResponse.message);
        }
      }
    } catch (e) {
      _setError('Error updating profile: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Fetch weight history
  Future<void> fetchWeightHistory() async {
    _setLoading(true);
    try {
      final response = await httpClient.get('/weight-history');
      final apiResponse = ApiResponse<List<WeightHistory>>.fromJson(
        response.data,
        (data) => (data as List<dynamic>)
            .map((item) => WeightHistory.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

      if (apiResponse.status == 'success') {
        _weightHistory = apiResponse.data;
        resetError();
      } else {
        _setError(apiResponse.message);
      }
    } catch (e) {
      _setError('Error fetching weight history: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Update weight
  Future<void> updateWeight(BuildContext context, double newWeight) async {
    _setLoading(true);
    try {
      final response = await httpClient.post('/weight', data: {
        'current_weight': newWeight,
      });

      // Handle the response from the backend
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.status == 'success') {
        _user?.currentWeight = apiResponse.data[
            'current_weight']; // Update the user's profile with the new weight
        resetError();
        notifyListeners();
      } else {
        _setError(apiResponse.message);
      }
    } catch (e) {
      _setError('Error updating weight: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // method to get user details from user id
}
