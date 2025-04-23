// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:gymify/models/api_response.dart';
// import 'package:gymify/models/exercise_model.dart';
// import 'package:gymify/network/http.dart';
// import 'package:gymify/providers/auth_provider/auth_provider.dart';
// import 'package:provider/provider.dart';

// class ExerciseProvider with ChangeNotifier {
//   List<Exercise> _exercises = [];
//   List<Exercise> get exercises => _exercises;

//   // Fetch all exercises
//   Future<void> fetchAllExercises() async {
//     try {
//       final response = await httpClient.get('/exercises');

//       final apiResponse = ApiResponse<List<Exercise>>.fromJson(
//         response.data,
//         (data) =>
//             (data as List).map((item) => Exercise.fromJson(item)).toList(),
//       );

//       if (apiResponse.status == 'success') {
//         _exercises = apiResponse.data;
//         notifyListeners();
//       } else {
//         print('Error: ${apiResponse.message}');
//         throw Exception(apiResponse.message.isNotEmpty
//             ? apiResponse.message
//             : 'Unknown error');
//       }
//     } catch (e) {
//       print('Error fetching exercises: $e');
//       throw Exception('Error fetching exercises: $e');
//     }
//   }

//   // Create a new exercise (with image upload)
//   Future<void> createExercise({
//     required BuildContext context,
//     required String exerciseName,
//     required String description,
//     required String targetMuscleGroup,
//     required String caloriesBurnedPerMinute,
//     required String videoUrl,
//     File? exerciseImage, // Optional: To upload image
//     File? exerciseVideo, // Optional: To upload video
//   }) async {
//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       final trainerId = authProvider.userId;

//       if (trainerId == null) {
//         throw Exception('Trainer ID not found');
//       }

//       // Prepare the data for the exercise
//       FormData formData = FormData.fromMap({
//         'exercise_name': exerciseName,
//         'description': description,
//         'target_muscle_group': targetMuscleGroup,
//         'calories_burned_per_minute': caloriesBurnedPerMinute,
//         'video_url': videoUrl,
//         'trainer_id': trainerId, // Assuming trainer ID
//         if (exerciseImage != null)
//           'image': await MultipartFile.fromFile(
//             exerciseImage.path,
//             filename: 'exercise_image.jpeg',
//             contentType: getContentType(exerciseImage),
//           ),
//         //! new added
//         if (exerciseVideo != null)
//           'video': await MultipartFile.fromFile(
//             exerciseVideo.path,
//             filename: 'exercise_video.mp4',
//             contentType: getContentType(exerciseVideo),
//           ),
//       });

//       final response = await httpClient.post(
//         '/exercises',
//         options: Options(headers: {
//           'Accept': 'application/json',
//           'Content-Type': 'multipart/form-data'
//         }),
//         data: formData,
//       );

//       final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
//         response.data,
//         (data) => data as Map<String, dynamic>,
//       );

//       if (apiResponse.status == 'success') {
//         // Handle success (maybe add to the exercise list or show success message)
//         print('Exercise created successfully');
//         fetchAllExercises(); // Refresh the list of exercises
//       } else {
//         throw Exception(apiResponse.message.isNotEmpty
//             ? apiResponse.message
//             : 'Unknown error');
//       }
//     } catch (e) {
//       print('Error creating exercise: $e');
//       throw Exception('Error creating exercise: $e');
//     }
//   }
// }

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
  String _error = '';
  bool _isLoading = false;

  // Getters
  List<Exercise> get exercises => _exercises;
  String get error => _error;
  bool get isLoading => _isLoading;

  // Setters
  void setError(String error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Handle API calls to reduce redundancy
  Future<void> handleApiCall(Future<void> Function() apiCall) async {
    setLoading(true);
    clearError();
    try {
      await apiCall();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  // Fetch all exercises
  Future<void> fetchAllExercises() async {
    await handleApiCall(() async {
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
        throw Exception(apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'Unknown error occurred while fetching exercises');
      }
    });
  }

  // Create a new exercise (with image and video upload)
  Future<void> createExercise({
    required BuildContext context,
    required String exerciseName,
    required String description,
    required String targetMuscleGroup,
    required String caloriesBurnedPerMinute,
    String? videoUrl,
    File? exerciseImage,
    File? exerciseVideo,
  }) async {
    await handleApiCall(() async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final trainerId = authProvider.userId;

      if (trainerId == null) {
        throw Exception('Trainer ID not found. Please log in again.');
      }

      // Prepare the data for the exercise
      FormData formData = FormData.fromMap({
        'exercise_name': exerciseName,
        'description': description,
        'target_muscle_group': targetMuscleGroup,
        'calories_burned_per_minute': caloriesBurnedPerMinute,
        'trainer_id': trainerId,
        if (exerciseImage != null)
          'image': await MultipartFile.fromFile(
            exerciseImage.path,
            filename: 'exercise_image.jpeg',
            contentType: getContentType(exerciseImage),
          ),
        if (exerciseVideo != null)
          'video': await MultipartFile.fromFile(
            exerciseVideo.path,
            filename: 'exercise_video.mp4',
            contentType: getContentType(exerciseVideo),
          )
        else if (videoUrl != null && videoUrl.isNotEmpty)
          'video_url': videoUrl,
      });

      final response = await httpClient.post(
        '/exercises',
        options: Options(headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        }),
        data: formData,
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.status == 'success') {
        print('Exercise created successfully');
        await fetchAllExercises(); // Refresh the list of exercises
      } else {
        throw Exception(apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'Unknown error occurred while creating exercise');
      }
    });
  }

  // method to delete exercise
  Future<void> deleteExercise(int exerciseId) async {
    await handleApiCall(() async {
      final response = await httpClient.delete('/exercises/$exerciseId');

      // final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      //   response.data,
      //   (data) => data as Map<String, dynamic>,
      // );
      if (response.data == null) {
        throw Exception('No response data received from the server');
      }

      if (response.data['status'] == 'success') {
        // Remove the diet plan from the list
        _exercises.removeWhere((exercise) => exercise.exerciseId == exerciseId);

        await fetchAllExercises(); // Refresh the list of exercises
      } else {
        throw Exception(response.data['message'].isNotEmpty
            ? response.data['message']
            : 'Unknown error occurred while deleting exercise');
      }
    });
  }
}
