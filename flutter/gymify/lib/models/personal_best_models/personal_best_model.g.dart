// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_best_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalBest _$PersonalBestFromJson(Map<String, dynamic> json) => PersonalBest(
      personalBestId: (json['personal_best_id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      supportedExerciseId: (json['supported_exercise_id'] as num).toInt(),
      weight: json['weight'] as String,
      reps: (json['reps'] as num).toInt(),
      achievedAt: DateTime.parse(json['achieved_at'] as String),
    );

Map<String, dynamic> _$PersonalBestToJson(PersonalBest instance) =>
    <String, dynamic>{
      'personal_best_id': instance.personalBestId,
      'user_id': instance.userId,
      'supported_exercise_id': instance.supportedExerciseId,
      'weight': instance.weight,
      'reps': instance.reps,
      'achieved_at': instance.achievedAt.toIso8601String(),
    };
