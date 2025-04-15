import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gymify/models/api_response.dart';
import 'package:gymify/models/custom_workout_model.dart'; // CustomWorkoutModel and related classes
import 'package:gymify/network/http.dart';

class CustomWorkoutProvider with ChangeNotifier {
  List<CustomWorkoutModel> _customWorkouts = [];
  List<CustomWorkoutModel> get customWorkouts => _customWorkouts;

  CustomWorkoutModel? _selectedCustomWorkout;
  CustomWorkoutModel? get selectedCustomWorkout => _selectedCustomWorkout;

  bool _hasError = false;
  bool get hasError => _hasError;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(bool error) {
    _hasError = error;
    notifyListeners();
  }

  /// Fetch all custom workouts for a user
  Future<void> fetchCustomWorkouts() async {
    _setLoading(true);
    try {
      final response = await httpClient.get('/custom-workouts');
      final responseData = response.data;

      if (responseData['status'] == 'success') {
        _customWorkouts = (responseData['data'] as List)
            .map((workout) => CustomWorkoutModel.fromJson(workout))
            .toList();
      } else {
        _setError(true);
        throw Exception(responseData['message']);
      }
    } catch (e) {
      _setError(true);
      print('Error fetching custom workouts: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Fetch exercises for a specific custom workout
  Future<void> getCustomWorkoutExercisesById(int customWorkoutId) async {
    _setLoading(true);
    try {
      final response =
          await httpClient.get('/custom-workouts/$customWorkoutId');
      // final responseData = response.data;
      final apiResponse = ApiResponse<CustomWorkoutModel>.fromJson(
        response.data,
        (data) => CustomWorkoutModel.fromJson(data as Map<String, dynamic>),
      );
      if (apiResponse.status == 'success') {
        _selectedCustomWorkout = apiResponse.data;
        _selectedCustomWorkout?.customworkoutexercises.forEach((element) {
          print(element.exercises.exerciseName);
        });
        print(selectedCustomWorkout?.customWorkoutId);
      } else {
        throw Exception(apiResponse.message);
      }
    } catch (e) {
      print('Error fetching exercises: $e');
      throw Exception('Error fetching exercises: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Create a new custom workout
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

      final responseData = response.data;

      if (responseData['status'] == 'success') {
        final customWorkoutId =
            responseData['data']['custom_workout_id'] as int;
        await fetchCustomWorkouts(); // Refresh the workouts list
        return customWorkoutId;
      } else {
        if (responseData['message']
            .toString()
            .contains('already have a workout with this name')) {
          throw Exception(
              'You already have a workout with this name. Please use a different name.');
        } else {
          throw Exception(responseData['message']);
        }
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        // Handle Dio errors with response data
        final responseData = e.response?.data;
        if (responseData != null &&
            responseData is Map<String, dynamic> &&
            responseData['message'] != null) {
          if (responseData['message']
              .toString()
              .contains('already have a workout with this name')) {
            throw Exception(
                'You already have a workout with this name. Please use a different name.');
          }
        }
      }
      print('Error creating custom workout: $e');
      throw Exception('Failed to create custom workout. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  /// Add exercises to a custom workout
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
        await fetchCustomWorkouts(); // Refresh the workouts list
        notifyListeners();
      } else {
        throw Exception(responseData['message']);
      }
    } catch (e) {
      print('Error adding exercises to custom workout: $e');
      throw Exception('Error adding exercises to custom workout: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Remove an exercise from a custom workout
  Future<void> removeExerciseFromCustomWorkout(int exerciseId) async {
    _setLoading(true);
    try {
      final response = await httpClient.delete(
        '/custom-workouts/exercises/$exerciseId',
        options: Options(headers: {'Accept': 'application/json'}),
      );

      final responseData = response.data;

      if (responseData['status'] == 'success') {
        await fetchCustomWorkouts(); // Refresh the workouts list
      } else {
        throw Exception(responseData['message']);
      }
    } catch (e) {
      print('Error removing exercise: $e');
      throw Exception('Error removing exercise from custom workout: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Delete a custom workout
  Future<void> deleteCustomWorkout(int customWorkoutId) async {
    _setLoading(true);
    try {
      final response = await httpClient.delete(
        '/custom-workouts/$customWorkoutId',
        options: Options(headers: {'Accept': 'application/json'}),
      );

      final responseData = response.data;

      if (responseData['status'] == 'success') {
        await fetchCustomWorkouts(); // Refresh the workouts list
      } else {
        throw Exception(responseData['message']);
      }
    } catch (e) {
      print('Error deleting custom workout: $e');
      throw Exception('Error deleting custom workout: $e');
    } finally {
      _setLoading(false);
    }
  }
}
