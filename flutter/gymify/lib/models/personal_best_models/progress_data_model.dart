import 'package:json_annotation/json_annotation.dart';

part 'progress_data_model.g.dart';

@JsonSerializable()
class ProgressData {
  @JsonKey(name: "personal_best_id")
  final int personalBestId;
  
  @JsonKey(name: "weight")
  final String weight;
  
  @JsonKey(name: "reps")
  final int reps;
  
  @JsonKey(name: "achieved_at")
  final DateTime achievedAt;

  ProgressData({
    required this.personalBestId,
    required this.weight,
    required this.reps,
    required this.achievedAt,
  });

  factory ProgressData.fromJson(Map<String, dynamic> json) => 
      _$ProgressDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProgressDataToJson(this);
}
