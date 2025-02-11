// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MembershipPlan _$MembershipPlanFromJson(Map<String, dynamic> json) =>
    MembershipPlan(
      planId: (json['plan_id'] as num).toInt(),
      planType: json['plan_type'] as String,
      price: json['price'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$MembershipPlanToJson(MembershipPlan instance) =>
    <String, dynamic>{
      'plan_id': instance.planId,
      'plan_type': instance.planType,
      'price': instance.price,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
