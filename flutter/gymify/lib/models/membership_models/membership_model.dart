import 'package:gymify/models/membership_models/membership_plan_model.dart';
import 'package:gymify/models/membership_models/payment_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'membership_model.g.dart';

@JsonSerializable()
class Membership {
  @JsonKey(name: "membership_id")
  final int membershipId;
  @JsonKey(name: "user_id")
  final int userId;
  @JsonKey(name: "plan_id")
  final int planId;
  @JsonKey(name: "start_date")
  final DateTime startDate;
  @JsonKey(name: "end_date")
  final DateTime endDate;
  @JsonKey(name: "status")
  final String status;
  @JsonKey(name: "created_at")
  final DateTime createdAt;
  @JsonKey(name: "updated_at")
  final DateTime updatedAt;
  @JsonKey(name: "membership_plan")
  final MembershipPlan membershipPlan;
  @JsonKey(name: "payments")
  final List<Payment> payments;

  Membership({
    required this.membershipId,
    required this.userId,
    required this.planId,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.membershipPlan,
    required this.payments,
  });

  factory Membership.fromJson(Map<String, dynamic> json) =>
      _$MembershipFromJson(json);

  Map<String, dynamic> toJson() => _$MembershipToJson(this);
}
