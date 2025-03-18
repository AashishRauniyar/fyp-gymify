import 'package:flutter/material.dart';
import 'package:gymify/models/api_response.dart';
import 'package:gymify/models/user_model.dart';
import 'package:gymify/models/weight_history_model.dart';
import 'package:gymify/network/http.dart';

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

  // Update user profile
  Future<void> updateProfile(Map<String, dynamic> updatedData) async {
    if (updatedData.isEmpty) {
      _setError('No fields to update.');
      return;
    }

    _setLoading(true);
    try {
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
