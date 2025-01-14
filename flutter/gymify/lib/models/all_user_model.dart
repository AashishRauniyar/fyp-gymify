import 'package:json_annotation/json_annotation.dart';

part 'all_user_model.g.dart';

@JsonSerializable()
class AllUserModel {
    @JsonKey(name: "user_id")
    final int userId;
    @JsonKey(name: "user_name")
    final String userName;
    @JsonKey(name: "role")
    final String role;

    AllUserModel({
        required this.userId,
        required this.userName,
        required this.role,
    });

    factory AllUserModel.fromJson(Map<String, dynamic> json) => _$AllUserModelFromJson(json);

    Map<String, dynamic> toJson() => _$AllUserModelToJson(this);
}
