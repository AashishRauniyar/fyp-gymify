import 'package:flutter/material.dart';
import 'package:gymify/models/api_response.dart';
import 'package:gymify/network/http.dart';

class WorkoutLogProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  int? workoutLogId; // To store the workout log ID after logging the workout
  DateTime? startTime;
  DateTime? endTime;
  double? totalDuration;
  double? caloriesBurned;
  String? performanceNotes;

  final List<Map<String, dynamic>> loggedExercises =
      []; // Temporarily stores exercise logs

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(bool error) {
    _hasError = error;
    notifyListeners();
  }

  // Initialize workout data
  void initializeWorkout(int userId, int workoutId, DateTime workoutStartTime) {
    workoutLogId = null;
    startTime = workoutStartTime;
    endTime = null;
    totalDuration = null;
    caloriesBurned = null;
    performanceNotes = null;
    loggedExercises.clear();
    notifyListeners();
  }

  // Temporarily add exercise logs
  void addExerciseLog({
    required int exerciseId,
    required DateTime? startTime,
    required DateTime? endTime,
    required double duration,
    required double restDuration,
    required bool skipped,
  }) {
    loggedExercises.add({
      'exercise_id': exerciseId,
      'start_time': startTime?.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'exercise_duration': duration,
      'rest_duration': restDuration,
      'skipped': skipped,
    });
    notifyListeners();
  }

  // Log the workout and get workoutLogId
  Future<bool> logWorkout({
    required int userId,
    required int workoutId,
  }) async {
    _setLoading(true);
    try {
      final response = await httpClient.post(
        '/workoutlogs',
        data: {
          'user_id': userId,
          'workout_id': workoutId,
          'start_time': startTime?.toIso8601String(),
          'end_time': endTime?.toIso8601String(),
          'total_duration': totalDuration?.toStringAsFixed(2),
          'calories_burned': caloriesBurned?.toStringAsFixed(2),
          'performance_notes': performanceNotes ?? '',
        },
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.status == 'success') {
        workoutLogId = apiResponse.data['log_id'] as int?;
        debugPrint('Workout logged successfully: ${apiResponse.data}');
        return true;
      } else {
        _setError(true);
        debugPrint('Error logging workout: ${apiResponse.message}');
        return false;
      }
    } catch (e) {
      _setError(true);
      debugPrint('[WorkoutLogProvider] Error logging workout: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Log all exercises at once using bulk API
  Future<void> logAllExercises() async {
    if (workoutLogId == null) {
      debugPrint('Workout log ID is null. Cannot log exercises.');
      return;
    }

    // Prevent duplicate calls
    if (_isLoading) {
      debugPrint('Log operation already in progress. Skipping duplicate call.');
      return;
    }

    _setLoading(true);
    try {
      final response = await httpClient.post(
        '/bulkworkoutexerciseslogs',
        data: {
          'exercises': loggedExercises.map((log) {
            return {
              'workout_log_id': workoutLogId,
              ...log,
            };
          }).toList()
        },
      );

      final apiResponse = ApiResponse.fromJson(response.data, (_) => _);
      if (apiResponse.status == 'success') {
        debugPrint('All exercises logged successfully.');
      } else {
        _setError(true);
        debugPrint('Error logging exercises: ${apiResponse.message}');
      }
    } catch (e) {
      _setError(true);
      debugPrint('[WorkoutLogProvider] Error logging all exercises: $e');
    } finally {
      _setLoading(false);
    }
  }

  
  // Finalize the workout and log everything
  Future<void> finalizeWorkout({
    required int userId,
    required int workoutId,
  }) async {
    // Calculate total duration
    endTime = DateTime.now();
    totalDuration =
        (endTime?.difference(startTime ?? DateTime.now()).inSeconds ?? 0) /
            60.0;

    // Log the workout
    final isWorkoutLogged =
        await logWorkout(userId: userId, workoutId: workoutId);

    // Log all exercises
    if (isWorkoutLogged) {
      await logAllExercises();
      clearStates(); // Clear the states after logging
    }
  }

  // Clear the states after logging
  void clearStates() {
    workoutLogId = null;
    startTime = null;
    endTime = null;
    totalDuration = null;
    caloriesBurned = null;
    performanceNotes = null;
    loggedExercises.clear();
    _setError(false);
    _setLoading(false);
    notifyListeners();
  }
}
