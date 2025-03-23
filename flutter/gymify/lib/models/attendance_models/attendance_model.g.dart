// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attendance _$AttendanceFromJson(Map<String, dynamic> json) => Attendance(
      attendanceId: (json['attendance_id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      gymId: json['gym_id'],
      attendanceDate: DateTime.parse(json['attendance_date'] as String),
      userInfo: UserInfo.fromJson(json['UserInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AttendanceToJson(Attendance instance) =>
    <String, dynamic>{
      'attendance_id': instance.attendanceId,
      'user_id': instance.userId,
      'gym_id': instance.gymId,
      'attendance_date': instance.attendanceDate.toIso8601String(),
      'UserInfo': instance.userInfo,
    };

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      userName: json['user_name'] as String,
      fullName: json['full_name'] as String,
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'user_name': instance.userName,
      'full_name': instance.fullName,
    };
