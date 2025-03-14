// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_progress_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseProgress _$ExerciseProgressFromJson(Map<String, dynamic> json) =>
    ExerciseProgress(
      exercise:
          SupportedExercise.fromJson(json['exercise'] as Map<String, dynamic>),
      progressData: (json['progressData'] as List<dynamic>)
          .map((e) => ProgressData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExerciseProgressToJson(ExerciseProgress instance) =>
    <String, dynamic>{
      'exercise': instance.exercise,
      'progressData': instance.progressData,
    };
