import 'package:json_annotation/json_annotation.dart';

part 'weight_history_model.g.dart';


@JsonSerializable()
class WeightHistory {
    @JsonKey(name: "weight")
    final String weight;
    @JsonKey(name: "logged_at")
    final DateTime loggedAt;

    WeightHistory({
        required this.weight,
        required this.loggedAt,
    });

    factory WeightHistory.fromJson(Map<String, dynamic> json) => _$WeightHistoryFromJson(json);

    Map<String, dynamic> toJson() => _$WeightHistoryToJson(this);
}
