import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gymify/models/api_response.dart';
import 'package:gymify/models/workout_model.dart'; // Import the Workout model.
import 'package:gymify/network/http.dart';
import 'package:gymify/providers/auth_provider/auth_provider.dart';
import 'package:provider/provider.dart';

class WorkoutProvider with ChangeNotifier {
  List<Workout> _workouts = [];
  List<Workout> get workouts => _workouts;

  bool _hasError = false;
  bool get hasError => _hasError;

  Workout? _selectedWorkout;
  Workout? get selectedWorkout => _selectedWorkout;

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

  // Fetch all workouts
  Future<void> fetchAllWorkouts() async {
    _setLoading(true); // Start loading
    _setError(false); // Reset error state BEFORE making the API call

    try {
      final response = await httpClient.get('/workouts');

      final apiResponse = ApiResponse<List<Workout>>.fromJson(
        response.data,
        (data) => (data as List).map((item) => Workout.fromJson(item)).toList(),
      );

      if (apiResponse.status == 'success') {
        _workouts = apiResponse.data;
      } else {
        _setError(true);
        throw Exception(apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'Unknown error');
      }
    } catch (e) {
      _setError(true);
      print('Error fetching workouts: $e');
    } finally {
      _setLoading(false); // Stop loading
    }
  }

