import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';


@JsonSerializable()
class Users {
    @JsonKey(name: "user_id")
    final int userId;
    @JsonKey(name: "user_name")
    final String userName;
    @JsonKey(name: "full_name")
    final String fullName;
    @JsonKey(name: "email")
    final String email;
    @JsonKey(name: "phone_number")
    final String phoneNumber;
    @JsonKey(name: "address")
    final String address;
    @JsonKey(name: "birthdate")
    final DateTime birthdate;
    @JsonKey(name: "height")
    final String height;
    @JsonKey(name: "current_weight")
    final String currentWeight;
    @JsonKey(name: "gender")
    final String gender;
    @JsonKey(name: "role")
    final String role;
    @JsonKey(name: "fitness_level")
    final String fitnessLevel;
    @JsonKey(name: "goal_type")
    final String goalType;
    @JsonKey(name: "allergies")
    final String allergies;
    @JsonKey(name: "profile_image")
    final String profileImage;
    @JsonKey(name: "created_at")
    final DateTime createdAt;
    @JsonKey(name: "updated_at")
    final DateTime updatedAt;

    Users({
        required this.userId,
        required this.userName,
        required this.fullName,
        required this.email,
        required this.phoneNumber,
        required this.address,
        required this.birthdate,
        required this.height,
        required this.currentWeight,
        required this.gender,
        required this.role,
        required this.fitnessLevel,
        required this.goalType,
        required this.allergies,
        required this.profileImage,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Users.fromJson(Map<String, dynamic> json) => _$UsersFromJson(json);

    Map<String, dynamic> toJson() => _$UsersToJson(this);
}
