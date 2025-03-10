// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:gymify/models/api_response.dart';
// import 'package:gymify/models/personal_best_model.dart';
// import 'package:gymify/models/supported_exercise_model.dart';

// import 'package:gymify/network/http.dart';
// import 'package:gymify/providers/auth_provider/auth_provider.dart';
// import 'package:provider/provider.dart';

// class PersonalBestProvider with ChangeNotifier {
//   List<SupportedExercise> _supportedExercises = [];
//   List<SupportedExercise> get supportedExercises => _supportedExercises;

//   List<PersonalBest> _personalBestHistory = [];
//   List<PersonalBest> get personalBestHistory => _personalBestHistory;

//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   bool _hasError = false;
//   bool get hasError => _hasError;

//   void _setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }

//   void _setError(bool error) {
//     _hasError = error;
//     notifyListeners();
//   }

//   /// Fetch all supported exercises (for logging personal best)
//   Future<void> fetchSupportedExercises() async {
//     _setLoading(true);
//     try {
//       final response = await httpClient.get('/supported_exercises');

//       final apiResponse = ApiResponse<List<SupportedExercise>>.fromJson(
//         response.data,
//         (data) => (data as List)
//             .map((item) => SupportedExercise.fromJson(item))
//             .toList(),
//       );

//       if (apiResponse.status == 'success') {
//         _supportedExercises = apiResponse.data;
//       } else {
//         _setError(true);
//         throw Exception(apiResponse.message.isNotEmpty
//             ? apiResponse.message
//             : 'Unknown error');
//       }
//     } catch (e) {
//       _setError(true);
//       print('Error fetching supported exercises: $e');
//     } finally {
//       _setLoading(false);
//     }
//   }

//   /// Log a new personal best
//   Future<void> logPersonalBest({
//     required BuildContext context,
//     required int exerciseId,
//     required double weight,
//     required int reps,
//   }) async {
//     _setLoading(true);
//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       final userId = authProvider.userId;

//       if (userId == null) {
//         throw Exception('User ID not found');
//       }

//       final response = await httpClient.post(
//         '/personal_best',
//         data: {
//           'exerciseId': exerciseId,
//           'weight': weight,
//           'reps': reps,
//         },
//       );

//       // final apiResponse = ApiResponse<PersonalBest>.fromJson(
//       //   response.data,
//       //   (data) => data as Map<String, dynamic>,
//       // );

//       final apiResponse = ApiResponse<PersonalBest>.fromJson(
//         response.data,
//         (data) => PersonalBest.fromJson(data as Map<String, dynamic>),
//       );

//       if (apiResponse.status == 'success') {
//         await fetchPersonalBestHistory(userId as int, exerciseId);
//       } else {
//         throw Exception(apiResponse.message.isNotEmpty
//             ? apiResponse.message
//             : 'Unknown error');
//       }
//     } catch (e) {
//       print('Error logging personal best: $e');
//       throw Exception('Error logging personal best: $e');
//     } finally {
//       _setLoading(false);
//     }
//   }

//   /// Fetch personal best history for a user and exercise
//   Future<void> fetchPersonalBestHistory(int userId, int exerciseId) async {
//     _setLoading(true);
//     _setError(false);
//     try {
//       final response =
//           await httpClient.get('/user/$userId/history/$exerciseId');

//       final apiResponse = ApiResponse<List<PersonalBest>>.fromJson(
//         response.data,
//         (data) =>
//             (data as List).map((item) => PersonalBest.fromJson(item)).toList(),
//       );

//       if (apiResponse.status == 'success') {
//         _personalBestHistory = apiResponse.data;
//       } else {
//         _setError(true);
//       }
//     } catch (e) {
//       _setError(true);
//       print('Error fetching personal best history: $e');
//     } finally {
//       _setLoading(false);
//     }
//   }

//   /// Reset personal best history
//   void clearPersonalBestHistory() {
//     _personalBestHistory = [];
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:gymify/models/api_response.dart';
import 'package:gymify/models/personal_best_model.dart';
import 'package:gymify/models/supported_exercise_model.dart';
import 'package:gymify/network/http.dart';
import 'package:gymify/providers/auth_provider/auth_provider.dart';
import 'package:provider/provider.dart';

class PersonalBestProvider with ChangeNotifier {
  List<SupportedExercise> _supportedExercises = [];
  List<SupportedExercise> get supportedExercises => _supportedExercises;

  List<PersonalBest> _personalBestHistory = [];
  List<PersonalBest> get personalBestHistory => _personalBestHistory;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(bool error) {
    _hasError = error;
    notifyListeners();
  }

  /// Fetch all supported exercises (for logging personal best)
  Future<void> fetchSupportedExercises() async {
    _setLoading(true);
    try {
      final response = await httpClient.get('/supported_exercises');

      final apiResponse = ApiResponse<List<SupportedExercise>>.fromJson(
        response.data,
        (data) =>
            (data as List?)
                ?.map((item) => SupportedExercise.fromJson(item))
                .toList() ??
            [],
      );

      if (apiResponse.status == 'success') {
        _supportedExercises = apiResponse.data ?? [];
      } else {
        _setError(true);
        throw Exception(apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'Unknown error');
      }
    } catch (e) {
      _setError(true);
      print('Error fetching supported exercises: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Log a new personal best
  Future<void> logPersonalBest({
    required BuildContext context,
    required int exerciseId,
    required double weight,
    required int reps,
  }) async {
    _setLoading(true);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.userId;

      if (userId == null) {
        throw Exception('User ID not found');
      }

      final response = await httpClient.post(
        '/personal_best',
        data: {
          'exerciseId': exerciseId,
          'weight': weight,
          'reps': reps,
        },
      );

      // Handle null response or malformed data gracefully
      if (response.data == null || response.data['data'] == null) {
        throw Exception('Unexpected null response from server.');
      }

      final apiResponse = ApiResponse<PersonalBest>.fromJson(
        response.data,
        (data) => PersonalBest.fromJson(data as Map<String, dynamic>),
      );

      if (apiResponse.status == 'success') {
        await fetchPersonalBestHistory(userId as int, exerciseId);
      } else {
        throw Exception(apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'Unknown error');
      }
    } catch (e) {
      print('Error logging personal best: $e');
      throw Exception('Error logging personal best: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Fetch personal best history for a user and exercise
  Future<void> fetchPersonalBestHistory(int userId, int exerciseId) async {
    _setLoading(true);
    _setError(false);
    try {
      final response =
          await httpClient.get('/user/$userId/history/$exerciseId');

      final apiResponse = ApiResponse<List<PersonalBest>>.fromJson(
        response.data,
        (data) =>
            (data as List?)
                ?.map((item) => PersonalBest.fromJson(item))
                .toList() ??
            [],
      );

      if (apiResponse.status == 'success') {
        _personalBestHistory = apiResponse.data ?? [];
      } else {
        _setError(true);
      }
    } catch (e) {
      _setError(true);
      print('Error fetching personal best history: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Reset personal best history
  void clearPersonalBestHistory() {
    _personalBestHistory = [];
    notifyListeners();
  }
}