  // Create a new workout
  Future<int> createWorkout({
    required BuildContext context,
    required String workoutName,
    required String description,
    required String targetMuscleGroup,
    required String difficulty,
    required String goalType,
    required String fitnessLevel,
    File? workoutImage, // Optional: To upload image
  }) async {
    _setLoading(true); // Start loading
    try {
      // Validate required fields
      if (workoutName.isEmpty ||
          description.isEmpty ||
          targetMuscleGroup.isEmpty) {
        throw Exception('All fields are required');
      }

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final trainerId = authProvider.userId;

      if (trainerId == null) {
        throw Exception('You must be logged in as a trainer');
      }

      FormData formData = FormData.fromMap({
        'workout_name': workoutName,
        'description': description,
        'target_muscle_group': targetMuscleGroup,
        'difficulty': difficulty,
        'goal_type': goalType,
        'fitness_level': fitnessLevel,
        'trainer_id': trainerId,
        if (workoutImage != null)
          'workout_image': await MultipartFile.fromFile(
            workoutImage.path,
            filename: 'profile_image.jpeg',
            contentType: getContentType(workoutImage),
          ),
      });

      final response = await httpClient.post(
        '/create-workouts',
        options: Options(headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data'
        }),
        data: formData,
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.status == 'success') {
        final workoutId = apiResponse.data['workout_id'] as int;
        await fetchAllWorkouts(); // Refresh workouts
        return workoutId;
      } else {
        // Check for specific error messages
        if (apiResponse.message.contains('already exists')) {
          throw Exception(
              'A workout with this name already exists. Please choose a different name.');
        } else {
          throw Exception(apiResponse.message.isNotEmpty
              ? apiResponse.message
              : 'Failed to create workout');
        }
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          // Handle Dio errors with response data
          final responseData = e.response?.data;
          if (responseData != null &&
              responseData is Map<String, dynamic> &&
              responseData['message'] != null) {
            if (responseData['message'].toString().contains('already exists')) {
              throw Exception(
                  'A workout with this name already exists. Please choose a different name.');
            } else {
              throw Exception('Server error: ${responseData['message']}');
            }
          }
        }
        // Generic Dio error handling
        if (e.type == DioExceptionType.connectionTimeout) {
          throw Exception(
              'Connection timed out. Please check your internet connection.');
        } else if (e.type == DioExceptionType.receiveTimeout) {
          throw Exception(
              'Server is taking too long to respond. Please try again later.');
        } else if (e.type == DioExceptionType.connectionError) {
          throw Exception('No internet connection. Please check your network.');
        }
        throw Exception('Failed to create workout. Please try again.');
      }
      // Re-throw original exception if it's not a DioException
      rethrow;
    } finally {
      _setLoading(false); // Stop loading
    }
  }

  // Add exercises to a workout
  Future<void> addExercisesToWorkout(BuildContext context, int workoutId,
      List<Map<String, dynamic>> exercises) async {
    _setLoading(true); // Start loading
    try {
      // Validate input data
      if (exercises.isEmpty) {
        throw Exception('No exercises provided');
      }

      
      

      final response = await httpClient.post(
        '/workouts/$workoutId/exercises',
        data: {'exercises': exercises},
        options: Options(headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        }),
      );


      // Fix: Change the expected response type from Map<String, dynamic> to dynamic
      // This allows us to handle both Map and List responses
      final apiResponse = ApiResponse<dynamic>.fromJson(
        response.data,
        (data) => data, // Just return the data as-is without casting
      );

      if (apiResponse.status == 'success') {
        // Exercises added successfully
        print('Success: Exercises added to workout');
        notifyListeners();
      } else {
        print('Error: ${apiResponse.message}');
        throw Exception(apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'Failed to add exercises to workout');
      }
    } catch (e) {
      print('Exception: $e');
      if (e is DioException) {
        if (e.response != null) {
          // Handle Dio errors with response data
          final responseData = e.response?.data;
          print('DioException response data: $responseData');
          if (responseData != null &&
              responseData is Map<String, dynamic> &&
              responseData['message'] != null) {
            throw Exception('Server error: ${responseData['message']}');
          }
        }
        // Generic Dio error handling
        if (e.type == DioExceptionType.connectionTimeout) {
          throw Exception(
              'Connection timed out. Please check your internet connection.');
        } else if (e.type == DioExceptionType.receiveTimeout) {
          throw Exception(
              'Server is taking too long to respond. Please try again later.');
        } else if (e.type == DioExceptionType.connectionError) {
          throw Exception('No internet connection. Please check your network.');
        }
        throw Exception(
            'Failed to add exercises to workout. Please try again.');
      }
      // Re-throw original exception if it's not a DioException
      rethrow;
    } finally {
      _setLoading(false); // Stop loading
    }
  }

  // Fetch workout by ID
  Future<void> fetchWorkoutById(int workoutId) async {
    _setLoading(true); // Start loading
    _setError(false); // Reset error state
    try {
      final response = await httpClient.get('/workouts/$workoutId');
      final apiResponse = ApiResponse<Workout>.fromJson(
        response.data,
        (data) => Workout.fromJson(data as Map<String, dynamic>),
      );

      if (apiResponse.status == 'success') {
        _selectedWorkout = apiResponse.data;
      } else {
        _setError(true);
      }
    } catch (e) {
      _setError(true);
      print('Error fetching workout by ID: $e');
    } finally {
      _setLoading(false); // Stop loading
    }
  }

  // Reset selected workout
  void clearSelectedWorkout() {
    _selectedWorkout = null;
    notifyListeners();
  }

  //!----------------------------------------
  Future<Workout?> getWorkoutDetailsById(int workoutId) async {
    try {
      final response = await httpClient.get('/workouts/$workoutId');
      final apiResponse = ApiResponse<Workout>.fromJson(
        response.data,
        (data) => Workout.fromJson(data as Map<String, dynamic>),
      );

      if (apiResponse.status == 'success') {
        return apiResponse.data;
      } else {
        throw Exception(apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'Unknown error');
      }
    } catch (e) {
      print('Error fetching workout details: $e');
      return null;
    }
  }

  // Add these methods to your existing WorkoutProvider class

  // Delete a workout
  Future<void> deleteWorkout(int workoutId) async {
    _setLoading(true); // Start loading
    try {
      final response = await httpClient.delete(
        '/workouts/$workoutId',
        options: Options(headers: {
          'Accept': 'application/json',
        }),
      );

      final apiResponse = ApiResponse<void>.fromJson(
        response.data,
        (data) {},
      );

      if (apiResponse.status == 'success') {
        // Remove the workout from the list
        _workouts.removeWhere((workout) => workout.workoutId == workoutId);
        notifyListeners();
      } else {
        throw Exception(apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'Unknown error');
      }
    } catch (e) {
      print('Error deleting workout: $e');
      throw Exception('Error deleting workout: $e');
    } finally {
      _setLoading(false); // Stop loading
    }
  }

  // Update an existing workout
  Future<void> updateWorkout({
    required int workoutId,
    required String workoutName,
    required String description,
    required String targetMuscleGroup,
    required String difficulty,
    required String goalType,
    required String fitnessLevel,
    File? workoutImage, // Optional: To update image
  }) async {
    _setLoading(true); // Start loading
    try {
      // Create FormData for multipart request
      FormData formData = FormData.fromMap({
        'workout_name': workoutName,
        'description': description,
        'target_muscle_group': targetMuscleGroup,
        'difficulty': difficulty,
        'goal_type': goalType,
        'fitness_level': fitnessLevel,
        if (workoutImage != null)
          'workout_image': await MultipartFile.fromFile(
            workoutImage.path,
            filename: 'workout_image.jpeg',
            contentType: getContentType(workoutImage),
          ),
      });

      final response = await httpClient.put(
        '/workouts/$workoutId',
        options: Options(headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data'
        }),
        data: formData,
      );

      final apiResponse = ApiResponse<Workout>.fromJson(
        response.data,
        (data) => Workout.fromJson(data as Map<String, dynamic>),
      );

      if (apiResponse.status == 'success') {
        // Update the workout in the local list
        final index = _workouts.indexWhere((w) => w.workoutId == workoutId);
        if (index != -1) {
          _workouts[index] = apiResponse.data;
        }

        // If this workout is currently selected, update it
        if (_selectedWorkout?.workoutId == workoutId) {
          _selectedWorkout = apiResponse.data;
        }

        notifyListeners();
      } else {
        throw Exception(apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'Unknown error');
      }
    } catch (e) {
      print('Error updating workout: $e');
      throw Exception('Error updating workout: $e');
    } finally {
      _setLoading(false); // Stop loading
    }
  }

  // Add this method to your WorkoutProvider class

  // Remove an exercise from a workout
  Future<void> removeExerciseFromWorkout(
      int workoutId, int workoutExerciseId) async {
    _setLoading(true); // Start loading
    try {
      final response = await httpClient.delete(
        '/workouts/$workoutId/exercises/$workoutExerciseId',
        options: Options(headers: {
          'Accept': 'application/json',
        }),
      );

      final apiResponse = ApiResponse<void>.fromJson(
        response.data,
        (data) {},
      );

      if (apiResponse.status == 'success') {
        // If this workout is currently selected, update its exercises list
        if (_selectedWorkout?.workoutId == workoutId) {
          _selectedWorkout!.workoutexercises?.removeWhere(
            (exercise) => exercise.workoutExerciseId == workoutExerciseId,
          );
        }

        // Also update the exercise in the local workouts list if present
        final workoutIndex =
            _workouts.indexWhere((w) => w.workoutId == workoutId);
        if (workoutIndex != -1 &&
            _workouts[workoutIndex].workoutexercises != null) {
          _workouts[workoutIndex].workoutexercises?.removeWhere(
                (exercise) => exercise.workoutExerciseId == workoutExerciseId,
              );
        }

        notifyListeners();
      } else {
        throw Exception(apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'Unknown error');
      }
    } catch (e) {
      print('Error removing exercise from workout: $e');
      throw Exception('Error removing exercise: $e');
    } finally {
      _setLoading(false); // Stop loading
    }
  }
}
