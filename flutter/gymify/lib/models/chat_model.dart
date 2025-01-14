// import 'package:json_annotation/json_annotation.dart';

// part 'chat_model.g.dart';

// @JsonSerializable()
// class ChatModel {
//     @JsonKey(name: "chat_id")
//     final int chatId;
//     @JsonKey(name: "user_id")
//     final int userId;
//     @JsonKey(name: "trainer_id")
//     final int trainerId;
//     @JsonKey(name: "last_message")
//     final dynamic lastMessage;
//     @JsonKey(name: "last_message_timestamp")
//     final DateTime lastMessageTimestamp;

//     ChatModel({
//         required this.chatId,
//         required this.userId,
//         required this.trainerId,
//         required this.lastMessage,
//         required this.lastMessageTimestamp,
//     });

//     factory ChatModel.fromJson(Map<String, dynamic> json) => _$ChatModelFromJson(json);

//     Map<String, dynamic> toJson() => _$ChatModelToJson(this);
// }
