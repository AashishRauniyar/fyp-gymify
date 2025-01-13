// lib/services/chat_service.dart
import 'package:gymify/models/chat_conversation.dart';
import 'package:gymify/models/chat_message.dart';
import 'package:gymify/network/http.dart';
import 'package:gymify/services/storage_service.dart';

class ChatService {
  
  final StorageService storageService;

  ChatService({
    
    required this.storageService,
  });

  Future<List<ChatConversation>> getConversations() async {
    final userId = await storageService.getString('user_id');
    final response = await httpClient.get('/chat/conversations/$userId');
    return (response.data['data'] as List)
        .map((json) => ChatConversation.fromJson(json))
        .toList();
  }

  Future<List<ChatMessage>> getMessages(int chatId) async {
    final response = await httpClient.get('/chat/messages/$chatId');
    return (response.data['data'] as List)
        .map((json) => ChatMessage.fromJson(json))
        .toList();
  }

  Future<ChatConversation> startConversation(int trainerId) async {
    final userId = await storageService.getString('user_id');
    final response = await httpClient.post('/chat/start', data: {
      'userId': userId,
      'trainerId': trainerId,
    });
    return ChatConversation.fromJson(response.data['data']);
  }
}