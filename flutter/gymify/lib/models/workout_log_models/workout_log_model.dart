import 'package:gymify/models/workout_log_models/workout_exercise_log_model.dart';
import 'package:json_annotation/json_annotation.dart';


part 'workout_log_model.g.dart';

@JsonSerializable()
class WorkoutLog {
    @JsonKey(name: "log_id")
    final int logId;
    @JsonKey(name: "user_id")
    final int userId;
    @JsonKey(name: "workout_id")
    final int workoutId;
    @JsonKey(name: "workout_date")
    final DateTime workoutDate;
    @JsonKey(name: "total_duration")
    final String totalDuration;
    @JsonKey(name: "calories_burned")
    final String caloriesBurned;
    @JsonKey(name: "performance_notes")
    final String performanceNotes;
    @JsonKey(name: "workoutexerciseslogs")
    final List<Workoutexerciseslog> workoutexerciseslogs;

    WorkoutLog({
        required this.logId,
        required this.userId,
        required this.workoutId,
        required this.workoutDate,
        required this.totalDuration,
        required this.caloriesBurned,
        required this.performanceNotes,
        required this.workoutexerciseslogs,
    });

    factory WorkoutLog.fromJson(Map<String, dynamic> json) => _$WorkoutLogFromJson(json);

    Map<String, dynamic> toJson() => _$WorkoutLogToJson(this);
}
