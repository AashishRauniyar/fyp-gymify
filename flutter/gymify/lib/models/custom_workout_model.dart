import 'package:gymify/models/exercise_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'custom_workout_model.g.dart';

@JsonSerializable()
class CustomWorkoutModel {
    @JsonKey(name: "custom_workout_id")
    final int customWorkoutId;
    @JsonKey(name: "user_id")
    final int userId;
    @JsonKey(name: "custom_workout_name")
    final String customWorkoutName;
    @JsonKey(name: "created_at")
    final DateTime createdAt;
    @JsonKey(name: "customworkoutexercises")
    final List<Customworkoutexercise> customworkoutexercises;

    CustomWorkoutModel({
        required this.customWorkoutId,
        required this.userId,
        required this.customWorkoutName,
        required this.createdAt,
        required this.customworkoutexercises,
    });

    factory CustomWorkoutModel.fromJson(Map<String, dynamic> json) => _$CustomWorkoutModelFromJson(json);

    Map<String, dynamic> toJson() => _$CustomWorkoutModelToJson(this);
}

@JsonSerializable()
class Customworkoutexercise {
    @JsonKey(name: "custom_workout_exercise_id")
    final int customWorkoutExerciseId;
    @JsonKey(name: "custom_workout_id")
    final int customWorkoutId;
    @JsonKey(name: "exercise_id")
    final int exerciseId;
    @JsonKey(name: "sets")
    final int sets;
    @JsonKey(name: "reps")
    final int reps;
    @JsonKey(name: "duration")
    final String duration;
    @JsonKey(name: "exercises")
    final Exercise exercises;

    Customworkoutexercise({
        required this.customWorkoutExerciseId,
        required this.customWorkoutId,
        required this.exerciseId,
        required this.sets,
        required this.reps,
        required this.duration,
        required this.exercises,
    });

    factory Customworkoutexercise.fromJson(Map<String, dynamic> json) => _$CustomworkoutexerciseFromJson(json);

    Map<String, dynamic> toJson() => _$CustomworkoutexerciseToJson(this);
}


