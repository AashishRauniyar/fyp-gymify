import 'package:json_annotation/json_annotation.dart';

part 'personal_best_model.g.dart';

@JsonSerializable()
class PersonalBest {
    @JsonKey(name: "personal_best_id")
    final int personalBestId;
    @JsonKey(name: "user_id")
    final int userId;
    @JsonKey(name: "supported_exercise_id")
    final int supportedExerciseId;
    @JsonKey(name: "weight")
    final String weight;
    @JsonKey(name: "reps")
    final int reps;
    @JsonKey(name: "achieved_at")
    final DateTime achievedAt;

    PersonalBest({
        required this.personalBestId,
        required this.userId,
        required this.supportedExerciseId,
        required this.weight,
        required this.reps,
        required this.achievedAt,
    });

    factory PersonalBest.fromJson(Map<String, dynamic> json) => _$PersonalBestFromJson(json);

    Map<String, dynamic> toJson() => _$PersonalBestToJson(this);
}
