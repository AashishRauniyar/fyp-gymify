import 'package:flutter/material.dart';
import 'package:gymify/models/api_response.dart';
import 'package:gymify/models/workout_model.dart'; // Import the Workout model.
import 'package:gymify/network/http.dart'; // Make sure the httpClient is properly set up.

class WorkoutProvider with ChangeNotifier {
  List<Workout> _workouts = [];
  List<Workout> get workouts => _workouts;

  // Fetch all workouts
  Future<void> fetchAllWorkouts() async {
    try {
      final response = await httpClient.get('/workouts'); // Adjust the endpoint to your actual API

      final apiResponse = ApiResponse<List<Workout>>.fromJson(
        response.data,
        (data) => (data as List).map((item) => Workout.fromJson(item)).toList(),
      );

      if (apiResponse.status == 'success') {
        _workouts = apiResponse.data;
        notifyListeners(); // Notify listeners when data is updated.
      } else {
        print('Error: ${apiResponse.message}');
        throw Exception(apiResponse.message.isNotEmpty ? apiResponse.message : 'Unknown error');
      }
    } catch (e) {
      print('Error fetching workouts: $e');
      throw Exception('Error fetching workouts: $e');
    }
  }

  
}
