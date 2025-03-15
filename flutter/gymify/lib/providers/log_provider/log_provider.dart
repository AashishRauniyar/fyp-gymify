// import 'package:flutter/material.dart';
// import 'package:gymify/models/api_response.dart';
// import 'package:gymify/network/http.dart';

// class WorkoutLogProvider with ChangeNotifier {
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   bool _hasError = false;
//   bool get hasError => _hasError;

//   int? workoutLogId; // ID of the logged workout
//   double totalDuration = 0.0; // Accumulated total duration of exercises
//   double? caloriesBurned; // Optional, calculated or entered manually
//   String? performanceNotes; // User-entered notes for workout

//   final List<Map<String, dynamic>> loggedExercises = []; // Stores exercise logs

//   void _setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }

//   void _setError(bool error) {
//     _hasError = error;
//     notifyListeners();
//   }

//   // Initialize workout data
//   void initializeWorkout() {
//     workoutLogId = null;
//     totalDuration = 0.0;
//     caloriesBurned = null;
//     performanceNotes = null;
//     loggedExercises.clear();
//     notifyListeners();
//   }

//   // Add an exercise log
//   void addExerciseLog({
//     required int exerciseId,
//     required double exerciseDuration, // Duration in minutes
//     required double restDuration, // Rest duration in minutes
//     required bool skipped, // Whether the exercise was skipped
//   }) {
//     loggedExercises.add({
//       'exercise_id': exerciseId,
//       'exercise_duration': skipped ? 0.0 : exerciseDuration,
//       'rest_duration': restDuration,
//       'skipped': skipped,
//     });

//     // Update total duration if not skipped
//     if (!skipped) {
//       totalDuration += exerciseDuration + restDuration;
//     }

//     notifyListeners();
//   }

//   // Log the workout and retrieve `workoutLogId`
//   Future<bool> logWorkout({
//     required int userId,
//     required int workoutId,
//   }) async {
//     _setLoading(true);
//     try {
//       final response = await httpClient.post(
//         '/workoutlogs',
//         data: {
//           'user_id': userId,
//           'workout_id': workoutId,
//           'total_duration': totalDuration.toStringAsFixed(2),
//           'calories_burned': caloriesBurned ?? 0.0,
//           'performance_notes': performanceNotes ?? '',
//         },
//       );

//       final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
//         response.data,
//         (data) => data as Map<String, dynamic>,
//       );

//       if (apiResponse.status == 'success') {
//         workoutLogId = apiResponse.data['log_id'] as int?;
//         debugPrint('Workout logged successfully: ${apiResponse.data}');
//         return true;
//       } else {
//         _setError(true);
//         debugPrint('Error logging workout: ${apiResponse.message}');
//         return false;
//       }
//     } catch (e) {
//       _setError(true);
//       debugPrint('Error logging workout: $e');
//       return false;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // Log all exercises for the workout
//   Future<void> logAllExercises() async {
//     if (workoutLogId == null) {
//       debugPrint('Workout log ID is null. Cannot log exercises.');
//       return;
//     }

//     _setLoading(true);
//     try {
//       final response = await httpClient.post(
//         '/bulkworkoutexerciseslogs',
//         data: {
//           'exercises': loggedExercises.map((log) {
//             return {
//               'workout_log_id': workoutLogId,
//               ...log,
//             };
//           }).toList(),
//         },
//       );

//       final apiResponse = ApiResponse.fromJson(response.data, (_) => _);
//       if (apiResponse.status == 'success') {
//         debugPrint('All exercises logged successfully.');
//       } else {
//         _setError(true);
//         debugPrint('Error logging exercises: ${apiResponse.message}');
//       }
//     } catch (e) {
//       _setError(true);
//       debugPrint('Error logging exercises: $e');
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // Finalize the workout: log the workout and exercises
//   Future<void> finalizeWorkout({
//     required int userId,
//     required int workoutId,
//   }) async {
//     // Log the workout
//     final isWorkoutLogged =
//         await logWorkout(userId: userId, workoutId: workoutId);

//     // If workout is logged successfully, log the exercises
//     if (isWorkoutLogged) {
//       await logAllExercises();
//       clearStates(); // Clear provider state after successful logging
//     }
//   }

//   // Clear the provider state
//   void clearStates() {
//     workoutLogId = null;
//     totalDuration = 0.0;
//     caloriesBurned = null;
//     performanceNotes = null;
//     loggedExercises.clear();
//     _setError(false);
//     _setLoading(false);
//     notifyListeners();
//   }

//   //!---------------------------------

//   List<Map<String, dynamic>> _userLogs = [];
//   List<Map<String, dynamic>> get userLogs => _userLogs;
//   // Fetch user logs
//   Future<void> fetchUserLogs(String userId) async {
//     _setLoading(true);
//     _setError(false);

//     try {
//       final response = await httpClient.get('/userlogs/$userId');
//       final apiResponse = ApiResponse<List<Map<String, dynamic>>>.fromJson(
//         response.data,
//         (data) => List<Map<String, dynamic>>.from(data as Iterable<dynamic>),
//       );

//       if (apiResponse.status == 'success') {
//         _userLogs = apiResponse.data;
//       } else {
//         _setError(true);
//       }
//     } catch (error) {
//       debugPrint('Error fetching user logs: $error');
//       _setError(true);
//     } finally {
//       _setLoading(false);
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:gymify/models/api_response.dart';

import 'package:gymify/models/workout_log_models/workout_log_model.dart';
import 'package:gymify/network/http.dart';

class WorkoutLogProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Current workout being logged
  int? workoutLogId;
  double totalDuration = 0.0;
  double caloriesBurned = 0.0;
  String performanceNotes = '';

  // List of exercises being logged for current workout
  final List<Map<String, dynamic>> loggedExercises = [];

  // List of past workout logs
  List<WorkoutLog> _userLogs = [];
  List<WorkoutLog> get userLogs => _userLogs;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(bool error, [String? message]) {
    _hasError = error;
    _errorMessage = message;
    notifyListeners();
  }

  // Initialize workout data
  void initializeWorkout() {
    workoutLogId = null;
    totalDuration = 0.0;
    caloriesBurned = 0.0;
    performanceNotes = '';
    loggedExercises.clear();
    notifyListeners();
  }

  // Add an exercise log
  void addExerciseLog({
    required int exerciseId,
    required double exerciseDuration,
    required double restDuration,
    required bool skipped,
  }) {
    loggedExercises.add({
      'exercise_id': exerciseId,
      'exercise_duration': skipped ? 0.0 : exerciseDuration.toStringAsFixed(2),
      'rest_duration': restDuration.toStringAsFixed(2),
      'skipped': skipped,
    });

    // Update total duration if not skipped
    if (!skipped) {
      totalDuration += exerciseDuration + restDuration;
    }

    notifyListeners();
  }

  // Update performance notes
  void updatePerformanceNotes(String notes) {
    performanceNotes = notes;
    notifyListeners();
  }

  // Update calories burned
  void updateCaloriesBurned(double calories) {
    caloriesBurned = calories;
    notifyListeners();
  }

  // Log the workout and retrieve `workoutLogId`
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
          'total_duration': totalDuration.toStringAsFixed(2),
          'calories_burned': caloriesBurned.toStringAsFixed(2),
          'performance_notes': performanceNotes,
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
        _setError(true, apiResponse.message);
        debugPrint('Error logging workout: ${apiResponse.message}');
        return false;
      }
    } catch (e) {
      _setError(true, e.toString());
      debugPrint('Error logging workout: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Log all exercises for the workout
  Future<bool> logAllExercises() async {
    if (workoutLogId == null) {
      debugPrint('Workout log ID is null. Cannot log exercises.');
      _setError(true, 'Workout log ID is null. Cannot log exercises.');
      return false;
    }

    _setLoading(true);
    try {
      final exercises = loggedExercises.map((log) {
        return {
          'workout_log_id': workoutLogId,
          ...log,
        };
      }).toList();

      final response = await httpClient.post(
        '/bulkworkoutexerciseslogs',
        data: {
          'exercises': exercises,
        },
      );

      final apiResponse = ApiResponse.fromJson(response.data, (_) => _);
      if (apiResponse.status == 'success') {
        debugPrint('All exercises logged successfully.');
        return true;
      } else {
        _setError(true, apiResponse.message);
        debugPrint('Error logging exercises: ${apiResponse.message}');
        return false;
      }
    } catch (e) {
      _setError(true, e.toString());
      debugPrint('Error logging exercises: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Finalize the workout: log the workout and exercises
  Future<bool> finalizeWorkout({
    required int userId,
    required int workoutId,
  }) async {
    // Log the workout
    final isWorkoutLogged =
        await logWorkout(userId: userId, workoutId: workoutId);

    // If workout is logged successfully, log the exercises
    if (isWorkoutLogged) {
      final exercisesLogged = await logAllExercises();
      if (exercisesLogged) {
        clearStates(); // Clear provider state after successful logging
        return true;
      }
    }
    return false;
  }

  // Clear the provider state
  void clearStates() {
    workoutLogId = null;
    totalDuration = 0.0;
    caloriesBurned = 0.0;
    performanceNotes = '';
    loggedExercises.clear();
    _setError(false);
    _setLoading(false);
    notifyListeners();
  }

  // Fetch user logs
  Future<void> fetchUserLogs(String userId) async {
    _setLoading(true);
    _setError(false);

    try {
      final response = await httpClient.get('/userlogs/$userId');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;

        if (responseData['status'] == 'success') {
          final List<dynamic> logsData = responseData['data'];
          _userLogs =
              logsData.map((logJson) => WorkoutLog.fromJson(logJson)).toList();

          // Sort logs by date (newest first)
          _userLogs.sort((a, b) => b.workoutDate.compareTo(a.workoutDate));
        } else {
          _setError(true, responseData['message']);
        }
      } else {
        _setError(true, 'Failed to fetch logs: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error fetching user logs: $error');
      _setError(true, error.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Calculate total calories burned for a workout
  double calculateTotalCalories(WorkoutLog log) {
    double total = 0;
    for (var exerciseLog in log.workoutexerciseslogs) {
      if (!exerciseLog.skipped) {
        total += (exerciseLog.exercises.caloriesBurnedPerMinute *
            int.parse(exerciseLog.exerciseDuration)) as double;
      }
    }
    return total;
  }

  // Get workouts by date range
  List<WorkoutLog> getWorkoutsByDateRange(DateTime start, DateTime end) {
    return _userLogs.where((log) {
      return log.workoutDate.isAfter(start) &&
          log.workoutDate.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  // Get workouts by target muscle group
  List<WorkoutLog> getWorkoutsByMuscleGroup(String muscleGroup) {
    return _userLogs.where((log) {
      return log.workoutexerciseslogs.any((exerciseLog) =>
          exerciseLog.exercises.targetMuscleGroup == muscleGroup);
    }).toList();
  }
}
