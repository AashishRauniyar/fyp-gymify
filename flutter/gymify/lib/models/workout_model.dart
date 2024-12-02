import 'package:json_annotation/json_annotation.dart';


part 'workout_model.g.dart';



@JsonSerializable()
class Workout {
    @JsonKey(name: "workout_id")
    final int workoutId;
    @JsonKey(name: "user_id")
    final dynamic userId;
    @JsonKey(name: "workout_name")
    final String workoutName;
    @JsonKey(name: "description")
    final String description;
    @JsonKey(name: "target_muscle_group")
    final String targetMuscleGroup;
    @JsonKey(name: "difficulty")
    final String difficulty;
    @JsonKey(name: "trainer_id")
    final int trainerId;
    @JsonKey(name: "created_at")
    final DateTime createdAt;
    @JsonKey(name: "updated_at")
    final DateTime updatedAt;
    @JsonKey(name: "workoutexercises")
    final List<Workoutexercise> workoutexercises;

    Workout({
        required this.workoutId,
        required this.userId,
        required this.workoutName,
        required this.description,
        required this.targetMuscleGroup,
        required this.difficulty,
        required this.trainerId,
        required this.createdAt,
        required this.updatedAt,
        required this.workoutexercises,
    });

    factory Workout.fromJson(Map<String, dynamic> json) => _$WorkoutFromJson(json);

    Map<String, dynamic> toJson() => _$WorkoutToJson(this);
}

@JsonSerializable()
class Workoutexercise {
    @JsonKey(name: "workout_exercise_id")
    final int workoutExerciseId;
    @JsonKey(name: "workout_id")
    final int workoutId;
    @JsonKey(name: "exercise_id")
    final int exerciseId;
    @JsonKey(name: "sets")
    final int sets;
    @JsonKey(name: "reps")
    final int reps;
    @JsonKey(name: "duration")
    final String duration;

    Workoutexercise({
        required this.workoutExerciseId,
        required this.workoutId,
        required this.exerciseId,
        required this.sets,
        required this.reps,
        required this.duration,
    });

    factory Workoutexercise.fromJson(Map<String, dynamic> json) => _$WorkoutexerciseFromJson(json);

    Map<String, dynamic> toJson() => _$WorkoutexerciseToJson(this);
}


