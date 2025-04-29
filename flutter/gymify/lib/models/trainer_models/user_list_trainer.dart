import 'dart:convert';
import 'package:gymify/models/deit_plan_models/diet_plan_model.dart';
import 'package:gymify/models/exercise_model.dart';

class UserStats {
  final UserProfile userProfile;
  final WeightStats weightStats;
  final WorkoutStats workoutStats;
  final NutritionStats nutritionStats;
  final PerformanceStats performanceStats;
  final MembershipInfo? membershipInfo;
  final AttendanceStats attendanceStats;

  UserStats({
    required this.userProfile,
    required this.weightStats,
    required this.workoutStats,
    required this.nutritionStats,
    required this.performanceStats,
    this.membershipInfo,
    required this.attendanceStats,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      userProfile: UserProfile.fromJson(json['userProfile']),
      weightStats: WeightStats.fromJson(json['weightStats']),
      workoutStats: WorkoutStats.fromJson(json['workoutStats']),
      nutritionStats: NutritionStats.fromJson(json['nutritionStats']),
      performanceStats: PerformanceStats.fromJson(json['performanceStats']),
      membershipInfo: json['membershipInfo'] != null
          ? MembershipInfo.fromJson(json['membershipInfo'])
          : null,
      attendanceStats: AttendanceStats.fromJson(json['attendanceStats']),
    );
  }
}

class UserProfile {
  final String? userName;
  final String? fullName;
  final DateTime? birthdate;
  final double? height;
  final double? currentWeight;
  final String? gender;
  final String email;
  final String? fitnessLevel;
  final String? goalType;
  final String? allergies;
  final double? calorieGoals;
  final String? profileImage;

  UserProfile({
    this.userName,
    this.fullName,
    this.birthdate,
    this.height,
    this.currentWeight,
    this.gender,
    required this.email,
    this.fitnessLevel,
    this.goalType,
    this.allergies,
    this.calorieGoals,
    this.profileImage,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userName: json['user_name'],
      fullName: json['full_name'],
      birthdate:
          json['birthdate'] != null ? DateTime.parse(json['birthdate']) : null,
      height: json['height'] != null
          ? double.parse(json['height'].toString())
          : null,
      currentWeight: json['current_weight'] != null
          ? double.parse(json['current_weight'].toString())
          : null,
      gender: json['gender'],
      email: json['email'],
      fitnessLevel: json['fitness_level'],
      goalType: json['goal_type'],
      allergies: json['allergies'],
      calorieGoals: json['calorie_goals'] != null
          ? double.parse(json['calorie_goals'].toString())
          : null,
      profileImage: json['profile_image'],
    );
  }
}

class WeightLog {
  final int id;
  final int userId;
  final double weight;
  final DateTime loggedAt;

  WeightLog({
    required this.id,
    required this.userId,
    required this.weight,
    required this.loggedAt,
  });

  factory WeightLog.fromJson(Map<String, dynamic> json) {
    return WeightLog(
      id: json['id'],
      userId: json['user_id'],
      weight: double.parse(json['weight'].toString()),
      loggedAt: DateTime.parse(json['logged_at']),
    );
  }
}

class WeightStats {
  final double? currentWeight;
  final List<WeightLog> weightLogs;
  final double? weightProgress;

  WeightStats({
    this.currentWeight,
    required this.weightLogs,
    this.weightProgress,
  });

  factory WeightStats.fromJson(Map<String, dynamic> json) {
    return WeightStats(
      currentWeight: json['currentWeight'] != null
          ? double.parse(json['currentWeight'].toString())
          : null,
      weightLogs: (json['weightLogs'] as List)
          .map((log) => WeightLog.fromJson(log))
          .toList(),
      weightProgress: json['weightProgress'] != null
          ? double.parse(json['weightProgress'].toString())
          : null,
    );
  }
}

