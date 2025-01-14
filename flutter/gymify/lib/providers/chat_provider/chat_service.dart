import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gymify/constant/api_constant.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatProvider extends ChangeNotifier {
  IO.Socket? _socket;
  final List<Map<String, dynamic>> _messages = [];
  String _connectionStatus = 'Disconnected';

  bool _isListening = false; // Prevent multiple listener

IO.Socket? get socket => _socket;
  List<Map<String, dynamic>> get messages => _messages;
  String get connectionStatus => _connectionStatus;

  Future<int> startConversation(int userId, int trainerId) async {
    const url = "$baseUrl/start";
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'trainerId': trainerId}),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['data']['chat_id'];
    } else {
      throw Exception('Failed to start conversation');
    }
  }

  void initializeSocket(String userId) {
    if (_socket != null && _socket!.connected) {
      print('Socket is already initialized and connected');
      return;
    }

    _socket = IO.io(
      'ws://192.168.31.96:8000/', // Replace with your server IP address
      IO.OptionBuilder()
          .setTransports(['websocket']) // Use WebSocket transport
          .disableAutoConnect()
          .build(),
    );

    _socket!.connect();

    // Handle successful connection
    _socket!.onConnect((_) {
      print("Socket connected");
      _socket!.emit('register', {'userId': userId});
      _connectionStatus = 'Connected';
      notifyListeners();
    });

    // Handle disconnection
    _socket!.onDisconnect((_) {
      print("Socket disconnected");
      _connectionStatus = 'Disconnected';
      notifyListeners();
    });

    // Handle connection errors
    _socket!.on('connect_error', (data) {
      print('Connection Error: $data');
      _connectionStatus = 'Connection Error';
      notifyListeners();
    });

    listenToMessages();
  }

  void listenToMessages() {
    if (_isListening) return; // Exit if listeners are already set up
    _isListening = true;

    _socket!.on('register-success', (data) {
      print('register-success: $data');
    });

    _socket!.on('receive_message', (data) {
      print('Message Received: $data');
      if (data != null) {
        _messages.add(data); // Add the received message to the list
        notifyListeners(); // Notify the UI to rebuild
      }
    });

    _socket!.on('joined_room', (data) {
      print('User Joined: $data');
    });

    _socket!.on('user_typing', (data) {
      print('User Typing: $data');
    });

    _socket!.on('user_stopped_typing', (data) {
      print('User Stopped Typing: $data');
    });
  }

  void sendMessage(int chatId, String userId, String message) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('send_message', {
        'chatId': chatId,
        'userId': userId,
        'messageContent': {'text': message},
      });

      _messages.add({'userId': userId, 'text': message});
      notifyListeners();
    } else {
      print('Socket is not connected. Cannot send message.');
    }
  }

  void joinRoom(int chatId, int userId) {
    if (_socket != null && _socket!.connected) {
      print('Joining room: $chatId');
      _socket!.emit('join_room', {'chatId': chatId, 'userId': userId});
    } else {
      print('Socket is not connected. Cannot join room.');
    }
  }

  void disconnectSocket() {
    if (_socket != null) {
      _socket!.disconnect();
      _connectionStatus = 'Disconnected';
      notifyListeners();
    }
  }
}
