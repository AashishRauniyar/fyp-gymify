// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllUserModel _$AllUserModelFromJson(Map<String, dynamic> json) => AllUserModel(
      userId: (json['user_id'] as num).toInt(),
      userName: json['user_name'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$AllUserModelToJson(AllUserModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'user_name': instance.userName,
      'role': instance.role,
    };
