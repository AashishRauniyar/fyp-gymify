import 'package:json_annotation/json_annotation.dart';

part 'supported_exercise_model.g.dart';


@JsonSerializable()
class SupportedExercise {
    @JsonKey(name: "supported_suppoSupportedExercise_id")
    final int supportedSupportedExerciseId;
    @JsonKey(name: "suppoSupportedExercise_name")
    final String suppoSupportedExerciseName;
    @JsonKey(name: "created_at")
    final DateTime createdAt;
    @JsonKey(name: "updated_at")
    final DateTime updatedAt;

    SupportedExercise({
        required this.supportedSupportedExerciseId,
        required this.suppoSupportedExerciseName,
        required this.createdAt,
        required this.updatedAt,
    });

    factory SupportedExercise.fromJson(Map<String, dynamic> json) => _$SupportedExerciseFromJson(json);

    Map<String, dynamic> toJson() => _$SupportedExerciseToJson(this);
}