// class WorkoutLogEntry {
//   final int logId;
//   final int? userId;
//   final int? workoutId;
//   final DateTime workoutDate;
//   final double? totalDuration;
//   final double? caloriesBurned;
//   final String? performanceNotes;
//   final WorkoutSummary? workout;

//   WorkoutLogEntry({
//     required this.logId,
//     this.userId,
//     this.workoutId,
//     required this.workoutDate,
//     this.totalDuration,
//     this.caloriesBurned,
//     this.performanceNotes,
//     this.workout,
//   });

//   factory WorkoutLogEntry.fromJson(Map<String, dynamic> json) {
//     return WorkoutLogEntry(
//       logId: json['log_id'],
//       userId: json['user_id'],
//       workoutId: json['workout_id'],
//       workoutDate: DateTime.parse(json['workout_date']),
//       totalDuration: json['total_duration'] != null
//           ? double.parse(json['total_duration'].toString())
//           : null,
//       caloriesBurned: json['calories_burned'] != null
//           ? double.parse(json['calories_burned'].toString())
//           : null,
//       performanceNotes: json['performance_notes'],
//       workout: json['workouts'] != null
//           ? WorkoutSummary.fromJson(json['workouts'])
//           : null,
//     );
//   }
// }

class WorkoutLogEntry {
  final int logId;
  final int? userId;
  final int? workoutId;
  final DateTime workoutDate;
  final double? totalDuration;
  final double? caloriesBurned;
  final String? performanceNotes;
  final WorkoutSummary? workout;
  final List<WorkoutExerciseLog>? workoutexerciseslogs; // Added this field

  WorkoutLogEntry({
    required this.logId,
    this.userId,
    this.workoutId,
    required this.workoutDate,
    this.totalDuration,
    this.caloriesBurned,
    this.performanceNotes,
    this.workout,
    this.workoutexerciseslogs, // Added this parameter
  });

  factory WorkoutLogEntry.fromJson(Map<String, dynamic> json) {
    return WorkoutLogEntry(
      logId: json['log_id'],
      userId: json['user_id'],
      workoutId: json['workout_id'],
      workoutDate: DateTime.parse(json['workout_date']),
      totalDuration: json['total_duration'] != null
          ? double.parse(json['total_duration'].toString())
          : null,
      caloriesBurned: json['calories_burned'] != null
          ? double.parse(json['calories_burned'].toString())
          : null,
      performanceNotes: json['performance_notes'],
      workout: json['workouts'] != null
          ? WorkoutSummary.fromJson(json['workouts'])
          : null,
      // Parse the workoutexerciseslogs field
      workoutexerciseslogs: json['workoutexerciseslogs'] != null
          ? (json['workoutexerciseslogs'] as List)
              .map((e) => WorkoutExerciseLog.fromJson(e))
              .toList()
          : null,
    );
  }
}

class WorkoutExerciseLog {
  final int logId;
  final int? workoutLogId;
  final int? exerciseId;
  final double? exerciseDuration;
  final double? restDuration;
  final bool? skipped;
  final Exercise? exercises;

  WorkoutExerciseLog({
    required this.logId,
    this.workoutLogId,
    this.exerciseId,
    this.exerciseDuration,
    this.restDuration,
    this.skipped,
    this.exercises,
  });

  factory WorkoutExerciseLog.fromJson(Map<String, dynamic> json) {
    return WorkoutExerciseLog(
      logId: json['log_id'],
      workoutLogId: json['workout_log_id'],
      exerciseId: json['exercise_id'],
      exerciseDuration: json['exercise_duration'] != null
          ? double.parse(json['exercise_duration'].toString())
          : null,
      restDuration: json['rest_duration'] != null
          ? double.parse(json['rest_duration'].toString())
          : null,
      skipped: json['skipped'],
      exercises: json['exercises'] != null
          ? Exercise.fromJson(json['exercises'])
          : null,
    );
  }
}

