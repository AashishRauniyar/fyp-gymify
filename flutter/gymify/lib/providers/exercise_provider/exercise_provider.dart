import 'package:flutter/material.dart';
import 'package:gymify/models/api_response.dart';
import 'package:gymify/models/exercise_model.dart';
import 'package:gymify/network/http.dart';

class ExerciseProvider with ChangeNotifier {
  List<Exercise> _exercises = [];
  List<Exercise> get exercises => _exercises;


  Future<void> fetchAllExercises() async{
    try {
      final response = await httpClient.get('/exercises');

      final apiResponse = ApiResponse<List<Exercise>>.fromJson(
        response.data,
        (data) => (data as List).map((item) => Exercise.fromJson(item)).toList(),
      );

      if (apiResponse.status == 'success') {
        _exercises = apiResponse.data;
        notifyListeners();
      } else {
        print('Error: ${apiResponse.message}');
        throw Exception(apiResponse.message.isNotEmpty ? apiResponse.message : 'Unknown error');
      }

    } catch (e) {
      print('Error fetching exercises: $e');

      throw Exception('Error fetching exercises: $e');  
      
    }
  }

  // Fetch all exercises
  // Future<void> fetchAllExercises() async {
  //   try {
  //     final response = await httpClient.get('/exercises');
      
  //     // Deserialize the response using ApiResponse with a list of exercises
  //     final apiResponse = ApiResponse<List<Exercise>>.fromJson(
  //       response.data,
  //       (data) => (data as List).map((item) => Exercise.fromJson(item)).toList(),
  //     );

  //     if (apiResponse.status == 'success') {
  //       // Update the _exercises list with the fetched data
  //       _exercises = apiResponse.data ?? [];
  //       notifyListeners();
  //     } else {
  //       // Handle error if status is not success, message may be empty
  //       print('Error: ${apiResponse.message}');
  //       throw Exception(apiResponse.message.isNotEmpty ? apiResponse.message : 'Unknown error');
  //     }
  //   } catch (e) {
  //     print('Error fetching exercises: $e');
  //   }
  // }

  // // Fetch a specific exercise by ID
  // Future<Exercise?> fetchExerciseById(int id) async {
  //   try {
  //     final response = await httpClient.get('/exercises/$id');
  //     final apiResponse = ApiResponse<Exercise>.fromJson(
  //       response.data,
  //       (data) => Exercise.fromJson(data),
  //     );
  //     if (apiResponse.status == 'success') {
  //       return apiResponse.data;
  //     } else {
  //       print('Error: ${apiResponse.message}');
  //       throw Exception(apiResponse.message.isNotEmpty ? apiResponse.message : 'Unknown error');
  //     }
  //   } catch (e) {
  //     print('Error fetching exercise by ID: $e');
  //     return null;
  //   }
  // }

  // // Create a new exercise
  // Future<void> createExercise(Exercise exercise) async {
  //   try {
  //     final response = await httpClient.post(
  //       '/create-exercise',
  //       data: exercise.toJson(),
  //     );
  //     final apiResponse = ApiResponse<Exercise>.fromJson(
  //       response.data,
  //       (data) => Exercise.fromJson(data),
  //     );
  //     if (apiResponse.status == 'success') {
  //       // Add the newly created exercise to the list
  //       _exercises.add(apiResponse.data!);
  //       notifyListeners();
  //     } else {
  //       print('Error: ${apiResponse.message}');
  //       throw Exception(apiResponse.message.isNotEmpty ? apiResponse.message : 'Unknown error');
  //     }
  //   } catch (e) {
  //     print('Error creating exercise: $e');
  //   }
  // }

  // // Update an exercise
  // Future<void> updateExercise(int id, Exercise updatedExercise) async {
  //   try {
  //     final response = await httpClient.put(
  //       '/exercises/$id',
  //       data: updatedExercise.toJson(),
  //     );
  //     final apiResponse = ApiResponse<Exercise>.fromJson(
  //       response.data,
  //       (data) => Exercise.fromJson(data),
  //     );
  //     if (apiResponse.status == 'success') {
  //       // Find the exercise and update it
  //       final index = _exercises.indexWhere((e) => e.exerciseId == id);
  //       if (index != -1) {
  //         _exercises[index] = apiResponse.data!;
  //         notifyListeners();
  //       }
  //     } else {
  //       print('Error: ${apiResponse.message}');
  //       throw Exception(apiResponse.message.isNotEmpty ? apiResponse.message : 'Unknown error');
  //     }
  //   } catch (e) {
  //     print('Error updating exercise: $e');
  //   }
  // }

  // // Delete an exercise
  // Future<void> deleteExercise(int id) async {
  //   try {
  //     final response = await httpClient.delete('/exercises/$id');
  //     final apiResponse = ApiResponse<Exercise>.fromJson(
  //       response.data,
  //       (data) => Exercise.fromJson(data),
  //     );
  //     if (apiResponse.status == 'success') {
  //       // Remove the deleted exercise from the list
  //       _exercises.removeWhere((e) => e.exerciseId == id);
  //       notifyListeners();
  //     } else {
  //       print('Error: ${apiResponse.message}');
  //       throw Exception(apiResponse.message.isNotEmpty ? apiResponse.message : 'Unknown error');
  //     }
  //   } catch (e) {
  //     print('Error deleting exercise: $e');
  //   }
  // }
}
