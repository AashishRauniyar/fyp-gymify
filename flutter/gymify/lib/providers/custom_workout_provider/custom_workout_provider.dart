import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gymify/models/api_response.dart';
import 'package:gymify/models/custom_workout_model.dart'; // CustomWorkout model
import 'package:gymify/network/http.dart';
import 'package:gymify/services/storage_service.dart';

class CustomWorkoutProvider with ChangeNotifier {
  List<CustomWorkoutModel> _customWorkouts = [];
  List<CustomWorkoutModel> get customWorkouts => _customWorkouts;

  bool _hasError = false;
  bool get hasError => _hasError;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final StorageService _storageService = SharedPrefsService();

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(bool error) {
    _hasError = error;
    notifyListeners();
  }

  // Fetch all custom workouts for a user
  Future<void> fetchCustomWorkouts() async {
    _setLoading(true);
    try {
      final response = await httpClient.get('/custom-workouts');
      final apiResponse = ApiResponse<List<CustomWorkoutModel>>.fromJson(
        response.data,
        (data) => (data as List)
            .map((item) => CustomWorkoutModel.fromJson(item))
            .toList(),
      );

      if (apiResponse.status == 'success') {
        _customWorkouts = apiResponse.data;
      } else {
        _setError(true);
        throw Exception(apiResponse.message);
      }
    } catch (e) {
      _setError(true);
      print('Error fetching custom workouts: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Create a new custom workout
  Future<int> createCustomWorkout(String customWorkoutName) async {
    _setLoading(true);
    try {
      final response = await httpClient.post(
        '/custom-workouts',
        data: {'custom_workout_name': customWorkoutName},
        options: Options(headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        }),
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.status == 'success') {
        final customWorkoutId = apiResponse.data['custom_workout_id'] as int;
        await fetchCustomWorkouts(); // Refresh custom workouts
        return customWorkoutId;
      } else {
        throw Exception(apiResponse.message);
      }
    } catch (e) {
      print('Error creating custom workout: $e');
      throw Exception('Error creating custom workout: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Add exercises to a custom workout
  Future<void> addExercisesToCustomWorkout(
      int customWorkoutId, List<Map<String, dynamic>> exercises) async {
    _setLoading(true);
    try {
      final response = await httpClient.post(
        '/custom-workouts/add-exercise',
        data: {
          'custom_workout_id': customWorkoutId,
          'exercises': exercises,
        },
        options: Options(headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        }),
      );

      final responseData = response.data;

      if (responseData['status'] == 'success') {
        await fetchCustomWorkouts(); // Refresh custom workouts
        notifyListeners();
      } else {
        throw Exception(responseData['message']);
      }
    } catch (e) {
      print('Error adding exercises to custom workout: $e');
      throw Exception('Error adding exercises: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Get exercises in a specific custom workout
  Future<List<dynamic>> getCustomWorkoutModelsById(
      int customWorkoutId) async {
    _setLoading(true);
    try {
      final response =
          await httpClient.get('/custom-workouts/$customWorkoutId/exercises');

      final responseData = response.data;

      if (responseData['status'] == 'success') {
        return responseData['exercises'];
      } else {
        throw Exception(responseData['message']);
      }
    } catch (e) {
      print('Error fetching exercises: $e');
      throw Exception('Error fetching exercises: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Remove an exercise from a custom workout
  Future<void> removeExerciseFromCustomWorkout(
      int customWorkouCustomWorkoutModelId) async {
    _setLoading(true);
    try {
      final response = await httpClient.delete(
        '/custom-workouts/exercises/$customWorkouCustomWorkoutModelId',
        options: Options(headers: {'Accept': 'application/json'}),
      );

      final responseData = response.data;

      if (responseData['status'] == 'success') {
        await fetchCustomWorkouts(); // Refresh custom workouts
      } else {
        throw Exception(responseData['message']);
      }
    } catch (e) {
      print('Error removing exercise: $e');
      throw Exception('Error removing exercise: $e');
    } finally {
      _setLoading(false);
    }
  }
}