class WorkoutSummary {
  final String workoutName;
  final String targetMuscleGroup;
  final String difficulty;
  final String goalType;

  WorkoutSummary({
    required this.workoutName,
    required this.targetMuscleGroup,
    required this.difficulty,
    required this.goalType,
  });

  factory WorkoutSummary.fromJson(Map<String, dynamic> json) {
    return WorkoutSummary(
      workoutName: json['workout_name'],
      targetMuscleGroup: json['target_muscle_group'],
      difficulty: json['difficulty'],
      goalType: json['goal_type'],
    );
  }
}

class WorkoutStats {
  final int totalWorkouts;
  final double totalDuration;
  final double totalCaloriesBurned;
  final List<WorkoutLogEntry> recentWorkouts;

  WorkoutStats({
    required this.totalWorkouts,
    required this.totalDuration,
    required this.totalCaloriesBurned,
    required this.recentWorkouts,
  });

  factory WorkoutStats.fromJson(Map<String, dynamic> json) {
    return WorkoutStats(
      totalWorkouts: json['totalWorkouts'],
      totalDuration: double.parse(json['totalDuration'].toString()),
      totalCaloriesBurned: double.parse(json['totalCaloriesBurned'].toString()),
      recentWorkouts: (json['recentWorkouts'] as List)
          .map((workout) => WorkoutLogEntry.fromJson(workout))
          .toList(),
    );
  }
}

class MealLogEntry {
  final int mealLogId;
  final int userId;
  final int mealId;
  final double quantity;
  final DateTime logTime;
  final MealSummary? meal;

  MealLogEntry({
    required this.mealLogId,
    required this.userId,
    required this.mealId,
    required this.quantity,
    required this.logTime,
    this.meal,
  });

  factory MealLogEntry.fromJson(Map<String, dynamic> json) {
    return MealLogEntry(
      mealLogId: json['meal_log_id'],
      userId: json['user_id'],
      mealId: json['meal_id'],
      quantity: double.parse(json['quantity'].toString()),
      logTime: DateTime.parse(json['log_time']),
      meal: json['meal'] != null ? MealSummary.fromJson(json['meal']) : null,
    );
  }
}

// class MealSummary {
//   final int mealId;
//   final String mealName;
//   final String mealTime;
//   final double calories;
//   final Map<String, dynamic>? macronutrients;
//   final DietPlanSummary? dietplan;

//   MealSummary({
//     required this.mealId,
//     required this.mealName,
//     required this.mealTime,
//     required this.calories,
//     this.macronutrients,
//     this.dietplan,
//   });

//   factory MealSummary.fromJson(Map<String, dynamic> json) {
//     return MealSummary(
//       mealId: json['meal_id'],
//       mealName: json['meal_name'],
//       mealTime: json['meal_time'],
//       calories: double.parse(json['calories'].toString()),
//       macronutrients: json['macronutrients'] as Map<String, dynamic>?,
//       dietplan: json['dietplan'] != null
//           ? DietPlanSummary.fromJson(json['dietplan'])
//           : null,
//     );
//   }
// }

class MealSummary {
  final int mealId;
  final String mealName;
  final String mealTime;
  final double calories;
  final Map<String, dynamic>? macronutrients;
  final DietPlanSummary? dietplan;

  MealSummary({
    required this.mealId,
    required this.mealName,
    required this.mealTime,
    required this.calories,
    this.macronutrients,
    this.dietplan,
  });

  factory MealSummary.fromJson(Map<String, dynamic> json) {
    // Handle macronutrients which might be a string or a map
    Map<String, dynamic>? parsedMacros;

    if (json['macronutrients'] != null) {
      if (json['macronutrients'] is String) {
        // Try to parse the JSON string
        try {
          parsedMacros = Map<String, dynamic>.from(
              jsonDecode(json['macronutrients'] as String));
        } catch (e) {
          print('Error parsing macronutrients: $e');
          parsedMacros = null;
        }
      } else if (json['macronutrients'] is Map) {
        parsedMacros = Map<String, dynamic>.from(json['macronutrients'] as Map);
      }
    }

    return MealSummary(
      mealId: json['meal_id'],
      mealName: json['meal_name'],
      mealTime: json['meal_time'],
      calories: double.parse(json['calories'].toString()),
      macronutrients: parsedMacros,
      dietplan: json['dietplan'] != null
          ? DietPlanSummary.fromJson(json['dietplan'])
          : null,
    );
  }
}

