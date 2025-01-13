import 'package:json_annotation/json_annotation.dart';

part 'chat_conversation.g.dart';




// lib/models/chat_conversation.dart
@JsonSerializable()
class ChatConversation {
  final int chatId;
  final int userId;
  final int trainerId;
  final String? lastMessage;
  final DateTime? lastMessageTimestamp;

  ChatConversation({
    required this.chatId,
    required this.userId,
    required this.trainerId,
    this.lastMessage,
    this.lastMessageTimestamp,
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json) => _$ChatConversationFromJson(json);
  Map<String, dynamic> toJson() => _$ChatConversationToJson(this);
}