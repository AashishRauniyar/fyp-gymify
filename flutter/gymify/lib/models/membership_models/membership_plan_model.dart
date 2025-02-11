import 'package:json_annotation/json_annotation.dart';

part 'membership_plan_model.g.dart';

@JsonSerializable()
class MembershipPlan {
  @JsonKey(name: "plan_id")
  final int planId;
  @JsonKey(name: "plan_type")
  final String planType;
  @JsonKey(name: "price")
  final String price;
  @JsonKey(name: "created_at")
  final DateTime createdAt;
  @JsonKey(name: "updated_at")
  final DateTime updatedAt;

  MembershipPlan({
    required this.planId,
    required this.planType,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MembershipPlan.fromJson(Map<String, dynamic> json) =>
      _$MembershipPlanFromJson(json);

  Map<String, dynamic> toJson() => _$MembershipPlanToJson(this);
}
