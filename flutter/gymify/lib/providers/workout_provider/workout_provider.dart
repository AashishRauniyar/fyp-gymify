import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gymify/models/api_response.dart';
import 'package:gymify/models/workout_model.dart'; // Import the Workout model.
import 'package:gymify/network/http.dart';
import 'package:gymify/providers/auth_provider/auth_provider.dart';
import 'package:gymify/services/storage_service.dart'; // Make sure the httpClient is properly set up.
import 'package:provider/provider.dart';

class WorkoutProvider with ChangeNotifier {
  List<Workout> _workouts = [];
  List<Workout> get workouts => _workouts;

  bool _hasError = false;
  bool get hasError => _hasError;

  Workout? _selectedWorkout;
  Workout? get selectedWorkout => _selectedWorkout;

  final StorageService _storageService = SharedPrefsService();

  // Fetch all workouts
  Future<void> fetchAllWorkouts() async {
    try {
      final response = await httpClient
          .get('/workouts'); // Adjust the endpoint to your actual API

      final apiResponse = ApiResponse<List<Workout>>.fromJson(
        response.data,
        (data) => (data as List).map((item) => Workout.fromJson(item)).toList(),
      );

      if (apiResponse.status == 'success') {
        _workouts = apiResponse.data;
        notifyListeners(); // Notify listeners when data is updated.
      } else {
        print('Error: ${apiResponse.message}');
        throw Exception(apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'Unknown error');
      }
    } catch (e) {
      print('Error fetching workouts: $e');
      throw Exception('Error fetching workouts: $e');
    }
  }

//----------------------------------------------------------------

//TODO: to handle unique name for workout
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
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final trainerId =
          authProvider.userId; // Assuming user ID is saved as 'user_id'

      if (trainerId == null) {
        throw Exception('Trainer ID not found');
      }

      // Prepare the data for the workout
      FormData formData = FormData.fromMap({
        'workout_name': workoutName,
        'description': description,
        'target_muscle_group': targetMuscleGroup,
        'difficulty': difficulty,
        'goal_type': goalType,
        'fitness_level': fitnessLevel,
        'trainer_id': trainerId,
        // Set the trainer's ID
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
        // Extract the workout_id
        final workoutData = apiResponse.data;
        // Extract the workout_id
        final workoutId = workoutData['workout_id'] as int;
        print(workoutId);

        // Optionally, fetch all workouts if needed
        fetchAllWorkouts();

        // Return the workout_id
        return workoutId;
      } else {
        throw Exception(apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'Unknown error');
      }
    } catch (e) {
      print('Error creating workout: $e');
      throw Exception('Error creating workout: $e');
    }
  }

  //----------------------------------------------------------------------------

  Future<void> addExercisesToWorkout(BuildContext context, int workoutId,
      List<Map<String, dynamic>> exercises) async {
    try {
      print('Request payload: ${exercises.toString()}');
      final response = await httpClient.post(
        '/workouts/$workoutId/exercises',
        data: {'exercises': exercises},
        options: Options(headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        }),
      );

      final responseData = response.data;
      print('API Response: $responseData');

      if (responseData['status'] == 'success') {
        final addedExercises = (responseData['data'] as List<dynamic>)
            .map((exercise) => exercise as Map<String, dynamic>)
            .toList();
        print('Added exercises: $addedExercises');
        notifyListeners();
      } else {
        print('API Error: ${responseData['message']}');
        throw Exception(responseData['message']);
      }
    } catch (e) {
      print('Error adding exercises to workout: $e');
      throw Exception('Error adding exercises: $e');
    }
  }

  Future<void> fetchWorkoutById(int workoutId) async {
    _hasError = false; // Reset error state
    try {
      final response = await httpClient.get('/workouts/$workoutId');
      final apiResponse = ApiResponse<Workout>.fromJson(
        response.data,
        (data) => Workout.fromJson(data as Map<String, dynamic>),
      );

      if (apiResponse.status == 'success') {
        _selectedWorkout = apiResponse.data;
      } else {
        _hasError = true;
      }
    } catch (e) {
      _hasError = true;
      debugPrint('[WorkoutProvider] Error fetching workout by ID: $e');
    }
    notifyListeners();
  }

  // Reset the selected workout (optional)
  void clearSelectedWorkout() {
    _selectedWorkout = null;
    notifyListeners();
  }
}
