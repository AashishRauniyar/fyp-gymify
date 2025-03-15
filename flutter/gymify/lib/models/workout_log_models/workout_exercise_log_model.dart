import 'package:gymify/models/exercise_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'workout_exercise_log_model.g.dart';

@JsonSerializable()
class Workoutexerciseslog {
    @JsonKey(name: "log_id")
    final int logId;
    @JsonKey(name: "workout_log_id")
    final int workoutLogId;
    @JsonKey(name: "exercise_id")
    final int exerciseId;
    @JsonKey(name: "exercise_duration")
    final String exerciseDuration;
    @JsonKey(name: "rest_duration")
    final String restDuration;
    @JsonKey(name: "skipped")
    final bool skipped;
    @JsonKey(name: "exercises")
    final Exercise exercises;

    Workoutexerciseslog({
        required this.logId,
        required this.workoutLogId,
        required this.exerciseId,
        required this.exerciseDuration,
        required this.restDuration,
        required this.skipped,
        required this.exercises,
    });

    factory Workoutexerciseslog.fromJson(Map<String, dynamic> json) => _$WorkoutexerciseslogFromJson(json);

    Map<String, dynamic> toJson() => _$WorkoutexerciseslogToJson(this);
}
