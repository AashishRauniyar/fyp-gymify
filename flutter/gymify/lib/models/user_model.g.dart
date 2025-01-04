// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Users _$UsersFromJson(Map<String, dynamic> json) => Users(
      userId: (json['user_id'] as num).toInt(),
      userName: json['user_name'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String,
      address: json['address'] as String,
      birthdate: DateTime.parse(json['birthdate'] as String),
      height: json['height'] as String,
      currentWeight: json['current_weight'] as String,
      gender: json['gender'] as String,
      role: json['role'] as String,
      fitnessLevel: json['fitness_level'] as String,
      goalType: json['goal_type'] as String,
      allergies: json['allergies'] as String,
      profileImage: json['profile_image'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$UsersToJson(Users instance) => <String, dynamic>{
      'user_id': instance.userId,
      'user_name': instance.userName,
      'full_name': instance.fullName,
      'email': instance.email,
      'phone_number': instance.phoneNumber,
      'address': instance.address,
      'birthdate': instance.birthdate.toIso8601String(),
      'height': instance.height,
      'current_weight': instance.currentWeight,
      'gender': instance.gender,
      'role': instance.role,
      'fitness_level': instance.fitnessLevel,
      'goal_type': instance.goalType,
      'allergies': instance.allergies,
      'profile_image': instance.profileImage,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
