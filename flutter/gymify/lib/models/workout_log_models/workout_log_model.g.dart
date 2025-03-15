// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutLog _$WorkoutLogFromJson(Map<String, dynamic> json) => WorkoutLog(
      logId: (json['log_id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      workoutId: (json['workout_id'] as num).toInt(),
      workoutDate: DateTime.parse(json['workout_date'] as String),
      totalDuration: json['total_duration'] as String,
      caloriesBurned: json['calories_burned'] as String,
      performanceNotes: json['performance_notes'] as String,
      workoutexerciseslogs: (json['workoutexerciseslogs'] as List<dynamic>)
          .map((e) => Workoutexerciseslog.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WorkoutLogToJson(WorkoutLog instance) =>
    <String, dynamic>{
      'log_id': instance.logId,
      'user_id': instance.userId,
      'workout_id': instance.workoutId,
      'workout_date': instance.workoutDate.toIso8601String(),
      'total_duration': instance.totalDuration,
      'calories_burned': instance.caloriesBurned,
      'performance_notes': instance.performanceNotes,
      'workoutexerciseslogs': instance.workoutexerciseslogs,
    };
