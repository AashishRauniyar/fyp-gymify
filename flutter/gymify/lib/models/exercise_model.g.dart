// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Exercise _$ExerciseFromJson(Map<String, dynamic> json) => Exercise(
      exerciseId: (json['exercise_id'] as num).toInt(),
      exerciseName: json['exercise_name'] as String,
      description: json['description'] as String,
      targetMuscleGroup: json['target_muscle_group'] as String,
      caloriesBurnedPerMinute: json['calories_burned_per_minute'] as String,
      imageUrl: json['image_url'] as String,
      videoUrl: json['video_url'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ExerciseToJson(Exercise instance) => <String, dynamic>{
      'exercise_id': instance.exerciseId,
      'exercise_name': instance.exerciseName,
      'description': instance.description,
      'target_muscle_group': instance.targetMuscleGroup,
      'calories_burned_per_minute': instance.caloriesBurnedPerMinute,
      'image_url': instance.imageUrl,
      'video_url': instance.videoUrl,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
