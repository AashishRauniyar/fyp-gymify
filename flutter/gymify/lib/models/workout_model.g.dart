// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Workout _$WorkoutFromJson(Map<String, dynamic> json) => Workout(
      workoutId: (json['workout_id'] as num).toInt(),
      userId: json['user_id'],
      workoutName: json['workout_name'] as String,
      description: json['description'] as String,
      targetMuscleGroup: json['target_muscle_group'] as String,
      difficulty: json['difficulty'] as String,
      goalType: json['goal_type'] as String,
      fitnessLevel: json['fitness_level'] as String,
      workoutImage: json['workout_image'] as String? ?? '',
      trainerId: (json['trainer_id'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      workoutexercises: (json['workoutexercises'] as List<dynamic>)
          .map((e) => Workoutexercise.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WorkoutToJson(Workout instance) => <String, dynamic>{
      'workout_id': instance.workoutId,
      'user_id': instance.userId,
      'workout_name': instance.workoutName,
      'description': instance.description,
      'target_muscle_group': instance.targetMuscleGroup,
      'difficulty': instance.difficulty,
      'goal_type': instance.goalType,
      'fitness_level': instance.fitnessLevel,
      'workout_image': instance.workoutImage,
      'trainer_id': instance.trainerId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'workoutexercises': instance.workoutexercises,
    };

Workoutexercise _$WorkoutexerciseFromJson(Map<String, dynamic> json) =>
    Workoutexercise(
      workoutExerciseId: (json['workout_exercise_id'] as num).toInt(),
      workoutId: (json['workout_id'] as num).toInt(),
      exerciseId: (json['exercise_id'] as num).toInt(),
      sets: (json['sets'] as num).toInt(),
      reps: (json['reps'] as num).toInt(),
      duration: json['duration'] as String,
      exercises: json['exercises'] == null
          ? null
          : Exercise.fromJson(json['exercises'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkoutexerciseToJson(Workoutexercise instance) =>
    <String, dynamic>{
      'workout_exercise_id': instance.workoutExerciseId,
      'workout_id': instance.workoutId,
      'exercise_id': instance.exerciseId,
      'sets': instance.sets,
      'reps': instance.reps,
      'duration': instance.duration,
      'exercises': instance.exercises,
    };
