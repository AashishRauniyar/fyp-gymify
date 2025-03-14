// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supported_exercise_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportedExercise _$SupportedExerciseFromJson(Map<String, dynamic> json) =>
    SupportedExercise(
      supportedSupportedExerciseId:
          (json['supported_suppoSupportedExercise_id'] as num).toInt(),
      suppoSupportedExerciseName: json['suppoSupportedExercise_name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$SupportedExerciseToJson(SupportedExercise instance) =>
    <String, dynamic>{
      'supported_suppoSupportedExercise_id':
          instance.supportedSupportedExerciseId,
      'suppoSupportedExercise_name': instance.suppoSupportedExerciseName,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