class DietPlanSummary {
  final int dietPlanId;
  final String name;
  final double? calorieGoal;
  final String goalType;

  DietPlanSummary({
    required this.dietPlanId,
    required this.name,
    this.calorieGoal,
    required this.goalType,
  });

  factory DietPlanSummary.fromJson(Map<String, dynamic> json) {
    return DietPlanSummary(
      dietPlanId: json['diet_plan_id'],
      name: json['name'],
      calorieGoal: json['calorie_goal'] != null
          ? double.parse(json['calorie_goal'].toString())
          : null,
      goalType: json['goal_type'],
    );
  }
}

class NutritionStats {
  final List<DietPlan> dietPlans;
  final int totalMealsLogged;
  final double caloriesConsumed;
  final List<MealLogEntry> recentMealLogs;

  NutritionStats({
    required this.dietPlans,
    required this.totalMealsLogged,
    required this.caloriesConsumed,
    required this.recentMealLogs,
  });

  factory NutritionStats.fromJson(Map<String, dynamic> json) {
    return NutritionStats(
      dietPlans: (json['dietPlans'] as List)
          .map((plan) => DietPlan.fromJson(plan))
          .toList(),
      totalMealsLogged: json['totalMealsLogged'],
      caloriesConsumed: double.parse(json['caloriesConsumed'].toString()),
      recentMealLogs: (json['recentMealLogs'] as List)
          .map((log) => MealLogEntry.fromJson(log))
          .toList(),
    );
  }
}

class PersonalBest {
  final int personalBestId;
  final int userId;
  final int supportedExerciseId;
  final double weight;
  final int reps;
  final DateTime achievedAt;
  final SupportedExercise supportedExercise;

  PersonalBest({
    required this.personalBestId,
    required this.userId,
    required this.supportedExerciseId,
    required this.weight,
    required this.reps,
    required this.achievedAt,
    required this.supportedExercise,
  });

  factory PersonalBest.fromJson(Map<String, dynamic> json) {
    return PersonalBest(
      personalBestId: json['personal_best_id'],
      userId: json['user_id'],
      supportedExerciseId: json['supported_exercise_id'],
      weight: double.parse(json['weight'].toString()),
      reps: json['reps'],
      achievedAt: DateTime.parse(json['achieved_at']),
      supportedExercise:
          SupportedExercise.fromJson(json['supported_exercises']),
    );
  }
}

class SupportedExercise {
  final int supportedExerciseId;
  final String exerciseName;

  SupportedExercise({
    required this.supportedExerciseId,
    required this.exerciseName,
  });

  factory SupportedExercise.fromJson(Map<String, dynamic> json) {
    return SupportedExercise(
      supportedExerciseId: json['supported_exercise_id'],
      exerciseName: json['exercise_name'],
    );
  }
}

class PerformanceStats {
  final List<PersonalBest> personalBests;

  PerformanceStats({
    required this.personalBests,
  });

  factory PerformanceStats.fromJson(Map<String, dynamic> json) {
    return PerformanceStats(
      personalBests: (json['personalBests'] as List)
          .map((best) => PersonalBest.fromJson(best))
          .toList(),
    );
  }
}

class MembershipInfo {
  final int membershipId;
  final DateTime? startDate;
  final DateTime? endDate;
  final String status;
  final MembershipPlan membershipPlan;

