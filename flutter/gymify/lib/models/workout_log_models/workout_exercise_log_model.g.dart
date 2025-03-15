// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_exercise_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Workoutexerciseslog _$WorkoutexerciseslogFromJson(Map<String, dynamic> json) =>
    Workoutexerciseslog(
      logId: (json['log_id'] as num).toInt(),
      workoutLogId: (json['workout_log_id'] as num).toInt(),
      exerciseId: (json['exercise_id'] as num).toInt(),
      exerciseDuration: json['exercise_duration'] as String,
      restDuration: json['rest_duration'] as String,
      skipped: json['skipped'] as bool,
      exercises: Exercise.fromJson(json['exercises'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkoutexerciseslogToJson(
        Workoutexerciseslog instance) =>
    <String, dynamic>{
      'log_id': instance.logId,
      'workout_log_id': instance.workoutLogId,
      'exercise_id': instance.exerciseId,
      'exercise_duration': instance.exerciseDuration,
      'rest_duration': instance.restDuration,
      'skipped': instance.skipped,
      'exercises': instance.exercises,
    };
