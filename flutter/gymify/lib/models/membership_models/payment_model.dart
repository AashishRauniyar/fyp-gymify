import 'package:json_annotation/json_annotation.dart';

part 'payment_model.g.dart';

@JsonSerializable()
class Payment {
  @JsonKey(name: "payment_id")
  final int paymentId;
  @JsonKey(name: "membership_id")
  final int membershipId;
  @JsonKey(name: "user_id")
  final int userId;
  @JsonKey(name: "price")
  final String price;
  @JsonKey(name: "payment_method")
  final String paymentMethod;
  @JsonKey(name: "transaction_id")
  final String transactionId;
  @JsonKey(name: "payment_date")
  final DateTime paymentDate;
  @JsonKey(name: "payment_status")
  final String paymentStatus;
  @JsonKey(name: "created_at")
  final DateTime createdAt;

  Payment({
    required this.paymentId,
    required this.membershipId,
    required this.userId,
    required this.price,
    required this.paymentMethod,
    required this.transactionId,
    required this.paymentDate,
    required this.paymentStatus,
    required this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}