  MembershipInfo({
    required this.membershipId,
    this.startDate,
    this.endDate,
    required this.status,
    required this.membershipPlan,
  });

  factory MembershipInfo.fromJson(Map<String, dynamic> json) {
    return MembershipInfo(
      membershipId: json['membership_id'],
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      status: json['status'],
      membershipPlan: MembershipPlan.fromJson(json['membership_plan']),
    );
  }
}

class MembershipPlan {
  final int planId;
  final String planType;
  final double price;
  final int duration;
  final String description;

  MembershipPlan({
    required this.planId,
    required this.planType,
    required this.price,
    required this.duration,
    required this.description,
  });

  factory MembershipPlan.fromJson(Map<String, dynamic> json) {
    return MembershipPlan(
      planId: json['plan_id'],
      planType: json['plan_type'],
      price: double.parse(json['price'].toString()),
      duration: json['duration'],
      description: json['description'],
    );
  }
}

class AttendanceStats {
  final int totalAttendances;
  final DateTime? lastAttendance;

  AttendanceStats({
    required this.totalAttendances,
    this.lastAttendance,
  });

  factory AttendanceStats.fromJson(Map<String, dynamic> json) {
    return AttendanceStats(
      totalAttendances: json['totalAttendances'],
      lastAttendance: json['lastAttendance'] != null
          ? DateTime.parse(json['lastAttendance'])
          : null,
    );
  }
}

// Model for users list
class UserListItem {
  final int userId;
  final String? userName;
  final String? fullName;
  final String email;
  final String? profileImage;
  final String? fitnessLevel;
  final String? goalType;

  UserListItem({
    required this.userId,
    this.userName,
    this.fullName,
    required this.email,
    this.profileImage,
    this.fitnessLevel,
    this.goalType,
  });

  factory UserListItem.fromJson(Map<String, dynamic> json) {
    return UserListItem(
      userId: json['user_id'],
      userName: json['user_name'],
      fullName: json['full_name'],
      email: json['email'],
      profileImage: json['profile_image'],
      fitnessLevel: json['fitness_level'],
      goalType: json['goal_type'],
    );
  }
}

// Model for summary statistics
class StatsSummary {
  final int totalMembers;
  final int totalWorkoutsCompleted;
  final int totalDietPlans;
  final int recentAttendance;
  final List<GoalTypeCount> usersByGoalType;
  final List<FitnessLevelCount> usersByFitnessLevel;

  StatsSummary({
    required this.totalMembers,
    required this.totalWorkoutsCompleted,
    required this.totalDietPlans,
    required this.recentAttendance,
    required this.usersByGoalType,
    required this.usersByFitnessLevel,
  });

  factory StatsSummary.fromJson(Map<String, dynamic> json) {
    return StatsSummary(
      totalMembers: json['totalMembers'],
      totalWorkoutsCompleted: json['totalWorkoutsCompleted'],
      totalDietPlans: json['totalDietPlans'],
      recentAttendance: json['recentAttendance'],
      usersByGoalType: (json['usersByGoalType'] as List)
          .map((item) => GoalTypeCount.fromJson(item))
          .toList(),
      usersByFitnessLevel: (json['usersByFitnessLevel'] as List)
          .map((item) => FitnessLevelCount.fromJson(item))
          .toList(),
    );
  }
}

class GoalTypeCount {
  final String goalType;
  final int count;

  GoalTypeCount({required this.goalType, required this.count});

  factory GoalTypeCount.fromJson(Map<String, dynamic> json) {
    return GoalTypeCount(
      goalType: json['goal_type'],
      count: json['_count'],
    );
  }
}

class FitnessLevelCount {
  final String fitnessLevel;
  final int count;

  FitnessLevelCount({required this.fitnessLevel, required this.count});

  factory FitnessLevelCount.fromJson(Map<String, dynamic> json) {
    return FitnessLevelCount(
      fitnessLevel: json['fitness_level'],
      count: json['_count'],
    );
  }
}
