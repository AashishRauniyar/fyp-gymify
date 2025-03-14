// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProgressData _$ProgressDataFromJson(Map<String, dynamic> json) => ProgressData(
      personalBestId: (json['personal_best_id'] as num).toInt(),
      weight: json['weight'] as String,
      reps: (json['reps'] as num).toInt(),
      achievedAt: DateTime.parse(json['achieved_at'] as String),
    );

Map<String, dynamic> _$ProgressDataToJson(ProgressData instance) =>
    <String, dynamic>{
      'personal_best_id': instance.personalBestId,
      'weight': instance.weight,
      'reps': instance.reps,
      'achieved_at': instance.achievedAt.toIso8601String(),
    };
