// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DietPlan _$DietPlanFromJson(Map<String, dynamic> json) => DietPlan(
      dietPlanId: (json['diet_plan_id'] as num).toInt(),
      name: json['name'] as String,
      userId: (json['user_id'] as num).toInt(),
      trainerId: (json['trainer_id'] as num).toInt(),
      calorieGoal: json['calorie_goal'] as String,
      goalType: json['goal_type'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      meals: (json['meals'] as List<dynamic>)
          .map((e) => Meal.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DietPlanToJson(DietPlan instance) => <String, dynamic>{
      'diet_plan_id': instance.dietPlanId,
      'name': instance.name,
      'user_id': instance.userId,
      'trainer_id': instance.trainerId,
      'calorie_goal': instance.calorieGoal,
      'goal_type': instance.goalType,
      'description': instance.description,
      'image': instance.image,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'meals': instance.meals,
    };
