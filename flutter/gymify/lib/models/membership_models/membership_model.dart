import 'package:json_annotation/json_annotation.dart';

part 'membership_model.g.dart';

@JsonSerializable()
class Membership {
    @JsonKey(name: "membership_id")
    final int membershipId;
    @JsonKey(name: "plan_type")
    final String planType;
    @JsonKey(name: "price")
    final String price;
    @JsonKey(name: "start_date")
    final DateTime? startDate;
    @JsonKey(name: "end_date")
    final DateTime? endDate;
    @JsonKey(name: "status")
    final String status;
    @JsonKey(name: "payment_status")
    final String paymentStatus;
    @JsonKey(name: "payment_method")
    final String paymentMethod;

    Membership({
        required this.membershipId,
        required this.planType,
        required this.price,
        required this.startDate,
        required this.endDate,
        required this.status,
        required this.paymentStatus,
        required this.paymentMethod,
    });

    factory Membership.fromJson(Map<String, dynamic> json) => _$MembershipFromJson(json);

    Map<String, dynamic> toJson() => _$MembershipToJson(this);
}
