// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      paymentId: (json['payment_id'] as num).toInt(),
      membershipId: (json['membership_id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      price: json['price'] as String,
      paymentMethod: json['payment_method'] as String,
      transactionId: json['transaction_id'] as String,
      paymentDate: DateTime.parse(json['payment_date'] as String),
      paymentStatus: json['payment_status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'payment_id': instance.paymentId,
      'membership_id': instance.membershipId,
      'user_id': instance.userId,
      'price': instance.price,
      'payment_method': instance.paymentMethod,
      'transaction_id': instance.transactionId,
      'payment_date': instance.paymentDate.toIso8601String(),
      'payment_status': instance.paymentStatus,
      'created_at': instance.createdAt.toIso8601String(),
    };
