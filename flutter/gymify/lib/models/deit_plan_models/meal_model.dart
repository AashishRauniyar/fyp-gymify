import 'package:json_annotation/json_annotation.dart';

part 'meal_model.g.dart';


@JsonSerializable()
class Meal {
    @JsonKey(name: "meal_id")
    final int mealId;
    @JsonKey(name: "diet_plan_id")
    final int dietPlanId;
    @JsonKey(name: "meal_name")
    final String mealName;
    @JsonKey(name: "meal_time")
    final String mealTime;
    @JsonKey(name: "calories")
    final String calories;
    @JsonKey(name: "description")
    final String description;
    @JsonKey(name: "macronutrients")
    final String macronutrients;
    @JsonKey(name: "created_at")
    final DateTime createdAt;

    Meal({
        required this.mealId,
        required this.dietPlanId,
        required this.mealName,
        required this.mealTime,
        required this.calories,
        required this.description,
        required this.macronutrients,
        required this.createdAt,
    });

    factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);

    Map<String, dynamic> toJson() => _$MealToJson(this);
}
