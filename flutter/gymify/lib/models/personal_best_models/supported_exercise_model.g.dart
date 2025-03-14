// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supported_exercise_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportedExercise _$SupportedExerciseFromJson(Map<String, dynamic> json) =>
    SupportedExercise(
      supportedExerciseId: (json['supported_exercise_id'] as num).toInt(),
      exerciseName: json['exercise_name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$SupportedExerciseToJson(SupportedExercise instance) =>
    <String, dynamic>{
      'supported_exercise_id': instance.supportedExerciseId,
      'exercise_name': instance.exerciseName,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
