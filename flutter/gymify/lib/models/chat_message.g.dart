// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      id: (json['id'] as num).toInt(),
      chatId: (json['chatId'] as num).toInt(),
      senderId: (json['senderId'] as num).toInt(),
      messageContent: json['messageContent'] as Map<String, dynamic>,
      sentAt: DateTime.parse(json['sentAt'] as String),
      isRead: json['isRead'] as bool,
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chatId': instance.chatId,
      'senderId': instance.senderId,
      'messageContent': instance.messageContent,
      'sentAt': instance.sentAt.toIso8601String(),
      'isRead': instance.isRead,
    };
