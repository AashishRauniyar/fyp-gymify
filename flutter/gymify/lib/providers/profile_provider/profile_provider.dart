// import 'package:flutter/material.dart';
// import 'package:gymify/models/api_response.dart';
// import 'package:gymify/models/user_model.dart'; // Import the Users model
// import 'package:gymify/models/weight_history_model.dart';
// import 'package:gymify/network/http.dart';

// class ProfileProvider with ChangeNotifier {
//   Users? _user;
//   Users? get user => _user;

//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   bool _hasError = false;
//   bool get hasError => _hasError;

//   List<WeightHistory>? _weightHistory;
//   List<WeightHistory>? get weightHistory => _weightHistory;

//   void _setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }

//   void _setError(bool error) {
//     _hasError = error;
//     notifyListeners();
//   }

//   // Public method to reset error state
//   void resetError() {
//     _hasError = false;
//     notifyListeners();
//   }

//   // Fetch user profile
//   Future<void> fetchProfile() async {
//     _setLoading(true);
//     try {
//       final response = await httpClient.get('/profile');
//       final apiResponse = ApiResponse<Users>.fromJson(
//         response.data,
//         (data) => Users.fromJson(data as Map<String, dynamic>),
//       );

//       if (apiResponse.status == 'success') {
//         _user = apiResponse.data;
//         print(user?.birthdate);
//       } else {
//         _setError(true);
//         throw Exception(apiResponse.message);
//       }
//     } catch (e) {
//       _setError(true);
//       print('Error fetching profile: $e');
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // Update user profile
//   Future<void> updateProfile(Map<String, dynamic> updatedData) async {
//     _setLoading(true);
//     try {
//       final response = await httpClient.put('/profile', data: updatedData);
//       final apiResponse = ApiResponse<Users>.fromJson(
//         response.data,
//         (data) => Users.fromJson(data as Map<String, dynamic>),
//       );

//       if (apiResponse.status == 'success') {
//         _user = apiResponse.data;
//         notifyListeners();
//       } else {
//         _setError(true);
//         throw Exception(apiResponse.message);
//       }
//     } catch (e) {
//       _setError(true);
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // Fetch weight history
//   Future<void> fetchWeightHistory() async {
//     _setLoading(true);
//     try {
//       final response = await httpClient.get('/weight-history');
//       final apiResponse = ApiResponse<List<WeightHistory>>.fromJson(
//         response.data,
//         (data) => (data as List<dynamic>)
//             .map((item) => WeightHistory.fromJson(item as Map<String, dynamic>))
//             .toList(),
//       );

//       if (apiResponse.status == 'success') {
//         _weightHistory = apiResponse.data;
//       } else {
//         _setError(true);
//         throw Exception(apiResponse.message);
//       }
//     } catch (e) {
//       _setError(true);
//       print('Error fetching weight history: $e');
//     } finally {
//       _setLoading(false);
//     }
//   }
// }




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
}
