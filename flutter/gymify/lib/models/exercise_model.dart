import 'package:json_annotation/json_annotation.dart';

part 'exercise_model.g.dart';



@JsonSerializable()
class Exercise {
    @JsonKey(name: "exercise_id")
    final int exerciseId;
    @JsonKey(name: "exercise_name")
    final String exerciseName;
    @JsonKey(name: "description")
    final String description;
    @JsonKey(name: "target_muscle_group")
    final String targetMuscleGroup;
    @JsonKey(name: "calories_burned_per_minute")
    final String caloriesBurnedPerMinute;
    @JsonKey(name: "image_url")
    final String imageUrl;
    @JsonKey(name: "video_url")
    final String videoUrl;
    @JsonKey(name: "created_at")
    final DateTime createdAt;
    @JsonKey(name: "updated_at")
    final DateTime updatedAt;

    Exercise({
        required this.exerciseId,
        required this.exerciseName,
        required this.description,
        required this.targetMuscleGroup,
        required this.caloriesBurnedPerMinute,
        required this.imageUrl,
        required this.videoUrl,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Exercise.fromJson(Map<String, dynamic> json) => _$ExerciseFromJson(json);

    Map<String, dynamic> toJson() => _$ExerciseToJson(this);
}
