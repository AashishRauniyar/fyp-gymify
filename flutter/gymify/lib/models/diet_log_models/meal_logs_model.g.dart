// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_logs_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealLog _$MealLogFromJson(Map<String, dynamic> json) => MealLog(
      mealLogId: (json['meal_log_id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      mealId: (json['meal_id'] as num).toInt(),
      quantity: json['quantity'] as String,
      logTime: DateTime.parse(json['log_time'] as String),
      meal: Meal.fromJson(json['meal'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MealLogToJson(MealLog instance) => <String, dynamic>{
      'meal_log_id': instance.mealLogId,
      'user_id': instance.userId,
      'meal_id': instance.mealId,
      'quantity': instance.quantity,
      'log_time': instance.logTime.toIso8601String(),
      'meal': instance.meal,
    };
