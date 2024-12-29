// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_workout_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomWorkoutModel _$CustomWorkoutModelFromJson(Map<String, dynamic> json) =>
    CustomWorkoutModel(
      customWorkoutId: (json['custom_workout_id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      customWorkoutName: json['custom_workout_name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      customworkoutexercises: (json['customworkoutexercises'] as List<dynamic>)
          .map((e) => Customworkoutexercise.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CustomWorkoutModelToJson(CustomWorkoutModel instance) =>
    <String, dynamic>{
      'custom_workout_id': instance.customWorkoutId,
      'user_id': instance.userId,
      'custom_workout_name': instance.customWorkoutName,
      'created_at': instance.createdAt.toIso8601String(),
      'customworkoutexercises': instance.customworkoutexercises,
    };

Customworkoutexercise _$CustomworkoutexerciseFromJson(
        Map<String, dynamic> json) =>
    Customworkoutexercise(
      customWorkoutExerciseId:
          (json['custom_workout_exercise_id'] as num).toInt(),
      customWorkoutId: (json['custom_workout_id'] as num).toInt(),
      exerciseId: (json['exercise_id'] as num).toInt(),
      sets: (json['sets'] as num).toInt(),
      reps: (json['reps'] as num).toInt(),
      duration: json['duration'] as String,
      exercises: Exercise.fromJson(json['exercises'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CustomworkoutexerciseToJson(
        Customworkoutexercise instance) =>
    <String, dynamic>{
      'custom_workout_exercise_id': instance.customWorkoutExerciseId,
      'custom_workout_id': instance.customWorkoutId,
      'exercise_id': instance.exerciseId,
      'sets': instance.sets,
      'reps': instance.reps,
      'duration': instance.duration,
      'exercises': instance.exercises,
    };
