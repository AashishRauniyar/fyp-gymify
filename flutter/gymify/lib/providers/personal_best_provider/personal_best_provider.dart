import 'package:flutter/material.dart';
import 'package:gymify/models/api_response.dart';
import 'package:gymify/models/personal_best_model.dart';
import 'package:gymify/models/personal_best_models/exercise_progress_model.dart';
import 'package:gymify/models/supported_exercise_model.dart';
import 'package:gymify/network/http.dart';

class PersonalBestProvider with ChangeNotifier {
  List<SupportedExercise> _supportedExercises = [];
  List<SupportedExercise> get supportedExercises => _supportedExercises;

  List<PersonalBest> _personalBestHistory = [];
  List<PersonalBest> get personalBestHistory => _personalBestHistory;

  List<Map<String, dynamic>> _currentBests = [];
  List<Map<String, dynamic>> get currentBests => _currentBests;

  ExerciseProgress? _exerciseProgress;
  ExerciseProgress? get exerciseProgress => _exerciseProgress;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(bool error, [String message = '']) {
    _hasError = error;
    _errorMessage = message;
    notifyListeners();
  }

  /// Fetch all supported exercises
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
        _setError(true, apiResponse.message);
      }
    } catch (e) {
      _setError(true, 'Error fetching supported exercises: $e');
      print('Error fetching supported exercises: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Log a new personal best
  Future<void> logPersonalBest({
    required int exerciseId,
    required double weight,
    required int reps,
  }) async {
    _setLoading(true);
    try {
      final response = await httpClient.post(
        '/personal_best',
        data: {
          'exerciseId': exerciseId,
          'weight': weight,
          'reps': reps,
        },
      );

      if (response.data == null) {
        throw Exception('Unexpected null response from server.');
      }

      final apiResponse = ApiResponse<PersonalBest>.fromJson(
        response.data,
        (data) => PersonalBest.fromJson(data as Map<String, dynamic>),
      );

      if (apiResponse.status == 'success') {
        // Refresh the history after logging a new personal best
        await fetchPersonalBestHistory(exerciseId);
      } else {
        _setError(true, apiResponse.message);
      }
    } catch (e) {
      _setError(true, 'Error logging personal best: $e');
      print('Error logging personal best: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Fetch personal best history for current user and specific exercise
  Future<void> fetchPersonalBestHistory(int exerciseId) async {
    _setLoading(true);
    _setError(false);
    try {
      final response = await httpClient.get('/history/$exerciseId');

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
        _setError(true, apiResponse.message);
      }
    } catch (e) {
      _setError(true, 'Error fetching personal best history: $e');
      print('Error fetching personal best history: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Get current personal bests for all exercises
  Future<void> fetchCurrentPersonalBests() async {
    _setLoading(true);
    try {
      final response = await httpClient.get('/current_bests');

      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        response.data,
        (data) => data as List<dynamic>,
      );

      if (apiResponse.status == 'success') {
        _currentBests = apiResponse.data
                .map((item) => {
                      'exercise': SupportedExercise.fromJson(item['exercise']),
                      'personalBest': item['personalBest'] != null
                          ? PersonalBest.fromJson(item['personalBest'])
                          : null,
                    })
                .toList() ??
            [];
      } else {
        _setError(true, apiResponse.message);
      }
    } catch (e) {
      _setError(true, 'Error fetching current personal bests: $e');
      print('Error fetching current personal bests: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Delete a personal best record
  Future<bool> deletePersonalBest(int personalBestId) async {
    _setLoading(true);
    try {
      final response =
          await httpClient.delete('/personal_best/$personalBestId');

      final apiResponse = ApiResponse<dynamic>.fromJson(
        response.data,
        (data) => data,
      );

      if (apiResponse.status == 'success') {
        // Remove the deleted record from the history list
        _personalBestHistory
            .removeWhere((record) => record.personalBestId == personalBestId);
        notifyListeners();
        return true;
      } else {
        _setError(true, apiResponse.message);
        return false;
      }
    } catch (e) {
      _setError(true, 'Error deleting personal best: $e');
      print('Error deleting personal best: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Get exercise progress over time
  Future<void> fetchExerciseProgress(int exerciseId) async {
    _setLoading(true);
    try {
      final response = await httpClient.get('/progress/$exerciseId');

      if (response.data == null) {
        throw Exception('Unexpected null response from server.');
      }

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.status == 'success') {
        _exerciseProgress = ExerciseProgress.fromJson(apiResponse.data);
      } else {
        _setError(true, apiResponse.message);
      }
    } catch (e) {
      _setError(true, 'Error fetching exercise progress: $e');
      print('Error fetching exercise progress: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Create a new supported exercise (Trainer only)
  Future<bool> createSupportedExercise(String exerciseName) async {
    _setLoading(true);
    try {
      final response = await httpClient.post(
        '/supported_exercise',
        data: {
          'exerciseName': exerciseName,
        },
      );

      final apiResponse = ApiResponse<SupportedExercise>.fromJson(
        response.data,
        (data) => SupportedExercise.fromJson(data as Map<String, dynamic>),
      );

      if (apiResponse.status == 'success') {
        // Add the new exercise to the list
        _supportedExercises.add(apiResponse.data);
        notifyListeners();
        return true;
      } else {
        _setError(true, apiResponse.message);
        return false;
      }
    } catch (e) {
      _setError(true, 'Error creating supported exercise: $e');
      print('Error creating supported exercise: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // delete supported exercise (Trainer only)
  Future<bool> deleteSupportedExercise(int exerciseId) async {
    _setLoading(true);
    try {
      final response =
          await httpClient.delete('/supported_exercise/$exerciseId');

      if (response.data == null) {
        throw Exception('No response data received from the server');
      }
      if (response.data['status'] == 'success') {
        // Remove the diet plan from the list
        _supportedExercises.removeWhere(
            (exercise) => exercise.supportedExerciseId == exerciseId);

        await fetchSupportedExercises();

        notifyListeners();
        return true;
      } else {
        _setError(true, response.data['message']);
        return false;
      }
    } catch (e) {
      _setError(true, 'Error deleting supported exercise: $e');
      print('Error deleting supported exercise: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Reset personal best history
  void clearPersonalBestHistory() {
    _personalBestHistory = [];
    notifyListeners();
  }

  /// Reset error state
  void resetError() {
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
  }
}
