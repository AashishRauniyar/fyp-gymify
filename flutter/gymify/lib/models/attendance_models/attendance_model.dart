import 'package:json_annotation/json_annotation.dart';

part 'attendance_model.g.dart';

@JsonSerializable()
class Attendance {
    @JsonKey(name: "attendance_id")
    final int attendanceId;
    @JsonKey(name: "user_id")
    final int userId;
    @JsonKey(name: "gym_id")
    final dynamic gymId;
    @JsonKey(name: "attendance_date")
    final DateTime attendanceDate;
    @JsonKey(name: "UserInfo")
    final UserInfo userInfo;

    Attendance({
        required this.attendanceId,
        required this.userId,
        required this.gymId,
        required this.attendanceDate,
        required this.userInfo,
    });

    factory Attendance.fromJson(Map<String, dynamic> json) => _$AttendanceFromJson(json);

    Map<String, dynamic> toJson() => _$AttendanceToJson(this);
}

@JsonSerializable()
class UserInfo {
    @JsonKey(name: "user_name")
    final String userName;
    @JsonKey(name: "full_name")
    final String fullName;

    UserInfo({
        required this.userName,
        required this.fullName,
    });

    factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);

    Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}
