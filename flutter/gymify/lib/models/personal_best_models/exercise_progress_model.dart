import 'package:gymify/models/personal_best_models/progress_data_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'supported_exercise_model.dart';

part 'exercise_progress_model.g.dart';

@JsonSerializable()
class ExerciseProgress {
  @JsonKey(name: "exercise")
  final SupportedExercise exercise;
  
  @JsonKey(name: "progressData")
  final List<ProgressData> progressData;

  ExerciseProgress({
    required this.exercise,
    required this.progressData,
  });

  factory ExerciseProgress.fromJson(Map<String, dynamic> json) => 
      _$ExerciseProgressFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseProgressToJson(this);
}
