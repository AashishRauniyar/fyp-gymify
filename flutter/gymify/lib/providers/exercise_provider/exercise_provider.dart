import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gymify/models/api_response.dart';
import 'package:gymify/models/exercise_model.dart';
import 'package:gymify/network/http.dart';
import 'package:gymify/providers/auth_provider/auth_provider.dart';
import 'package:provider/provider.dart';

class ExerciseProvider with ChangeNotifier {
  List<Exercise> _exercises = [];
  List<Exercise> get exercises => _exercises;

  // Fetch all exercises
  Future<void> fetchAllExercises() async {
    try {
      final response = await httpClient.get('/exercises');

      final apiResponse = ApiResponse<List<Exercise>>.fromJson(
        response.data,
        (data) =>
            (data as List).map((item) => Exercise.fromJson(item)).toList(),
      );

      if (apiResponse.status == 'success') {
        _exercises = apiResponse.data;
        notifyListeners();
      } else {
        print('Error: ${apiResponse.message}');
        throw Exception(apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'Unknown error');
      }
    } catch (e) {
      print('Error fetching exercises: $e');
      throw Exception('Error fetching exercises: $e');
    }
  }

  // Create a new exercise (with image upload)
  Future<void> createExercise({
    required BuildContext context,
    required String exerciseName,
    required String description,
    required String targetMuscleGroup,
    required String caloriesBurnedPerMinute,
    required String videoUrl,
    File? exerciseImage, // Optional: To upload image
    File? exerciseVideo, // Optional: To upload video
  }) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final trainerId = authProvider.userId;

      if (trainerId == null) {
        throw Exception('Trainer ID not found');
      }

      // Prepare the data for the exercise
      FormData formData = FormData.fromMap({
        'exercise_name': exerciseName,
        'description': description,
        'target_muscle_group': targetMuscleGroup,
        'calories_burned_per_minute': caloriesBurnedPerMinute,
        'video_url': videoUrl,
        'trainer_id': trainerId, // Assuming trainer ID
        if (exerciseImage != null)
          'image': await MultipartFile.fromFile(
            exerciseImage.path,
            filename: 'exercise_image.jpeg',
            contentType: getContentType(exerciseImage),
          ),
        //! new added
        if (exerciseVideo != null)
          'video': await MultipartFile.fromFile(
            exerciseVideo.path,
            filename: 'exercise_video.mp4',
            contentType: getContentType(exerciseVideo),
          ),
      });

      final response = await httpClient.post(
        '/exercises',
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
        // Handle success (maybe add to the exercise list or show success message)
        print('Exercise created successfully');
        fetchAllExercises(); // Refresh the list of exercises
      } else {
        throw Exception(apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'Unknown error');
      }
    } catch (e) {
      print('Error creating exercise: $e');
      throw Exception('Error creating exercise: $e');
    }
  }
}
