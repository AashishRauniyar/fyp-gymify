// import 'package:json_annotation/json_annotation.dart';

// part 'workout_model.g.dart';

// @JsonSerializable()
// class Workout {
//   @JsonKey(name: "workout_id")
//   final int workoutId;
//   @JsonKey(name: "user_id")
//   final dynamic userId;
//   @JsonKey(name: "workout_name")
//   final String workoutName;
//   @JsonKey(name: "description")
//   final String description;
//   @JsonKey(name: "target_muscle_group")
//   final String targetMuscleGroup;
//   @JsonKey(name: "difficulty")
//   final String difficulty;
//   @JsonKey(name: "goal_type")
//   final String goalType;  // Added new field for goal_type
//   @JsonKey(name: "fitness_level")
//   final String fitnessLevel;
//   @JsonKey(name: "workout_image")
//   final String workoutImage;  // Added new field for fitness_level
//   @JsonKey(name: "trainer_id")
//   final int trainerId;
//   @JsonKey(name: "created_at")
//   final DateTime createdAt;
//   @JsonKey(name: "updated_at")
//   final DateTime updatedAt;
//   @JsonKey(name: "workoutexercises", defaultValue: [])
//   final List<Workoutexercise> workoutexercises;

//   Workout({
//     required this.workoutId,
//     required this.userId,
//     required this.workoutName,
//     required this.description,
//     required this.targetMuscleGroup,
//     required this.difficulty,
//     required this.goalType,  // Add goalType to constructor
//     required this.fitnessLevel,  // Add fitnessLevel to constructor
//     this.workoutImage = "",  // Add workout_image to constructor
//     required this.trainerId,
//     required this.createdAt,
//     required this.updatedAt,
//     this.workoutexercises = const [],
//   });

//   factory Workout.fromJson(Map<String, dynamic> json) => _$WorkoutFromJson(json);

//   Map<String, dynamic> toJson() => _$WorkoutToJson(this);
// }

// @JsonSerializable()
// class Workoutexercise {
//   @JsonKey(name: "workout_exercise_id")
//   final int workoutExerciseId;
//   @JsonKey(name: "workout_id")
//   final int workoutId;
//   @JsonKey(name: "exercise_id")
//   final int exerciseId;
//   @JsonKey(name: "sets")
//   final int sets;
//   @JsonKey(name: "reps")
//   final int reps;
//   @JsonKey(name: "duration")
//   final String duration;

//   Workoutexercise({
//     required this.workoutExerciseId,
//     required this.workoutId,
//     required this.exerciseId,
//     required this.sets,
//     required this.reps,
//     required this.duration,
//   });

//   factory Workoutexercise.fromJson(Map<String, dynamic> json) => _$WorkoutexerciseFromJson(json);

//   Map<String, dynamic> toJson() => _$WorkoutexerciseToJson(this);
// }


import 'package:json_annotation/json_annotation.dart';

part 'workout_model.g.dart';

@JsonSerializable()
class Workout {
  @JsonKey(name: "workout_id")
  final int workoutId;

  @JsonKey(name: "user_id", defaultValue: null)
  final dynamic userId; // Can handle null values

  @JsonKey(name: "workout_name")
  final String workoutName;

  @JsonKey(name: "description")
  final String description;

  @JsonKey(name: "target_muscle_group")
  final String targetMuscleGroup;

  @JsonKey(name: "difficulty")
  final String difficulty;

  @JsonKey(name: "goal_type")
  final String goalType;

  @JsonKey(name: "fitness_level")
  final String fitnessLevel;

  @JsonKey(name: "workout_image", defaultValue: "")
  final String workoutImage;

  @JsonKey(name: "trainer_id")
  final int trainerId;

  @JsonKey(name: "created_at")
  final DateTime createdAt;

  @JsonKey(name: "updated_at")
  final DateTime updatedAt;

  @JsonKey(name: "workoutexercises", defaultValue: [])
  final List<Workoutexercise> workoutexercises;

  Workout({
    required this.workoutId,
    this.userId, // Can be null
    required this.workoutName,
    required this.description,
    required this.targetMuscleGroup,
    required this.difficulty,
    required this.goalType,
    required this.fitnessLevel,
    this.workoutImage = "",
    required this.trainerId,
    required this.createdAt,
    required this.updatedAt,
    this.workoutexercises = const [],
  });

  factory Workout.fromJson(Map<String, dynamic> json) =>
      _$WorkoutFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutToJson(this);
}

@JsonSerializable()
class Workoutexercise {
  @JsonKey(name: "workout_exercise_id")
  final int workoutExerciseId;

  @JsonKey(name: "workout_id")
  final int workoutId;

  @JsonKey(name: "exercise_id")
  final int exerciseId;

  @JsonKey(name: "sets")
  final int sets;

  @JsonKey(name: "reps")
  final int reps;

  @JsonKey(name: "duration", defaultValue: "0")
  final String duration; // Default to "0" if null

  Workoutexercise({
    required this.workoutExerciseId,
    required this.workoutId,
    required this.exerciseId,
    required this.sets,
    required this.reps,
    this.duration = "0",
  });

  factory Workoutexercise.fromJson(Map<String, dynamic> json) =>
      _$WorkoutexerciseFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutexerciseToJson(this);
}
