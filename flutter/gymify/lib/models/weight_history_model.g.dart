// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeightHistory _$WeightHistoryFromJson(Map<String, dynamic> json) =>
    WeightHistory(
      weight: json['weight'] as String,
      loggedAt: DateTime.parse(json['logged_at'] as String),
    );

Map<String, dynamic> _$WeightHistoryToJson(WeightHistory instance) =>
    <String, dynamic>{
      'weight': instance.weight,
      'logged_at': instance.loggedAt.toIso8601String(),
    };
