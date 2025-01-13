// // lib/services/chat_socket_service.dart
// import 'package:flutter/material.dart';
// import 'package:gymify/models/chat_message.dart';
// import 'package:gymify/services/storage_service.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class ChatSocketService extends ChangeNotifier {
//   late IO.Socket _socket;
//   final StorageService _storageService;
//   bool _isConnected = false;
//   Map<int, List<ChatMessage>> _messagesByRoom = {};

//   ChatSocketService(this._storageService) {
//     _initializeSocket();
//   }

//   void _initializeSocket() async {
//     final token = await _storageService.getString('auth_token');
    
//     _socket = IO.io(
//       'ws://localhost:8000/',
//       IO.OptionBuilder()
//         .setTransports(['websocket'])
//         .setExtraHeaders({'Authorization': 'Bearer $token'})
//         .build()
//     );

//     _setupListeners();
//     _socket.connect();
//   }

//   void _setupListeners() async {
//     final userId = await _storageService.getString('user_id');
    
//     _socket.onConnect((_) {
//       _isConnected = true;
//       _socket.emit('register', {'userId': userId});
//       notifyListeners();
//     });

//     _socket.on('receive_message', (data) {
//       final message = ChatMessage.fromJson(data);
//       _addMessage(message);
//     });
//   }

//   void sendMessage(int chatId, String text) async {
//     final userId = await _storageService.getString('user_id');
    
//     _socket.emit('send_message', {
//       'chatId': chatId,
//       'userId': userId,
//       'messageContent': {'text': text},
//     });
//   }

//   void joinRoom(int chatId) async {
//     final userId = await _storageService.getString('user_id');
//     _socket.emit('join_room', {'chatId': chatId, 'userId': userId});
//   }

//   List<ChatMessage> getMessagesForRoom(int chatId) {
//     return _messagesByRoom[chatId] ?? [];
//   }
// }