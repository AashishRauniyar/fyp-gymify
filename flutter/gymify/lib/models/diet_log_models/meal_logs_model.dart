import 'package:json_annotation/json_annotation.dart';
import 'package:gymify/models/deit_plan_models/meal_model.dart';

part 'meal_logs_model.g.dart';




@JsonSerializable()
class MealLog {
    @JsonKey(name: "meal_log_id")
    final int mealLogId;
    @JsonKey(name: "user_id")
    final int userId;
    @JsonKey(name: "meal_id")
    final int mealId;
    @JsonKey(name: "quantity")
    final String quantity;
    @JsonKey(name: "log_time")
    final DateTime logTime;
    @JsonKey(name: "meal")
    final Meal meal;

    MealLog({
        required this.mealLogId,
        required this.userId,
        required this.mealId,
        required this.quantity,
        required this.logTime,
        required this.meal,
    });

    factory MealLog.fromJson(Map<String, dynamic> json) => _$MealLogFromJson(json);

    Map<String, dynamic> toJson() => _$MealLogToJson(this);
}
