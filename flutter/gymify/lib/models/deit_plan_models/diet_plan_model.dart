import 'package:gymify/models/deit_plan_models/meal_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'diet_plan_model.g.dart';


@JsonSerializable()
class DietPlan {
    @JsonKey(name: "diet_plan_id")
    final int dietPlanId;
    @JsonKey(name: "name")
    final String name;
    @JsonKey(name: "user_id")
    final int userId;
    @JsonKey(name: "trainer_id")
    final int trainerId;
    @JsonKey(name: "calorie_goal")
    final String calorieGoal;
    @JsonKey(name: "goal_type")
    final String goalType;
    @JsonKey(name: "description")
    final String description;
    @JsonKey(name: "image")
    final String image;
    @JsonKey(name: "created_at")
    final DateTime createdAt;
    @JsonKey(name: "updated_at")
    final DateTime updatedAt;
    @JsonKey(name: "meals")
    final List<Meal> meals;

    DietPlan({
        required this.dietPlanId,
        required this.name,
        required this.userId,
        required this.trainerId,
        required this.calorieGoal,
        required this.goalType,
        required this.description,
        required this.image,
        required this.createdAt,
        required this.updatedAt,
        required this.meals,
    });

    factory DietPlan.fromJson(Map<String, dynamic> json) => _$DietPlanFromJson(json);

    Map<String, dynamic> toJson() => _$DietPlanToJson(this);
}
