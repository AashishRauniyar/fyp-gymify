import 'package:json_annotation/json_annotation.dart';

part 'chat_message.g.dart';


// lib/models/chat_message.dart
@JsonSerializable()
class ChatMessage {
  final int id;
  final int chatId;
  final int senderId;
  final Map<String, dynamic> messageContent;
  final DateTime sentAt;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.messageContent,
    required this.sentAt,
    required this.isRead,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}

