// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meal _$MealFromJson(Map<String, dynamic> json) => Meal(
      mealId: (json['meal_id'] as num).toInt(),
      dietPlanId: (json['diet_plan_id'] as num).toInt(),
      image: json['image'] as String,
      mealName: json['meal_name'] as String,
      mealTime: json['meal_time'] as String,
      calories: json['calories'] as String,
      description: json['description'] as String,
      macronutrients: json['macronutrients'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$MealToJson(Meal instance) => <String, dynamic>{
      'meal_id': instance.mealId,
      'diet_plan_id': instance.dietPlanId,
      'image': instance.image,
      'meal_name': instance.mealName,
      'meal_time': instance.mealTime,
      'calories': instance.calories,
      'description': instance.description,
      'macronutrients': instance.macronutrients,
      'created_at': instance.createdAt.toIso8601String(),
    };
